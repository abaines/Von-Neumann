-- Kizrak

local eventNameMapping = {}
for eventName,eventId in pairs(defines.events) do
	eventNameMapping[eventId] = eventName
end


function companionship(event)
	local min_companions = settings.startup['minimum_number_of_companions'].value
	local slow_speed_companion = settings.startup['speed_when_below_minimum_number_of_companions'].value

	local eventName = eventNameMapping[event.name]
	local numberConnectedPlayers = #game.connected_players

	local msg = "Companionship: "..numberConnectedPlayers .. " / " .. min_companions .. "  =  " .. game.speed .. "    [" .. eventName .."]"
	log(msg)

	if numberConnectedPlayers < min_companions then
		game.speed = slow_speed_companion
	else
		game.speed = 1
	end

	if eventName ~= "on_player_created" then
		game.print(msg,{r=255,g=255})
	end
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
},companionship)

