-- Kizrak


local script,kprint = require('k-lib')()


local vonn = {}

vonn.kprint = kprint

vonn.eventNameMapping = {}
for eventName,eventId in pairs(defines.events) do
	vonn.eventNameMapping[eventId] = eventName
end


local sb = serpent.block -- luacheck: ignore 211


function vonn.newPlayer(event)
	local player_index=event.player_index
	local player=game.players[player_index]
	local eventName = vonn.eventNameMapping[event.name]
	vonn.kprint("newPlayer: ".. player.name .. "   " .. eventName,{r=255,g=255})

	if player.connected and player.character then
		local vonnCharacter = player.surface.create_entity{name="vonn",position=player.character.position,force=player.force}
		vonnCharacter.destructible = false
		player.character.destroy()
		player.character = vonnCharacter
		player.spectator = true
		player.cheat_mode = true
	end

	--store player in global storage
	if not global.players then
		global.players = {}
	end

	global.players[event.player_index] = {
		crafted = {}
	}

	local numberPlayers = #game.players
	local msg = "newPlayer complete: " .. numberPlayers
	vonn.kprint(msg)
end

script.on_event({
--defines.events.on_player_joined_game,
defines.events.on_player_created,
defines.events.on_player_respawned,
},vonn.newPlayer)


function vonn.craftEvent(event)
	local player_index = event.player_index
	--local recipe = event.recipe
	--local items = event.items

	local player=game.players[player_index]
	vonn.kprint("Player tried to craft: " .. player.name)

	local lastItem = nil
	while player.crafting_queue do
		lastItem = player.crafting_queue[1]
		player.cancel_crafting{index=1, count=lastItem.count}
	end

	player.cursor_ghost = lastItem.item
end

script.on_event({
	defines.events.on_pre_player_crafted_item,
},vonn.craftEvent)


function vonn.on_player_crafted_item(event)
	local player_index = event.player_index
	local player=game.players[player_index]
	--local recipe = event.recipe
	--local items = event.items
	--local eventName = vonn.eventNameMapping[event.name]
	local item_stack = event.item_stack

	local name = item_stack.name
	vonn.kprint("Player crafted: " .. player.name .. "   `" .. name .. "`   " .. item_stack.count)

	local banned = {
		["copper-cable"] = true,
		["effectivity-module"] = true,
		["effectivity-module-2"] = true,
		["effectivity-module-3"] = true,
		["productivity-module"] = true,
		["productivity-module-1"] = true,
		["productivity-module-2"] = true,
		["speed-module"] = true,
		["speed-module-2"] = true,
		["speed-module-3"] = true,
	}

	if banned[name] then
		-- TODO: remove items on the next tick
		player.remove_item({name=name, count=2000})
		global.players[player_index].crafted = {name = name, count = item_stack.count}
	end
end

script.on_event({
	defines.events.on_player_crafted_item,
},vonn.on_player_crafted_item)


function vonn.on_picked_up_item(event)
	local player_index = event.player_index
	local player=game.players[player_index]
	local item_stack  = event.item_stack

	local name = item_stack.name
	local count = item_stack.count

	--vonn.kprint(game.tick .. " on_picked_up_item " .. name .. " " .. count)
	vonn.spillPlayerItemsAtPlayer(player, {[name]=count} )
end

script.on_event({
	defines.events.on_picked_up_item,
},vonn.on_picked_up_item)


function vonn.disableMining(player)
	if player.mining_state.mining then
		if player.selected and player.selected.type == "entity-ghost" then
			-- allow "mining" entity-ghost
			log(player.selected)
		elseif player.selected then
			player.mining_state = {mining = false}
			vonn.kprint("Player tried to mine: " .. player.name .. "   " .. player.selected.type .. " !")
			player.selected.order_deconstruction(player.force,player)
		else
			player.mining_state = {mining = false}
			vonn.kprint("Player tried to mine: " .. player.name)
		end
	end
end


function vonn.on_tick(_)
	for i, player in pairs(game.players) do
		if player.connected then
			vonn.disableMining(player)
		end
	end
end

script.on_event({defines.events.on_tick},vonn.on_tick)


function vonn.stopBuilding(event)
	local created_entity = event.created_entity
	local player_index = event.player_index
	--local stack = event.stack
	local item = event.item

	local player=game.players[player_index]

	if item then
		if created_entity.type == "entity-ghost" then
			-- allow ghosts
			log(player.name .. " tried to build "..item.name .. "   " ..created_entity.type)
		else
			vonn.kprint(player.name .. " tried to build "..item.name .. "   " ..created_entity.type)
			-- return item
			-- TODO: iterate over all 8 inventories
			local inventory = player.get_inventory(defines.inventory.character_main)
			inventory.insert({name=item.name})
			created_entity.destroy()
		end
	else
		log(player.name .. " does not want to build (item=nil)")
	end
end

script.on_event({defines.events.on_built_entity},vonn.stopBuilding)


vonn.acceptable_inventory = {
	["blueprint"] = true,
	["blueprint-book"] = true,
	["deconstruction-planner"] = true,
	["upgrade-planner"] = true,
	["copy-paste-tool"] = true,
	["cut-paste-tool"] = true,
	["copper-cable"] = true,
	["green-wire"] = true,
	["red-wire"] = true,
	["effectivity-module"] = true,
	["effectivity-module-2"] = true,
	["effectivity-module-3"] = true,
	["productivity-module"] = true,
	["productivity-module-1"] = true,
	["productivity-module-2"] = true,
	["speed-module"] = true,
	["speed-module-2"] = true,
	["speed-module-3"] = true,
	["artillery-targeting-remote"] = true,
	-- TODO: decide to add coal|wood to list?
}

function vonn.countContentForBadItems(badItems,contents)
	for item, count in pairs (contents) do
		if vonn.acceptable_inventory[item] then -- luacheck: ignore 542
			-- ignore acceptable inventory item
		else
			if not badItems[item] then
				badItems[item] = 0
			end
			badItems[item] = count + badItems[item]
		end
	end
end

function vonn.getBadItemsForPlayer(player)
	-- TODO: iterate over all 8 inventories
	local inventory = player.get_inventory(defines.inventory.character_main)
	local contents = inventory.get_contents()

	local badItems = {}

	vonn.countContentForBadItems(badItems,contents)

	if player.cursor_stack.valid and player.cursor_stack.valid_for_read then
		local cursor_stack = player.cursor_stack
		local item = cursor_stack.name
		if not vonn.acceptable_inventory[item] then
			local count = cursor_stack.count
			if not badItems[item] then
				badItems[item] = 0
			end
			badItems[item] = count + badItems[item]

			player.cursor_ghost = item
		end
	end

	--vonn.kprint("badItems: " .. serpent.block(badItems) .. "  " .. table_size(badItems))
	return badItems
end

function vonn.removeBadItemsFromPlayer(player)
	local badItems = vonn.getBadItemsForPlayer(player)

	local itemsRemoved = {}

	for item,count in pairs(badItems) do
		log("vonn.getBadItemsForPlayer: "..item)
		local removedCount = player.remove_item({name=item, count=count})
		if not itemsRemoved[item] then
			itemsRemoved[item] = 0
		end
		itemsRemoved[item] = removedCount + itemsRemoved[item]
	end

	--vonn.kprint("itemsRemoved: " .. serpent.block(itemsRemoved) .. "  " .. table_size(itemsRemoved))
	return itemsRemoved
end


function vonn.insertItemIntoEntityInventory(entity, item, count)
	-- defines.inventory.* always give a number between 1 and 8
	for inventoryIndex=1,8 do
		local inventory = entity.get_inventory(inventoryIndex)
		if inventory ~= nil and inventory.valid and count > 0then
			local inserted = inventory.insert({name=item, count=count})
			count = count - inserted
		end
	end

	return count
end

function vonn.restoreRemovedItemsToOpenEntity(player,itemsRemoved)
	local uninsertableItems = {}
	local entity = player.opened

	for item,count in pairs(itemsRemoved) do
		local uninsertableCount = vonn.insertItemIntoEntityInventory(entity, item, count)
		if uninsertableCount>0 then
			if not uninsertableItems[item] then
				uninsertableItems[item] = 0
			end
			uninsertableItems[item] = uninsertableCount + uninsertableItems[item]
		end
	end

	return uninsertableItems
end

function vonn.spillPlayerItems(player,surface,uninsertableItems)
	local position = player.position
	if player.opened then
		position = player.opened.position
	end
	if player.selected then
		position = player.selected.position
	end
	surface = game.surfaces[surface]
	local sum = 0

	local globalCraftedItem = global.players[player.index].crafted

	for item,count in pairs(uninsertableItems) do
		if not item.name == globalCraftedItem.name then
			surface.spill_item_stack(position,{name=item, count=count},false,player.force,false)
			sum = count + sum
		end
	end

	return sum
end

function vonn.spillPlayerItemsAtPlayer(player,itemsRemoved)
	for item,count in pairs(itemsRemoved) do
		player.surface.spill_item_stack(player.position,{name=item, count=count},false,player.force,false)
	end
end

function vonn.on_player_inventory_changed(event)
	local player_index = event.player_index
	local player = game.players[player_index]
	--local eventName = vonn.eventNameMapping[event.name]

	local itemsRemoved = vonn.removeBadItemsFromPlayer(player)

	if table_size(itemsRemoved) == 1 then
		for item,_ in pairs(itemsRemoved) do
			vonn.kprint(player.name .. " tried to pick up " .. item .. "!")
		end
	elseif table_size(itemsRemoved) > 0 then
		vonn.kprint(player.name .. " tried to pick up items!")
	end

	if player.opened and player.opened.valid and defines.gui_type.entity == player.opened_gui_type then
		local uninsertableItems = vonn.restoreRemovedItemsToOpenEntity(player,itemsRemoved)

		if table_size(uninsertableItems) > 0 then
			local sum = vonn.spillPlayerItems(player,"nauvis",uninsertableItems)
			vonn.kprint("spilled items: " .. sum)
		end

	else
		if table_size(itemsRemoved) == 1 then
			-- assume player cheat_mode crafted an item, so ghost it
			for item,_ in pairs(itemsRemoved) do
				player.cursor_ghost = item
				player.remove_item(item)
				global.players[event.player_index].crafted = {}
			end
		end

		if table_size(itemsRemoved) > 0 then
			local sum = vonn.spillPlayerItems(player,player.surface.name,itemsRemoved)
			game.print("spilled items: " .. sum)
		end
	end


	--local existing_entities = game.surfaces["nauvis"].find_entities({{-1, -1}, {1, 1}})
	--for i, entity in pairs(existing_entities) do
		--TODO: drain power for each bad item &| transport items to crash-site
	--end
end

script.on_event({
defines.events.on_player_ammo_inventory_changed,
defines.events.on_player_armor_inventory_changed,
defines.events.on_player_gun_inventory_changed,
defines.events.on_player_main_inventory_changed,
defines.events.on_player_trash_inventory_changed,
defines.events.on_player_cursor_stack_changed,
},vonn.on_player_inventory_changed)


function vonn.on_player_pipette(event)
	local player_index = event.player_index
	local player = game.players[player_index]
	--local eventName = vonn.eventNameMapping[event.name]
	--local item  = event.item
	--local used_cheat_mode  = event.used_cheat_mode

	--vonn.kprint(item.name .. "  " .. tostring(used_cheat_mode))
	--vonn.kprint(player.cursor_stack.name .. "   " .. player.cursor_stack.count)
	player.cursor_ghost = player.cursor_stack.name
	player.cursor_stack.count = 0
end

script.on_event({
	defines.events.on_player_pipette
},vonn.on_player_pipette)


script.register_object(vonn)


return vonn

-- Lua API TODOs

-- /toggle-heavy-mode
-- /c __warptorio2__ warptorio.warpout()
-- https://forums.factorio.com/viewtopic.php?f=25&t=67140
-- ...\Steam\steamapps\common\Factorio\data\*.lua

-- request API for night vision and map film-grain (Mengmoshu)
-- LuaPlayer: cursor_ghost, teleport, disable_recipe_groups, disable_recipe_subgroups
-- LuaPlayer: add_alert, add_custom_alert, play_sound, afk_time, online_time, last_online, display_resolution, display_scale, rendor_mode

-- data.raw["utility-constants"].zoom_to_world_effect_strength = 0
-- data.raw["utility-constants"].zoom_to_world_darkness_multiplier = 0.5

-- LuaForce.html#LuaForce.manual_mining_speed_modifier

-- /c game.surfaces["nauvis"].spill_item_stack({0,0},{name="roboport", count=21},false,"player",false)
-- /silent-command game.surfaces["nauvis"].spill_item_stack({0,0},{name="construction-robot", count=250},false,"player",false)
-- /silent-command game.surfaces["nauvis"].spill_item_stack({0,0},{name="logistic-robot", count=0},false,"player",false)

-- game.create_profiler()
-- data.raw["map-gen-presets"].default["pvp-ribbonworld"]
-- defines.command.go_to_location

