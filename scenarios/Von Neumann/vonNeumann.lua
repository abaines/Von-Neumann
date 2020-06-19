-- Kizrak


local script,kprint,reverseEventLookup = require('k-lib')()


local vonn = {}


local sb = serpent.block -- luacheck: ignore 211


local function sbs(obj)
	local s = sb( obj ):gsub("%s+", " ")
	return s
end


local msgCount = 0


--- spawning new player
function vonn.setupPlayer(player)

	local vonnCharacter = player.surface.create_entity{name="vonn",position=player.character.position,force=player.force}
	vonnCharacter.destructible = false
	player.character.destroy()
	player.character = vonnCharacter
	player.spectator = true

	player.force.manual_mining_speed_modifier = -0.9999999

	local numberOfPlayers = #game.players
	local msg = "vonn.setupPlayer " .. player.name .. " (" .. numberOfPlayers .. ")"
	log(msg)
end


function vonn.on_player_created(event)
	local player_index=event.player_index
	local player=game.players[player_index]
	local eventName = reverseEventLookup(event.name)

	vonn.setupPlayer(player)

	global.created_players = global.created_players or {}

	if global.created_players[player.name] then
		kprint("===== " .. msgCount .. " =====")
		kprint(game.tick.." "..eventName)
		msgCount = 1 + msgCount
	end

	global.created_players[player.name] = true
end

script.on_event({
defines.events.on_player_created,
},vonn.on_player_created)


function vonn.on_player_respawned(event)
	local player_index=event.player_index
	local player=game.players[player_index]
	local eventName = reverseEventLookup(event.name)

	vonn.setupPlayer(player)

	kprint("===== " .. msgCount .. " =====")
	kprint(game.tick.." "..eventName)
	msgCount = 1 + msgCount
end

script.on_event({
defines.events.on_player_respawned,
},vonn.on_player_respawned)


--- drop items on ground at player, and remove them from player
function vonn.spillPlayerItemsAtPlayer(player,item_stack)

	player.remove_item(item_stack)

	player.surface.spill_item_stack(
		player.position, -- position
		item_stack, -- items to spill
		false, -- enable_looted
		player.force -- marked for deconstruction by this force
	)

end

function vonn.on_picked_up_item(event)
	local player_index = event.player_index
	local player=game.players[player_index]
	local item_stack  = event.item_stack

	vonn.spillPlayerItemsAtPlayer(player, item_stack)
end

script.on_event({
defines.events.on_picked_up_item,
},vonn.on_picked_up_item)



-- https://lua-api.factorio.com/latest/defines.html#defines.input_action
-- https://lua-api.factorio.com/latest/LuaPermissionGroup.html#LuaPermissionGroup.set_allows_action



function vonn.on_player_cursor_stack_changed(event)
	local player=game.players[event.player_index]
	-- TODO ----------------------------------------------------------------------------------------
	local eventName = reverseEventLookup(event.name)
	kprint("===== " .. msgCount .. " =====", {g=255,r=128})
	event.event = eventName
	kprint(sbs( event ), {g=255,r=128})
	if player.cursor_stack.valid_for_read then
		kprint(sbs( player.cursor_stack.name ), {g=255,r=128})
	end
	if player.cursor_ghost then
		kprint(sbs( player.cursor_ghost.name ), {g=255,r=128})
	end
	msgCount = 1 + msgCount
end

script.on_event({
	defines.events.on_player_cursor_stack_changed,
},vonn.on_player_cursor_stack_changed)


function checkIfPrototypeBad(item_prototype)
	log(sb( item_prototype.name ))

	if item_prototype.module_effects then
		return false
	end

	if item_prototype.entity_filter_slots then
		return false
	end

	if item_prototype.mapper_count then
		return false
	end

	local itemType = item_prototype.type

	if itemType == "blueprint" then
		return false
	end

	log("type: " .. sb( item_prototype.type ))

	return true
end


function checkForBadItems(player)
	local badItems = {}
	for i=0,8 do
		local inventory = player.get_inventory(i)
		if inventory and inventory.valid then
			local contents = inventory.get_contents()
			for itemName,itemCount in pairs(contents) do
				local item_prototype = game.item_prototypes[itemName]
				if checkIfPrototypeBad(item_prototype) then
					if not badItems[itemName] then
						badItems[itemName] = 0
					end
					badItems[itemName] = itemCount + badItems[itemName]
				end
			end
		end
	end
	return badItems
end

function vonn.on_player_main_inventory_changed(event)
	local player_index = event.player_index
	local player=game.players[player_index]

	local selected = player.selected
	local opened = player.opened

	if (selected or opened) then -- luacheck: ignore 542
		-- Yay!
	else
		local badItems = checkForBadItems(player)
		if table_size(badItems)>0 then
			-- TODO ----------------------------------------------------------------------------------------
			local eventName = reverseEventLookup(event.name)
			kprint("===== " .. msgCount .. " =====", {r=255,g=102})
			kprint("Problem: no selected or opened", {r=255,g=102})
			event.event = eventName
			kprint(sbs( event ), {r=255,g=102})
			kprint(sbs( badItems ))
			msgCount = 1 + msgCount
		end
	end
end

script.on_event({
	defines.events.on_player_main_inventory_changed,
},vonn.on_player_main_inventory_changed)


function vonn.on_player_fast_transferred(event)
	-- TODO ----------------------------------------------------------------------------------------
	local eventName = reverseEventLookup(event.name)
	kprint("===== " .. msgCount .. " =====")
	kprint(game.tick.." "..eventName, {r=255,g=255,b=255})
	kprint(sbs( event ), {r=255,g=255,b=255})
	msgCount = 1 + msgCount
end

script.on_event({
	defines.events.on_player_fast_transferred,
},vonn.on_player_fast_transferred)


function vonn.on_entity_settings_pasted(event)
	-- TODO ----------------------------------------------------------------------------------------
	local eventName = reverseEventLookup(event.name)
	kprint("===== " .. msgCount .. " =====")
	kprint(game.tick.." "..eventName, {r=255,g=255,b=255})
	kprint(sbs( event ), {r=255,g=255,b=255})
	msgCount = 1 + msgCount
end

script.on_event({
	defines.events.on_entity_settings_pasted,
},vonn.on_entity_settings_pasted)


-- disable building?
-- disable mining tiles?
-- mining attempt = deconstruct?


function vonn.reportBug(event)
	local eventName = reverseEventLookup(event.name)
	kprint("===== " .. msgCount .. " =====")
	kprint(game.tick.." "..eventName, {r=255})
	kprint(sbs( event ), {r=255})
	msgCount = 1 + msgCount
end

script.on_event({
	-- defines.events.on_built_entity,
	defines.events.on_pre_player_crafted_item,
	defines.events.on_player_crafted_item,
	defines.events.on_player_ammo_inventory_changed,
	defines.events.on_player_armor_inventory_changed,
	defines.events.on_player_gun_inventory_changed,
	defines.events.on_player_trash_inventory_changed,
	defines.events.on_player_pipette,
	defines.events.on_player_dropped_item,
	defines.events.on_pre_player_mined_item,
	-- defines.events.on_put_item,
},vonn.reportBug)



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

