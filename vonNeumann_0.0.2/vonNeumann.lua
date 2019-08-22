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
	local electricEnergyInterface = createEntity{name="crash-site-generator",position=position,inoperable=true}

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
	entity.minable = options.minable or false
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


function newPlayer(event)
	kprint("newPlayer: "..serpent.block(event.player_index),{r=255,g=255})

	for i, player in pairs(game.players) do
		local playerCharacter = player.character
		player.character = nil
	end

	for i, entity in pairs(game.surfaces[1].find_entities_filtered{}) do -- iterate through entities
		if entity.type == "character" then
			entity.destroy()
		end
	end


	local electricEnergyInterface = createCrashSiteGenerator({0,0})

	local crashSiteLab = createEntity{name="crash-site-lab-repaired",position={0,4}}

	local crashSiteAssemblingMachine1 = createEntity{name="crash-site-assembling-machine-1-repaired",position={5,0}}
	local crashSiteAssemblingMachine2 = createEntity{name="crash-site-assembling-machine-2-repaired",position={6,4}}

	local items1 = {
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
	}
	local crashSiteChest1 = createSiteChest({name="crash-site-chest-1",position={8,7}},items1)

	local items2 = {
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
	local crashSiteChest2 = createSiteChest({name="crash-site-chest-2",position={-3,-3}},items2)

	-- crash-site-electric-pole
	-- substation

	local numberPlayers = #game.players
	local msg = "newPlayer complete: " .. numberPlayers
	kprint(msg)
end



script.on_event({
defines.events.on_player_joined_game,
defines.events.on_player_created,
defines.events.on_player_left_game,
defines.events.on_player_changed_force,
defines.events.on_player_removed,
defines.events.on_pre_player_left_game,
},newPlayer)


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

