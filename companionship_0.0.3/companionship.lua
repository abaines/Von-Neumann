-- Kizrak

local eventNameMapping = {}
for eventName,eventId in pairs(defines.events) do
	eventNameMapping[eventId] = eventName
end


local function getLowestPlayerDesiredSpeed()
	local lowestPlayerDesiredSpeed = 9001 -- It's Over 9000!
	for i, player in pairs(game.connected_players) do
		local player_desired_speed = player.mod_settings["player_desired_speed"].value
		if false then
			game.print(player.name .. "  " .. player_desired_speed)
		end
		lowestPlayerDesiredSpeed = math.min(lowestPlayerDesiredSpeed,player_desired_speed)
	end
	return lowestPlayerDesiredSpeed
end


local function getNewGameSpeed(numberConnectedPlayers,min_companions,slow_speed_companion)
	local lowestPlayerDesiredSpeed = getLowestPlayerDesiredSpeed()

	if numberConnectedPlayers < min_companions then
		return math.min(slow_speed_companion,lowestPlayerDesiredSpeed)
	else
		return lowestPlayerDesiredSpeed
	end
end


local function companionship(event)
	local min_companions = settings.startup['minimum_number_of_companions'].value
	local slow_speed_companion = settings.startup['speed_when_below_minimum_number_of_companions'].value

	local player=game.players[event.player_index]
	local eventName = eventNameMapping[event.name]
	local numberConnectedPlayers = #game.connected_players

	if eventName == "on_player_joined_game" then
		player.mod_settings["player_desired_speed"].value = math.min(1,player.mod_settings["player_desired_speed"].value)
	end

	game.speed = getNewGameSpeed(numberConnectedPlayers,min_companions,slow_speed_companion)

	local msg = "Companionship: "..numberConnectedPlayers .. " / " .. min_companions .. "    Speed: " .. game.speed

	if eventName ~= "on_player_created" then
		game.print(msg,{r=255,g=255})
	end

	msg = msg .. "    [" .. eventName .."]"
	log(msg)
end


script.on_event({
	defines.events.on_player_changed_force,
	defines.events.on_player_created,
	defines.events.on_player_died,
	defines.events.on_player_joined_game,
	defines.events.on_player_kicked,
	defines.events.on_player_left_game,
	defines.events.on_player_removed,
	defines.events.on_player_respawned,
	defines.events.on_runtime_mod_setting_changed,
},companionship)

