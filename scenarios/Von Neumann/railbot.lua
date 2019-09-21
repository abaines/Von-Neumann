-- Kizrak



railbot = {}

railbot.on_tick = function(event)
	local eventName = vonn.eventNameMapping[event.name]
	--vonn.kprint(eventName)
end


script.on_event(defines.events.on_tick,railbot.on_tick)


railbot.command = function(param)
	local player_index=param.player_index
	local player=game.players[player_index]
	local name = param.name
	local tick = param.tick
	local parameter  = param.parameter

	if parameter==nil then
		player.print("need a command: follow, home, stay")
	else
	end
end


commands.add_command("railbot", "railbot", railbot.command)

