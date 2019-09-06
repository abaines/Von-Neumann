-- Kizrak

--- needs "hijack"

vonn = {}

function vonn.kprint(msg)
	print(msg)
	log(msg)
	if not game.is_multiplayer() then
		game.print(msg,{r=255,g=255})
	end
end


function vonn.createCrashSiteGenerator(position)
	local electricEnergyInterface = vonn.createEntity{name="crash-site-generator",position=position,inoperable=true}

	electricEnergyInterface.power_production = 15000
	electricEnergyInterface.electric_buffer_size  = 2*100000000
	electricEnergyInterface.energy  = 2*100000000

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

	entity.destructible = options.destructible or false
	entity.minable = options.minable or false
	entity.rotatable = options.rotatable or false
	entity.operable = not (options.inoperable or false)

	return entity
end


function vonn.createSiteChest(options,itemsTable)
	local entity = vonn.createEntity(options)

	for k, v in pairs (itemsTable) do
		entity.insert({name = k, count = v})
	end

	return entity
end


function vonn.spawnCrashSite()
	if global.donecrashsite then
		return
	end
	global.donecrashsite=true


	local existing_entities = game.surfaces["nauvis"].find_entities({{-7, -13}, {12, 12}})
	log("existing_entities " .. #existing_entities)
	for i, entity in pairs(existing_entities) do
		--log(entity.name)
		entity.order_deconstruction("player")
	end

	local electricEnergyInterface = vonn.createCrashSiteGenerator({0,0})
	local crashSiteLab = vonn.createEntity{name="substation",position={0,0}}

	local crashSiteLab = vonn.createEntity{name="crash-site-lab-repaired",position={0,4}}

	local crashSiteAssemblingMachine1 = vonn.createEntity{name="crash-site-assembling-machine-1-repaired",position={5,0}}
	local crashSiteAssemblingMachine2 = vonn.createEntity{name="crash-site-assembling-machine-2-repaired",position={6,4}}

	local items = {
		coal=5,
		['burner-mining-drill']=4,
		['stone-furnace']=4,

		['burner-inserter']=4,
		['inserter']=4,
		['long-handed-inserter']=1,
		['transport-belt']=10,

		['firearm-magazine']=10,
		['gun-turret']=1,

		['assembling-machine-1']=4,
		['substation']=1,
		['big-electric-pole']=12,

		['electronic-circuit']=5,
		['radar']=5,

		roboport=10,
		['construction-robot']=50,
		['logistic-robot']=50,

		['logistic-chest-active-provider']=100,
		['logistic-chest-passive-provider']=10,
		['logistic-chest-storage']=30,
		['logistic-chest-buffer']=25,
		['logistic-chest-requester']=20,
	}
	-- crash-site-electric-pole
	-- substation
	local crashSiteChest1 = vonn.createSiteChest({name="crash-site-chest-1",position={8,7}},{['flying-robot-frame']=250})
	local crashSiteChest2 = vonn.createSiteChest({name="crash-site-chest-2",position={-3,-3}},{['compilatron-chest']=1})

	-- logistic-chest-storage
	local chest1 = vonn.createSiteChest({name="logistic-chest-storage",position={-2,-8}},items)

	local robo1 = vonn.createSiteChest({name="roboport",position={-2,-8}},{
		['construction-robot']=150,
		['logistic-robot']=150,
		['repair-pack']=150,
	})
	robo1.energy = 100000000
end

script.on_init(vonn.spawnCrashSite)


vonn.storyText1 = [[The sound, while oddly familiar, can't quite be placed. One thing is certain however, you're awake.

You try to reach for your eyes to rub away the sleep that seems to be distorting your vision. Nothing happens. You don't have hands.]]
vonn.storyButton1 = "AHH! My hands!"

vonn.storyText2 = [[Wait. You don't /have/ hands. As in, they weren't broken in the crash, you just didn't have any at all. It comes back to you; you're an AI. A Von Neumann probe. Sent to the stars to explore, discover new worlds, and pave the way for human colonization efforts to follow in your footsteps.

"Oh right, the crash."

You look around after opening your 'real' eyes, the electronic ones rather than imaginary ones. They work a lot better. Around you, the debris of the probe is scattered about, a smoldering wreckage. Your reactor is split from the rest of the ship, luckily still intact but in low power mode. Automation and terraforming and all the other modules are just in pieces however. So much for setting up shop quickly and moving on.]]
vonn.storyButton2 = "*Sigh*"

vonn.storyText3 = [[Some of your cargo bays are sort of intact however. There's gear, robots, and materials to fix some of the damage. You're definitely going to need more resources to get back to 100% however. Looking further afield, your scanners reveal nearby deposits of some basic resources. Copper, iron, coal, stone, and water. The basic stuff. More critical resources like oil products and nuclear fuel are going to be a bit harder to find however.]]
vonn.storyButton3 = "Whelp, I guess I better get started...."

function vonn.displayStoryText(player)
	player.gui.center.clear()
	local frame = player.gui.center.add{type='frame',name='vonn_story_frame',caption="Von Neumann Story",direction="vertical"}
	frame.style.width=720
	frame.style.height=320
	frame.style.vertically_stretchable = true
	frame.style.horizontally_stretchable = true
	frame.style.horizontally_squashable = true
	frame.style.vertically_squashable = true

	local text_box = frame.add{type='text-box',name='vonn_story_label',text = vonn.storyText1}
	text_box.style.width=700
	text_box.style.height=240
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
			event.element.parent.destroy()
		end
	else
		--vonn.kprint(elementName)
	end
end

script.on_event({
	defines.events.on_gui_click,
},vonn.on_gui_click)


function vonn.newPlayer(event)
	local player_index=event.player_index
	local player=game.players[player_index]
	vonn.kprint("newPlayer: ".. player.name,{r=255,g=255})

	for i, player in pairs(game.players) do
		if player.connected and player.character then
			player.character.destroy()
			player.character = nil
			vonn.displayStoryText(player)
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


function vonn.onUpdate(event)
	for i, player in pairs(game.players) do
		if player.connected and player.mining_state.mining then
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
	-- TODO: decide to add coal|wood to list?
}

function vonn.countContentForBadItems(contents)
	local badItems = 0

	for item, count in pairs (contents) do
		if vonn.acceptable_inventory[item] then
			-- ignore acceptable inventory item
		else
			badItems = count + badItems
		end
	end

	return badItems
end

function vonn.on_player_inventory_changed(event)
	local badItems = 0
	for i, player in pairs(game.connected_players) do
		local inventory = player.get_inventory(defines.inventory.god_main)
		local contents = inventory.get_contents()
		badItems = vonn.countContentForBadItems(contents)
	end

	vonn.kprint("badItems: " .. badItems)

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
},vonn.on_player_inventory_changed)





-- TODOs
-- give full inventory for storing blueprints/deconstruction/upgrade planners
-- auto-drop non-blueprint/deconstruction/upgrade planners, also allow fuels (coal and wood)
-- spread out tutorial buildings
-- place roboport, assemblers, etc

-- /toggle-heavy-mode
-- /c __warptorio2__ warptorio.warpout()
-- changelog.txt
-- https://forums.factorio.com/viewtopic.php?f=25&t=67140
-- ...\Steam\steamapps\common\Factorio\data\*.lua

-- biters drop computers because they are competing AIs
-- can we make invisible players?
-- can god players see through fog-of-war? Can I control fog-of-war?

-- request API for night vision and map film-grain (Mengmoshu)
-- LuaPlayer: spectator, cursor_stack, cursor_ghost, opened, teleport, disable_recipe_groups, disable_recipe_subgroups
-- LuaPlayer: add_alert, add_custom_alert, play_sound, afk_time, online_time, last_online, display_resolution, display_scale, rendor_mode

-- /c game.player.spectator = true
-- data.raw["utility-constants"].zoom_to_world_effect_strength = 0
-- data.raw["utility-constants"].zoom_to_world_darkness_multiplier = 0.5

