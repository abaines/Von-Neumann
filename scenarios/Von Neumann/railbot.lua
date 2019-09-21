-- Kizrak



railbot = {}

railbot.on_tick = function(event)
	local eventName = vonn.eventNameMapping[event.name]
	--vonn.kprint(eventName)
end


script.on_event(defines.events.on_tick,railbot.on_tick)

railbot.spawnBeam = function(surface,target_position,compilatron)
	return surface.create_entity{
		name="electric-beam",
		source=compilatron,
		target_position=target_position,
		position={0,0},duration=60*4.5
	}
end

railbot.spawnRailbot = function(player)
	-- TODO: consume energy/science? to make railbot
	local surface = player.surface
	local compilatron = surface.create_entity{name="compilatron",position={0,1.1},force=player.force}

	railbot.spawnBeam(surface,{-19,-19},compilatron)
	railbot.spawnBeam(surface,{ 19,-19},compilatron)
	railbot.spawnBeam(surface,{-19, 19},compilatron)
	railbot.spawnBeam(surface,{ 19, 19},compilatron)

	return compilatron
end

railbot.findRailbot = function(player)
	local surface = player.surface
	local compilatrons = surface.find_entities_filtered({force = "player", name="compilatron"})

	log("#compilatrons" .. #compilatrons)

	if #compilatrons>=1 then
		-- TODO deal with bonus compilatrons?
		return compilatrons[1]

	elseif #compilatrons<1 then
		return railbot.spawnRailbot(player)

	end

end

railbot.addGui = function(player)
	local gui = player.gui.top
	gui.enabled = true
	gui.add{type="frame", name="greeting", caption="Hi"}
end


railbot.command = function(param)
	local player_index=param.player_index
	local player=game.players[player_index]
	local name = param.name
	local tick = param.tick
	local parameter  = param.parameter

	railbot.addGui(player)

	local compilatron = railbot.findRailbot(player)

	if parameter==nil then
		player.print("need a command: follow, home, stay")

	elseif string.find(parameter, "follow") then
		game.print("Railbot is following " .. player.name)
		compilatron.set_command{type = defines.command.go_to_location, destination = player.position}

	elseif string.find(parameter, "home") then
		log("railbot home " .. player.name)
		game.print("Railbot is going home")

	elseif string.find(parameter, "stay") then
		log("railbot stay " .. player.name)
		game.print("Railbot is staying here")

	end
end


commands.add_command("railbot", "railbot", railbot.command)

