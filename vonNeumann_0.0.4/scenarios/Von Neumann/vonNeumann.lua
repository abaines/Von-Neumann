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

	electricEnergyInterface.power_production = "15000"
	electricEnergyInterface.electric_buffer_size  = "100000000"

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
		log(entity.name)
		entity.order_deconstruction("player")
	end

	local electricEnergyInterface = vonn.createCrashSiteGenerator({0,0})
	local crashSiteLab = vonn.createEntity{name="substation",position={0,0}}

	local crashSiteLab = vonn.createEntity{name="crash-site-lab-repaired",position={0,4}}

	local crashSiteAssemblingMachine1 = vonn.createEntity{name="crash-site-assembling-machine-1-repaired",position={5,0}}
	local crashSiteAssemblingMachine2 = vonn.createEntity{name="crash-site-assembling-machine-2-repaired",position={6,4}}

	local items = {
		coal=1,
		['small-electric-pole']=4,
		['burner-mining-drill']=3,
		['stone-furnace']=2,
		['firearm-magazine']=10,
		['gun-turret']=1,
		['burner-inserter']=2,
		['inserter']=2,
		['compilatron-chest']=1,
		['assembling-machine-1']=2,
		roboport=3,
		['construction-robot']=50,
		['logistic-robot']=100,
		['flying-robot-frame']=50,
		['logistic-chest-active-provider']=10,
		['logistic-chest-buffer']=2,
		['logistic-chest-passive-provider']=2,
		['logistic-chest-requester']=2,
		['logistic-chest-storage']=10,
		['big-electric-pole']=10,
		['substation']=1,
	}
	-- crash-site-electric-pole
	-- substation
	local crashSiteChest1 = vonn.createSiteChest({name="crash-site-chest-1",position={8,7}},{})
	local crashSiteChest2 = vonn.createSiteChest({name="crash-site-chest-2",position={-3,-3}},{})

	-- logistic-chest-storage
	local chest1 = vonn.createSiteChest({name="logistic-chest-storage",position={-2,-8}},items)

	local robo1 = vonn.createSiteChest({name="roboport",position={-2,-8}},{
		['construction-robot']=150,
		['logistic-robot']=150,
		['repair-pack']=150,
	})
end


function vonn.newPlayer(event)
	local player_index=event.player_index
	local player=game.players[player_index]
	vonn.kprint("newPlayer: ".. player.name,{r=255,g=255})

	for i, player in pairs(game.players) do
		if player.connected and player.character then
			player.character.destroy()
			player.character = nil
		end
	end

	local numberPlayers = #game.players
	local msg = "newPlayer complete: " .. numberPlayers
	vonn.kprint(msg)
end


function vonn.craftEvent(event)
	local player_index = event.player_index
	local recipe = event.recipe
	local items = event.items

	local player=game.players[player_index]
	kprint("Player tried to craft: " .. player.name)

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
			else
				player.mining_state = {mining = false}
				vonn.kprint("Player tried to mine: " .. player.name .. "   " .. player.selected.type)
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


script.on_event({
defines.events.on_player_joined_game,
defines.events.on_player_created,
defines.events.on_player_respawned,
},vonn.newPlayer)


script.on_init(vonn.spawnCrashSite)


-- TODOs
-- Make this a softmod !!
-- give full inventory for storing blueprints/deconstruction/upgrade planners
-- auto-drop non-blueprint/deconstruction/upgrade planners, also allow fuels (coal and wood)
-- remove tutorial chests, replace with logic storage
-- spread out tutorial buildings
-- fix bug with new players making extra buildings
-- put same items in both chests
-- disable crafting
-- disable building/de-building buildings
-- disable mining
-- place roboport, assemblers, etc

-- /toggle-heavy-mode
-- /c __warptorio2__ warptorio.warpout()
-- changelog.txt
-- ...\Steam\steamapps\common\Factorio\data\*.lua
-- local var/methods
-- use a vonn = {} to encapsulate code

