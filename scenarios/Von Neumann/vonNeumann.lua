-- Kizrak

--- needs "hijack"


vonn = {}

vonn.eventNameMapping = {}
for eventName,eventId in pairs(defines.events) do
	vonn.eventNameMapping[eventId] = eventName
end

function vonn.kprint(msg)
	print(msg)
	log(msg)
	if not game.is_multiplayer() then
		game.print(msg,{r=255,g=255})
	end
end


local sb = serpent.block


local default_accumulator_buffer = 5000000 -- accumulator is 5 MJ
function vonn.createCrashSiteGenerator(position)
	local electricEnergyInterface = vonn.createEntity{name="crash-site-generator",position=position}
	local energy = default_accumulator_buffer*600 -- 3 GJ

	electricEnergyInterface.power_production = 3*15000 -- 3*900kW
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
		["vn-electric-mining-drill"]=7,
		['stone-furnace']=8,

		['burner-inserter']=20,
		['vn-inserter']=30,
		['vn-transport-belt']=100,

		['firearm-magazine']=39,
		['gun-turret']=3,
		['laser-turret']=2,

		['damaged-assembling-machine']=24,
		['big-electric-pole']=12,

		['electronic-circuit']=15,
		['radar']=1,

		roboport=10,
		['construction-robot']=100,
		['logistic-robot']=10,

		['vn-logistic-chest-requester']=15,

		["copper-cable"] = 10,
		["green-wire"] = 10,
		["red-wire"] = 10,

		["accumulator"] = 3,
		["solar-panel"] = 2,
	}

	while table_size(items)>0 do
		local item = vonn.randomTableElement(items)
		items[item] = items[item] - 1
		if items[item]<=0 then
			items[item] = nil
		end
		vonn.randomCircleSpill(surface,item)
	end
end

function vonn.spawnRobo(position)
	local robo = vonn.createSiteChest({name="vn-roboport",position=position},{
		['construction-robot']=250,
		['logistic-robot']=50,
		['repair-pack']=50,
	})
	robo.energy = game.entity_prototypes["vn-roboport"].electric_energy_source_prototype.buffer_capacity
	return robo
end

function vonn.clearStartingArea(surface,boundingBox)
	local existing_entities = surface.find_entities(boundingBox)
	for i, entity in pairs(existing_entities) do
		entity.order_deconstruction("player")
		if entity.type=="resource" then
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

	--log(serpent.block( game.surfaces["nauvis"].map_gen_settings ))
	log("map_gen_settings.seed: " .. game.surfaces["nauvis"].map_gen_settings.seed)

	vonn.clearStartingAreaPosition(game.surfaces["nauvis"],{0,0},9)

	local electricEnergyInterface = vonn.createCrashSiteGenerator({0,0})
	vonn.createEntity{name="vn-substation",position={-16,-16}}
	vonn.createEntity{name="vn-substation",position={16,16}}
	vonn.createEntity{name="vn-substation",position={-16,16}}
	vonn.createEntity{name="vn-substation",position={16,-16}}

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
		['big-electric-pole']=1,
		roboport=1,

		['damaged-assembling-machine']=1,
		["vn-electric-mining-drill"]=1,
		['vn-inserter']=1,
		['vn-transport-belt']=600,
		['vn-logistic-chest-requester']=1,

		['construction-robot']=1,
		['logistic-robot']=1,

		['electronic-circuit']=1,

		['firearm-magazine']=1,
		['laser-turret']=1,
		['gun-turret']=1,

		['copper-cable']=1,
		['green-wire']=1,
		['red-wire']=1,

		['accumulator']=1,
		['solar-panel']=1,
		['radar']=1,
	}

	-- logistic-chest-storage
	local chest1 = vonn.createSiteChest({name="vn-logistic-chest-storage",position={-2,-1}},chest1items)
	local chest2 = vonn.createSiteChest({name="logistic-chest-active-provider",position={-2,0}},{})

	local chest3 = vonn.createSiteChest({name="logistic-chest-buffer",position={1,0}},{
		['rail']=10,
		['train-stop']=1,
		['rail-chain-signal']=1,
		['rail-signal']=1,

		['big-electric-pole']=1,
		['roboport']=1,
		['vn-inserter']=1,
		['inserter']=1,
		['logistic-chest-storage']=1,
	})
	chest3.set_request_slot({name="rail", count=100},1)
	chest3.set_request_slot({name="train-stop", count=1},2)
	chest3.set_request_slot({name="rail-chain-signal", count=1},3)
	chest3.set_request_slot({name="rail-signal", count=1},4)

	chest3.set_request_slot({name="big-electric-pole", count=1},7)
	chest3.set_request_slot({name="roboport", count=1},8)
	chest3.set_request_slot({name="vn-inserter", count=1},9)
	chest3.set_request_slot({name="inserter", count=1},10)
	chest3.set_request_slot({name="logistic-chest-storage", count=1},11)

	local chest4 = vonn.createSiteChest({name="vn-logistic-chest-storage",position={1,-1}},{
		['coal']=1,
		['stone']=1,
		['wood']=1,
		['iron-ore']=1,
		['copper-ore']=1,
	})

	local roboRadius = 25
	vonn.spawnRobo({-1*roboRadius,-1*roboRadius})
	vonn.spawnRobo({roboRadius   ,-1*roboRadius})
	vonn.spawnRobo({-1*roboRadius,roboRadius   })
	vonn.spawnRobo({roboRadius   ,roboRadius   })

	local clearSize = 3.0
	vonn.clearStartingAreaPosition(game.surfaces["nauvis"], {-1*roboRadius,-1*roboRadius}, clearSize)
	vonn.clearStartingAreaPosition(game.surfaces["nauvis"], {roboRadius   ,-1*roboRadius}, clearSize)
	vonn.clearStartingAreaPosition(game.surfaces["nauvis"], {-1*roboRadius,roboRadius   }, clearSize)
	vonn.clearStartingAreaPosition(game.surfaces["nauvis"], {roboRadius   ,roboRadius   }, clearSize)

	vonn.spillItemsRandomly(game.surfaces["nauvis"])

	rendering.draw_light{
		sprite="utility/light_medium",
		target=electricEnergyInterface,
		surface=electricEnergyInterface.surface,
		forces={electricEnergyInterface.force},
		scale = 40,
		color = {r=1,g=1,b=0.1},
	}

	local surface = game.surfaces["nauvis"]
	for r=0,20 do
		surface.request_to_generate_chunks({0,0},r)
	end

	global.clearSpawnResources = true
end

script.on_init(vonn.spawnCrashSite)


function vonn.forResourceOnNewChunk(surface,resource)
	local products = game.entity_prototypes[resource.name].mineable_properties.products

	for _,product in pairs(products) do
		if product.type=="item" then
			surface.spill_item_stack(resource.position,{name=product.name, count=1},false,nil,false)
		end
	end
end

function vonn.on_chunk_generated(event)
	local area = event.area
	local surface = event.surface

	local arrayOfLuaEntity = surface.find_entities_filtered{area=area,type = "resource"}
	local size = table_size(arrayOfLuaEntity)
	if size>0 then
		for _,entity in pairs(arrayOfLuaEntity) do
			vonn.forResourceOnNewChunk(surface,entity)
		end
	end
end

script.on_event({
	defines.events.on_chunk_generated,
},vonn.on_chunk_generated)


vonn.storyText1 = [[A rising crescendo of piano rings through the air. The sound, while oddly familiar, can't quite be placed. One thing is certain however, you're awake.

You try to reach for your eyes to rub away the sleep that seems to be distorting your vision. Nothing happens. You don't have hands.]]
vonn.storyButton1 = "AHH! My hands!"

vonn.storyText2 = [[Wait. You don't /have/ hands. As in, they weren't lost in the crash, you just didn't have any at all. It comes back to you now; you're an AI. A Von Neumann self-replicating probe. Sent to the stars to explore, discover new worlds, and pave the way for human colonization efforts to follow in your footsteps.]]
vonn.storyButton2 = "Oh right, the crash."

vonn.storyText3 = [[You look around after opening your 'real' eyes, the electronic ones rather than the imaginary ones. Those work a lot better. Around you, the debris of your probe is scattered about, a smoldering wreckage. Your reactor is split from the rest of the ship, luckily still intact but in low power mode due to damage. Automation and terraforming and all the other modules are just in pieces however. So much for setting up shop quickly and moving on to the next world.]]
vonn.storyButton3 = "*Sigh*"

vonn.storyText4 = [[Some of your resources are sort of intact however. There's gear, robots, and materials to fix some of the damage but it's all scattered around. You can collect the pieces to get started but you're definitely going to need more resources to get back to 100% however.

Luckily your auto repair mechanisms have stabilized the situation and set up a basic infrastructure for you. Construction and logistic robots stand at the ready for your command.

Looking further afield, your scanners reveal nearby deposits of some basic resources. Copper, iron, coal, stone, and water. You know, the basic stuff. More advanced resources like oil products and nuclear fuel are going to be a bit harder to find however.]]
vonn.storyButton4 = "Whelp, I guess I better get started...."

vonn.storyText5 = [[One last thing. Your personal debugging Railbot has detected the damage from the crash and booted up to ensure that you are in tip top shape. It has fixed up your computer core damage and brought you back online. Normally a Railbot would power back down after repairs are complete but in this case, your ship is ever so slightly beyond repairs that it is capable of and now it's stuck in do-while loop. On the bright side, you can issue orders and utilize it to aid in building up your new base and executing tasks that are beyond your other robots range and capabilities.

Do be careful however. These older model Railbots are powerful but their nuclear reactors are not especially well shielded against damage and are likely to go supercritical if jostled. Nuclear explosions do also tend to result in EMP blasts which are not super great for sensitive electronics, such as yourself and your equipment.]]
vonn.storyButton5 = "Huh. Righty-o. Time to roll."

function vonn.displayStoryText(player)
	local width = 550
	local height = 350
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

		if event.alt or event.control or event.shift then
			event.element.parent.destroy()
			return
		end

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
			text_box.text = vonn.storyText5
			button.caption = vonn.storyButton5

		elseif text_box.text == vonn.storyText5 then
			event.element.parent.destroy()
		end
	else
		--vonn.kprint(elementName)
	end
end

script.on_event({
	defines.events.on_gui_click,
},vonn.on_gui_click)



function vonn.setupQuickBar(player)
	for index=1,10 do
		if player.get_quick_bar_slot(index) then
			 -- ignore because player already has buttons
			return
		end
	end

	player.set_quick_bar_slot(1,"vn-transport-belt")
	player.set_quick_bar_slot(2,"vn-inserter")
	player.set_quick_bar_slot(3,"burner-inserter")
	player.set_quick_bar_slot(4,"burner-mining-drill")
	player.set_quick_bar_slot(5,"vn-electric-mining-drill")
	player.set_quick_bar_slot(6,"stone-furnace")
	player.set_quick_bar_slot(7,"damaged-assembling-machine")
	player.set_quick_bar_slot(8,"big-electric-pole")
	player.set_quick_bar_slot(9,"roboport")

	-- deconstruction-planner
	if player.cursor_ghost~=nil then
		-- skip if ghost on cursor
		return
	end

	local cursor = player.cursor_stack

	if not cursor.valid then
		return
	elseif cursor.valid_for_read then
		return
	end

	local deconstruction_planner_text = "0eNplkN1qwzAMhd9F1zY0DbQsr1KGCbGamTlSZykjIfjd56Z/a3snjr7Dkc4CHjsm0TR2GpjcKbZEmKBZQFA1UC/nGUmDzu4YomJyA3uEZmOe5QIeFqB2KLvrxvZfLAoGAnmciiWbOxEUB8tk+8Qj+QdTvTIJf0YUtafE0/zgtv84DRFfs+r8aUAToriWvEvcfYtjijM0xzYKmtX19tIqCka89HHVs1lvKVHPfdlbXwZ+SwNFgWZfb6qP3baq97uc/wB3fnxj"

	local r = cursor.import_stack(deconstruction_planner_text)
	if r~=0 then
		log("cursor.import_stack: "..r)
	end

	player.set_quick_bar_slot(10,player.cursor_stack)
	player.clean_cursor()
end


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
	local eventName = vonn.eventNameMapping[event.name]
	vonn.kprint("newPlayer: ".. player.name .. "   " .. eventName,{r=255,g=255})

	for i, player in pairs(game.players) do
		if player.connected and player.character then
			local vonnCharacter = player.surface.create_entity{name="vonn",position=player.character.position,force=player.force}
			vonnCharacter.destructible = false
			player.character.destroy()
			player.character = vonnCharacter
			player.spectator = true
			vonn.displayStoryText(player)
			vonn.addPlayerNeedsZoom(player)
		end
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
	local recipe = event.recipe
	local items = event.items

	local player=game.players[player_index]
	vonn.kprint("Player tried to craft: " .. player.name)

	local player=game.players[player_index]

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
	local recipe = event.recipe
	local items = event.items
	local eventName = vonn.eventNameMapping[event.name]
	local item_stack = event.item_stack
	local recipe = event.recipe

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
		global.players[event.palyer_index].crafted = {name = name, count = item_stack.count}
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

			vonn.setupQuickBar(player)
		end
	end
end

function vonn.on_tick(event)
	for i, player in pairs(game.players) do
		if player.connected then
			vonn.disableMining(player)
			vonn.updatePlayerZoom(player)
		end
	end

	if global.clearSpawnResources and game.tick>1 then
		local roboRadius = 25
		local clearSize = 3.0
		local surface = game.surfaces["nauvis"]
		vonn.clearStartingAreaPosition(surface,{-1*roboRadius,-1*roboRadius},clearSize)
		vonn.clearStartingAreaPosition(surface,{roboRadius   ,-1*roboRadius},clearSize)
		vonn.clearStartingAreaPosition(surface,{-1*roboRadius,roboRadius   },clearSize)
		vonn.clearStartingAreaPosition(surface,{roboRadius   ,roboRadius   },clearSize)
		vonn.clearStartingAreaPosition(surface,{0,0},9)

		global.clearSpawnResources = false
	end
end

script.on_event(defines.events.on_tick,vonn.on_tick)


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
			-- TODO: iterate over all 8 inventories
			local inventory = player.get_inventory(defines.inventory.character_main)
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
	local surface = game.surfaces[surface]
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
	local eventName = vonn.eventNameMapping[event.name]

	local itemsRemoved = vonn.removeBadItemsFromPlayer(player)

	if table_size(itemsRemoved) == 1 then
		for item,count in pairs(itemsRemoved) do
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
			for item,count in pairs(itemsRemoved) do
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


function vonn.on_player_pipette(event)
	local player_index = event.player_index
	local player = game.players[player_index]
	local eventName = vonn.eventNameMapping[event.name]
	local item  = event.item
	local used_cheat_mode  = event.used_cheat_mode

	--vonn.kprint(item.name .. "  " .. tostring(used_cheat_mode))
	--vonn.kprint(player.cursor_stack.name .. "   " .. player.cursor_stack.count)
	player.cursor_ghost = player.cursor_stack.name
	player.cursor_stack.count = 0
end

script.on_event({
	defines.events.on_player_pipette
},vonn.on_player_pipette)



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

