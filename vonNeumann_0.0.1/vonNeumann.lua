-- Kizrak

--- needs "hijack"


function newPlayer(event)
	game.print("newPlayer: "..serpent.block(event.player_index),{r=255,g=255})

	for i, player in pairs(game.players) do
		local playerCharacter = player.character
		player.character = nil
		--playerCharacter.destroy()
	end

	local numberPlayers = #game.players
	local msg = "newPlayer complete: " .. numberPlayers
	print(msg)
	log(msg)
	if not game.is_multiplayer() then
		game.print(msg,{r=255,g=255})
	end
end



script.on_event({
defines.events.on_player_joined_game,
defines.events.on_player_created,
defines.events.on_player_left_game,
defines.events.on_player_changed_force,
defines.events.on_player_removed,
defines.events.on_pre_player_left_game,
},newPlayer)

