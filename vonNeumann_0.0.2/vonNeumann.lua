-- Kizrak

--- needs "hijack"

function kprint(msg)
	print(msg)
	log(msg)
	if not game.is_multiplayer() then
		game.print(msg,{r=255,g=255})
	end
end


function createCrashSiteGenerator(position)
	local electricEnergyInterface = createEntity{name="crash-site-generator",position=position,inoperable=true,unminable=true}

	electricEnergyInterface.power_production = "15000"
	electricEnergyInterface.electric_buffer_size  = "100000000"

	return electricEnergyInterface
end


function createEntity(options)
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
	entity.minable = not (options.unminable or false)
	entity.rotatable = options.rotatable or false
	entity.operable = not (options.inoperable or false)

	return entity
end


function createSiteChest(options,itemsTable)
	local entity = createEntity(options)

	for k, v in pairs (itemsTable) do
		entity.insert({name = k, count = v})
	end

	return entity
end


function spawnCrashSite()
	if global.donecrashsite then
		return
	end
	global.donecrashsite=true

	local electricEnergyInterface = createCrashSiteGenerator({0,0})

	local crashSiteLab = createEntity{name="crash-site-lab-repaired",position={0,4}}

	local crashSiteAssemblingMachine1 = createEntity{name="crash-site-assembling-machine-1-repaired",position={5,0}}
	local crashSiteAssemblingMachine2 = createEntity{name="crash-site-assembling-machine-2-repaired",position={6,4}}

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
		['construction-robot']=100,
		['logistic-robot']=100,
		['flying-robot-frame']=100,
		['logistic-chest-active-provider']=10,
		['logistic-chest-buffer']=2,
		['logistic-chest-passive-provider']=2,
		['logistic-chest-requester']=2,
		['logistic-chest-storage']=10,
	}
	-- crash-site-electric-pole
	-- substation
	local crashSiteChest1 = createSiteChest({name="crash-site-chest-1",position={8,7}},items)
	local crashSiteChest2 = createSiteChest({name="crash-site-chest-2",position={-3,-3}},items)
end


function newPlayer(event)
	local player_index=event.player_index
	local player=game.players[player_index]
	kprint("newPlayer: ".. player.name,{r=255,g=255})

	for i, player in pairs(game.players) do
		if player.connected and player.character then
			player.character.destroy()
			player.character = nil
		end
	end

	local numberPlayers = #game.players
	local msg = "newPlayer complete: " .. numberPlayers
	kprint(msg)
end


function craftEvent(event)
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

script.on_event(defines.events.on_pre_player_crafted_item, craftEvent)

function onUpdate(event)
	for i, player in pairs(game.players) do
		if player.connected and player.mining_state.mining then
			player.mining_state = {mining = false}
			kprint("Player tried to mine: " .. player.name)
		end
	end
end

script.on_event(defines.events.on_tick,onUpdate)

script.on_event({
defines.events.on_player_joined_game,
defines.events.on_player_created,
defines.events.on_player_left_game,
defines.events.on_player_changed_force,
defines.events.on_player_removed,
defines.events.on_pre_player_left_game,
},newPlayer)


script.on_init(spawnCrashSite)

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
--

