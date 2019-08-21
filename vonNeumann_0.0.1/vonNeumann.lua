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
		error("no name")
	elseif type(options.position)~="table" then
		error("no position")
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
	local crashSiteAssemblingMachine2 = createEntity{name="crash-site-assembling-machine-2-repaired",position={6,4},inoperable=true}

	local crashSiteChest1 = createEntity{name="crash-site-chest-1",position={8,7}}
	local crashSiteChest2 = createEntity{name="crash-site-chest-2",position={-3,-3}}

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

