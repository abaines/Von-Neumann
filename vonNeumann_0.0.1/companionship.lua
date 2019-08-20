-- Kizrak

--- needs "hijack"


function companionship(event)
	if not global.companionshipLimit then
		global.companionshipLimit = 2
	end

	local numberConnectedPlayers = #game.connected_players

	game.print("companionship: "..numberConnectedPlayers .. " / " .. global.companionshipLimit,{r=255,g=255})

	if numberConnectedPlayers < global.companionshipLimit then
		game.speed = 1/6
	else
		game.speed = 1
	end

	log("companionship")
end



script.on_event({
defines.events.on_player_joined_game,
defines.events.on_player_created,
defines.events.on_player_left_game,
defines.events.on_player_changed_force,
defines.events.on_player_removed,
defines.events.on_pre_player_left_game,
},companionship)

