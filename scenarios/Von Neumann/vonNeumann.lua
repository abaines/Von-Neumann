-- Kizrak

--- needs "hijack"

local eventNameMapping = {}
for eventName,eventId in pairs(defines.events) do
	eventNameMapping[eventId] = eventName
end

vonn = {}

function vonn.kprint(msg)
	print(msg)
	log(msg)
	if not game.is_multiplayer() then
		game.print(msg,{r=255,g=255})
	end
end



function vonn.tableSize(someTable)
	local count = 0
	for _,_ in pairs(someTable) do
		count = 1 + count
	end
	return count
end


local default_accumulator_buffer = 5000000 -- accumulator is 5 MJ
function vonn.createCrashSiteGenerator(position)
	local electricEnergyInterface = vonn.createEntity{name="crash-site-generator",position=position}
	local energy = default_accumulator_buffer*600 -- 3 GJ

	electricEnergyInterface.power_production = 15000 -- 900kW
	electricEnergyInterface.electric_buffer_size  = energy
	electricEnergyInterface.energy  = energy

	return electricEnergyInterface
end


function vonn.createEntity(options)
	if type(options.name)~="string" then
		error("no name: "..type(options.name))
	elseif type(options.position)~="table" then
		error("no position: "..type(options.position))
	end

	local entity = game.surfaces[options.surface or "nauvis"].create_entity{
		name=options.name,
		position=options.position,
		force=options.force or "player"
	}

	entity.minable = false
	entity.destructible = true
	entity.rotatable = true
	entity.operable = true

	return entity
end


function vonn.createSiteChest(options,itemsTable)
	local entity = vonn.createEntity(options)

	for k, v in pairs (itemsTable) do
		entity.insert({name = k, count = v})
	end

	return entity
end

function vonn.randomTableElement(someTable)
	local keys = {}
	for key in pairs(someTable) do
		table.insert(keys,key)
	end
	return keys[ math.random( #keys ) ]
end

function vonn.randomCircleSpill(surface,item)
	local theta = math.random() * 2 * math.pi
	local r = math.sqrt(math.random(9*9,18*18))
	local x = r * math.cos(theta)
	local y = r * math.sin(theta)

	surface.spill_item_stack({x,y},{name=item, count=1},false,nil,false)
end

function vonn.spillItemsRandomly(surface)
	local items = {
		coal=5,
		['burner-mining-drill']=4,
		['stone-furnace']=4,

		['burner-inserter']=4,
		['inserter']=4,
		['long-handed-inserter']=1,
		['transport-belt']=10,

		['firearm-magazine']=15,
		['gun-turret']=2,
		['laser-turret']=1,

		['assembling-machine-1']=4,
		['substation']=1,
		['big-electric-pole']=12,

		['electronic-circuit']=5,
		['radar']=1,

		roboport=10,
		['construction-robot']=50,
		['logistic-robot']=50,

		['logistic-chest-active-provider']=100,
		['logistic-chest-passive-provider']=10,
		['logistic-chest-storage']=30,
		['logistic-chest-buffer']=25,
		['logistic-chest-requester']=20,

		["copper-cable"] = 10,
		["green-wire"] = 10,
		["red-wire"] = 10,

		["accumulator"] = 3,
		["solar-panel"] = 2,
	}

	while vonn.tableSize(items)>0 do
		local item = vonn.randomTableElement(items)
		items[item] = items[item] - 1
		if items[item]<=0 then
			log("removing: " .. item)
			items[item] = nil
		end
		vonn.randomCircleSpill(surface,item)
	end
end

function vonn.spawnRobo(position)
	local robo = vonn.createSiteChest({name="roboport",position=position},{
		['construction-robot']=50,
		['logistic-robot']=50,
		['repair-pack']=50,
	})
	robo.energy = 100000000
	return rebo
end

function vonn.clearStartingArea(surface,boundingBox)
	local existing_entities = surface.find_entities(boundingBox)
	log("existing_entities " .. #existing_entities)
	for i, entity in pairs(existing_entities) do
		entity.order_deconstruction("player")
		log(entity.type)
		if entity.type=="resource" then
			log(entity.name)
			entity.destroy()
		end
	end
end

function vonn.clearStartingAreaPosition(surface,position,size)
	local a = position[1]
	local b = position[2]
	vonn.clearStartingArea(surface,{{a-size,b-size},{a+size,b+size}})
end

function vonn.spawnCrashSite()
	if global.donecrashsite then
		return
	end
	global.donecrashsite=true

	vonn.clearStartingArea(game.surfaces["nauvis"],{{-9, -9}, {9, 9}})
	local clearSize = 2.5
	vonn.clearStartingAreaPosition(game.surfaces["nauvis"],{-19,-19},clearSize)
	vonn.clearStartingAreaPosition(game.surfaces["nauvis"],{19,-19},clearSize)
	vonn.clearStartingAreaPosition(game.surfaces["nauvis"],{-19,19},clearSize)
	vonn.clearStartingAreaPosition(game.surfaces["nauvis"],{19,19},clearSize)

	local electricEnergyInterface = vonn.createCrashSiteGenerator({0,0})
	vonn.createEntity{name="substation",position={-9,-9}}
	vonn.createEntity{name="substation",position={9,9}}
	vonn.createEntity{name="substation",position={-9,9}}
	vonn.createEntity{name="substation",position={9,-9}}

	local crashSiteLab = vonn.createEntity{name="crash-site-lab-repaired",position={0,5}}

	local crashSiteAssemblingMachine1 = vonn.createEntity{name="crash-site-assembling-machine-1-repaired",position={4,-6}}
	local crashSiteAssemblingMachine2 = vonn.createEntity{name="crash-site-assembling-machine-2-repaired",position={-4,-6}}

	local crashSiteChest1 = vonn.createSiteChest({name="crash-site-chest-1",position={-7,0}},{['flying-robot-frame']=250})
	local crashSiteChest2 = vonn.createSiteChest({name="crash-site-chest-2",position={7,-1}},{['compilatron-chest']=1})

	local chest1items = {
		['burner-mining-drill']=1,
		['stone-furnace']=1,
		['burner-inserter']=1,
		['inserter']=1,
		['assembling-machine-1']=1,
		['big-electric-pole']=1,
		roboport=1,
		['logistic-chest-active-provider']=1,
		['logistic-chest-passive-provider']=1,
		['logistic-chest-storage']=1,
		['logistic-chest-buffer']=1,
		['logistic-chest-requester']=1,
	}

	-- logistic-chest-storage
	local chest1 = vonn.createSiteChest({name="logistic-chest-storage",position={-2,-1}},chest1items)
	local chest2 = vonn.createSiteChest({name="logistic-chest-active-provider",position={-2,0}},{})
	local chest3 = vonn.createSiteChest({name="logistic-chest-storage",position={1,-1}},{})
	local chest4 = vonn.createSiteChest({name="logistic-chest-storage",position={1,0}},{
		['coal']=1,
		['stone']=1,
		['wood']=1,
		['iron-ore']=1,
		['copper-ore']=1,
	})

	vonn.spawnRobo({-19,-19})
	vonn.spawnRobo({19,-19})
	vonn.spawnRobo({-19,19})
	vonn.spawnRobo({19,19})

	vonn.spillItemsRandomly(game.surfaces["nauvis"])
end

script.on_init(vonn.spawnCrashSite)


function vonn.forResourceOnNewChunk(surface,resource)
	if resource.name == "crude-oil" then
		return
	end

	--surface.spill_item_stack(resource.position,{name=resource.name, count=1},false,"player",false)
	surface.spill_item_stack(resource.position,{name=resource.name, count=1},false,nil,false)
end

function vonn.on_chunk_generated(event)
	local area = event.area
	local surface = event.surface

	--vonn.kprint(serpent.block(area))
	--vonn.kprint(surface)

	local arrayOfLuaEntity = surface.find_entities_filtered{area=area,type = "resource"}
	local size = vonn.tableSize(arrayOfLuaEntity)
	if size>0 then
		--vonn.kprint(size)
		for _,entity in pairs(arrayOfLuaEntity) do
			vonn.forResourceOnNewChunk(surface,entity)
		end
	end
end

script.on_event({
	defines.events.on_chunk_generated,
},vonn.on_chunk_generated)


vonn.storyText1 = [[The sound, while oddly familiar, can't quite be placed. One thing is certain however, you're awake.

You try to reach for your eyes to rub away the sleep that seems to be distorting your vision. Nothing happens. You don't have hands.]]
vonn.storyButton1 = "AHH! My hands!"

vonn.storyText2 = [[Wait. You don't /have/ hands. As in, they weren't broken in the crash, you just didn't have any at all. It comes back to you; you're an AI. A Von Neumann probe. Sent to the stars to explore, discover new worlds, and pave the way for human colonization efforts to follow in your footsteps.]]
vonn.storyButton2 = "Oh right, the crash."

vonn.storyText3 = [[You look around after opening your 'real' eyes, the electronic ones rather than imaginary ones. They work a lot better. Around you, the debris of the probe is scattered about, a smoldering wreckage. Your reactor is split from the rest of the ship, luckily still intact but in low power mode. Automation and terraforming and all the other modules are just in pieces however. So much for setting up shop quickly and moving on.]]
vonn.storyButton3 = "*Sigh*"

vonn.storyText4 = [[Some of your cargo bays are sort of intact however. There's gear, robots, and materials to fix some of the damage. You're definitely going to need more resources to get back to 100% however. Looking further afield, your scanners reveal nearby deposits of some basic resources. Copper, iron, coal, stone, and water. The basic stuff. More critical resources like oil products and nuclear fuel are going to be a bit harder to find however.]]
vonn.storyButton4 = "Whelp, I guess I better get started...."

function vonn.displayStoryText(player)
	local width = 450
	local height = 250
	player.gui.center.clear()
	local frame = player.gui.center.add{type='frame',name='vonn_story_frame',caption="Von Neumann Story",direction="vertical"}
	frame.style.width=width
	frame.style.height=height
	frame.style.vertically_stretchable = true
	frame.style.horizontally_stretchable = true
	frame.style.horizontally_squashable = true
	frame.style.vertically_squashable = true

	local text_box = frame.add{type='text-box',name='vonn_story_label',text = vonn.storyText1}
	text_box.style.width=width-20
	text_box.style.height=height-80
	text_box.word_wrap = true
	text_box.read_only = true
	text_box.style.vertically_stretchable = true
	text_box.style.horizontally_stretchable = true
	text_box.style.horizontally_squashable = true
	text_box.style.vertically_squashable = true

	if false then
		local sprite = frame.add{type='sprite',name='vonn_story_sprite',sprite="file/daddy.png"}
		sprite.style.horizontally_stretchable = true
	end

	local button = frame.add{type='button',name='vonn_story_button',caption=vonn.storyButton1}
	button.style.horizontally_stretchable = true

	--frame.destroy()
end

function vonn.on_gui_click(event)
	local player_index=event.player_index
	local player=game.players[player_index]
	local elementName = event.element.name

	if elementName == "vonn_story_button" then
		local text_box = event.element.parent.children[1] -- TODO: check children names, then use that index
		local button = event.element.parent.children[2] -- TODO: check children names, then use that index

		-- case switch
		if text_box.text == vonn.storyText1 then
			text_box.text = vonn.storyText2
			button.caption = vonn.storyButton2

		elseif text_box.text == vonn.storyText2 then
			text_box.text = vonn.storyText3
			button.caption = vonn.storyButton3

		elseif text_box.text == vonn.storyText3 then
			text_box.text = vonn.storyText4
			button.caption = vonn.storyButton4

		elseif text_box.text == vonn.storyText4 then
			event.element.parent.destroy()
		end
	else
		--vonn.kprint(elementName)
	end
end

script.on_event({
	defines.events.on_gui_click,
},vonn.on_gui_click)

function vonn.addPlayerNeedsZoom(player)
	if not global.playersNeedZoom then
		global.playersNeedZoom = {}
	end
	global.playersNeedZoom[player] = game.tick
	--vonn.kprint("player needs zoom" .. " " .. global.playersNeedZoom[player])
end

function vonn.newPlayer(event)
	local player_index=event.player_index
	local player=game.players[player_index]
	vonn.kprint("newPlayer: ".. player.name,{r=255,g=255})

	for i, player in pairs(game.players) do
		if player.connected and player.character then
			player.character.destroy()
			player.character = nil
			player.spectator = true
			vonn.displayStoryText(player)
			vonn.addPlayerNeedsZoom(player)
		end
	end

	local numberPlayers = #game.players
	local msg = "newPlayer complete: " .. numberPlayers
	vonn.kprint(msg)
end

script.on_event({
defines.events.on_player_joined_game,
defines.events.on_player_created,
defines.events.on_player_respawned,
},vonn.newPlayer)


function vonn.craftEvent(event)
	local player_index = event.player_index
	local recipe = event.recipe
	local items = event.items

	local player=game.players[player_index]
	vonn.kprint("Player tried to craft: " .. player.name)

	local player=game.players[player_index]

	while player.crafting_queue do
		player.cancel_crafting{index=1, count=player.crafting_queue[1].count}
	end
end

script.on_event(defines.events.on_pre_player_crafted_item, vonn.craftEvent)


function vonn.disableMining(player)
	if player.mining_state.mining then
		if player.selected and player.selected.type == "entity-ghost" then
			-- allow "mining" entity-ghost
			log(player.selected)
		elseif player.selected then
			player.mining_state = {mining = false}
			vonn.kprint("Player tried to mine: " .. player.name .. "   " .. player.selected.type .. " !")
		else
			player.mining_state = {mining = false}
			vonn.kprint("Player tried to mine: " .. player.name)
		end
	end
end

function vonn.updatePlayerZoom(player)
	if global.playersNeedZoom then
		local toFix = {}
		for player,tick in pairs(global.playersNeedZoom) do
			if player.valid and game.tick > tick then
				table.insert(toFix,player)
			end
		end
		for _,player in pairs(toFix) do
			global.playersNeedZoom[player] = nil
			--vonn.kprint("hiya! ".. player.name .. " " .. game.tick)
			player.zoom = 0.276
		end
	end
end

function vonn.onUpdate(event)
	for i, player in pairs(game.players) do
		if player.connected then
			vonn.disableMining(player)
			vonn.updatePlayerZoom(player)
		end
	end
end

script.on_event(defines.events.on_tick,vonn.onUpdate)


function vonn.stopBuilding(event)
	local created_entity = event.created_entity
	local player_index = event.player_index
	local stack = event.stack
	local item = event.item

	local player=game.players[player_index]

	if item then
		if created_entity.type == "entity-ghost" then
			-- allow ghosts
			log(player.name .. " tried to build "..item.name .. "   " ..created_entity.type)
		else
			vonn.kprint(player.name .. " tried to build "..item.name .. "   " ..created_entity.type)
			-- return item
			local inventory = player.get_inventory(defines.inventory.god_main)
			inventory.insert({name=item.name})
			created_entity.destroy()
		end
	else
		log(player.name .. " does not want to build (item=nil)")
	end
end

script.on_event(defines.events.on_built_entity,vonn.stopBuilding)


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
	["artillery-targeting-remote"] = true,
	-- TODO: decide to add coal|wood to list?
}

function vonn.countContentForBadItems(badItems,contents)
	for item, count in pairs (contents) do
		if vonn.acceptable_inventory[item] then
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
	local inventory = player.get_inventory(defines.inventory.god_main)
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
		end
	end

	--vonn.kprint("badItems: " .. serpent.block(badItems) .. "  " .. vonn.tableSize(badItems))
	return badItems
end

function vonn.removeBadItemsFromPlayer(player)
	local badItems = vonn.getBadItemsForPlayer(player)

	local itemsRemoved = {}

	for item,count in pairs(badItems) do
		local removedCount = player.remove_item({name=item, count=count})
		if not itemsRemoved[item] then
			itemsRemoved[item] = 0
		end
		itemsRemoved[item] = removedCount + itemsRemoved[item]
	end

	--vonn.kprint("itemsRemoved: " .. serpent.block(itemsRemoved) .. "  " .. vonn.tableSize(itemsRemoved))
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
	local position = player.opened.position
	local surface = game.surfaces[surface]
	local sum = 0

	for item,count in pairs(uninsertableItems) do
		surface.spill_item_stack(position,{name=item, count=count},false,player.force,false)
		sum = count + sum
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
	local eventName = eventNameMapping[event.name]

	local itemsRemoved = vonn.removeBadItemsFromPlayer(player)

	if vonn.tableSize(itemsRemoved) == 1 then
		for item,count in pairs(itemsRemoved) do
			vonn.kprint(player.name .. " tried to pick up " .. item .. "!")
		end
	elseif vonn.tableSize(itemsRemoved) > 0 then
		vonn.kprint(player.name .. " tried to pick up items!")
	end

	if player.opened and player.opened.valid and defines.gui_type.entity == player.opened_gui_type then
		local uninsertableItems = vonn.restoreRemovedItemsToOpenEntity(player,itemsRemoved)

		if vonn.tableSize(uninsertableItems) > 0 then
			local sum = vonn.spillPlayerItems(player,"nauvis",uninsertableItems)
			vonn.kprint("spilled items: " .. sum)
		end

	elseif vonn.tableSize(itemsRemoved) > 0 then
		vonn.spillPlayerItemsAtPlayer(player,itemsRemoved)
	end



	local existing_entities = game.surfaces["nauvis"].find_entities({{-1, -1}, {1, 1}})
	for i, entity in pairs(existing_entities) do
		--TODO: drain power for each bad item &| transport items to crash-site
	end
end

script.on_event({
defines.events.on_player_ammo_inventory_changed,
defines.events.on_player_armor_inventory_changed,
defines.events.on_player_gun_inventory_changed,
defines.events.on_player_main_inventory_changed,
defines.events.on_player_trash_inventory_changed,
defines.events.on_player_cursor_stack_changed,
},vonn.on_player_inventory_changed)





-- TODOs
-- spread out tutorial buildings
-- place roboport, assemblers, etc

-- /toggle-heavy-mode
-- /c __warptorio2__ warptorio.warpout()
-- https://forums.factorio.com/viewtopic.php?f=25&t=67140
-- ...\Steam\steamapps\common\Factorio\data\*.lua

-- biters drop computers because they are competing AIs
-- can we make invisible players?
-- can god players see through fog-of-war? Can I control fog-of-war?

-- request API for night vision and map film-grain (Mengmoshu)
-- LuaPlayer: cursor_ghost, teleport, disable_recipe_groups, disable_recipe_subgroups
-- LuaPlayer: add_alert, add_custom_alert, play_sound, afk_time, online_time, last_online, display_resolution, display_scale, rendor_mode

-- data.raw["utility-constants"].zoom_to_world_effect_strength = 0
-- data.raw["utility-constants"].zoom_to_world_darkness_multiplier = 0.5

-- spill starting items on ground around crash site
-- search starting chunks and add ground-spawn-spill items on iron/coal/copper/stone (include newly chunks too?) on_chunk_generated
-- move Mods to individual git repos

-- LuaForce.html#LuaForce.manual_mining_speed_modifier

