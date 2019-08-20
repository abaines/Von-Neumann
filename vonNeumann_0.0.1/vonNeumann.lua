-- Kizrak

--- needs "hijack"

function kprint(msg)
	print(msg)
	log(msg)
	if not game.is_multiplayer() then
		game.print(msg,{r=255,g=255})
	end
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


	local electricEnergyInterface = game.surfaces[1].create_entity{
		name="electric-energy-interface",
		position={0,0},
		force="player"
	}

	electricEnergyInterface.destructible = false
	electricEnergyInterface.minable = false
	electricEnergyInterface.rotatable = false
	electricEnergyInterface.operable = false

	electricEnergyInterface.power_production ="15000"
	electricEnergyInterface.electric_buffer_size  ="100000000"


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

