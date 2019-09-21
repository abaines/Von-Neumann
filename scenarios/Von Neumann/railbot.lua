-- Kizrak



railbot = {}


railbot.allowedGhostNames = {
	"curved-rail",
	"straight-rail",
	"train-stop",
	"rail-chain-signal",
	"rail-signal",

	"big-electric-pole",
	"roboport",
	"inserter",
	"logistic-chest-storage",
}

railbot.searchGhost = function()
	local compilatron = railbot.findRailbot()
	if not ( compilatron and compilatron.valid ) then return end

	local ghosts = compilatron.surface.find_entities_filtered{
		position=compilatron.position,
		radius=60,
		ghost_name=railbot.allowedGhostNames
	}

	return ghosts, compilatron
end

railbot.manhattanDistanceEntities = function(entityA, entityB)
	return railbot.manhattanDistance(entityA.position,entityB.position)
end

railbot.manhattanDistance = function(positionA, positionB)
	return math.abs(positionA.x - positionB.x) + math.abs(positionA.y - positionB.y)
end

railbot.ghostBehavior = function(event)
	local ghosts, compilatron = railbot.searchGhost()

	if ghosts and #ghosts>0 and compilatron and compilatron.valid then
		table.sort(ghosts,function(a,b)
			return railbot.manhattanDistanceEntities(compilatron,a)<railbot.manhattanDistanceEntities(compilatron,b)
		end)

		local itemsAvailable = railbot.bufferChestAvailableItems(game.surfaces["nauvis"])
		vonn.kprint(serpent.block(itemsAvailable))

		for index,ghost in pairs(ghosts) do
			vonn.kprint(game.tick .. " " .. ghost.ghost_name)
		end
	end
end

railbot.bufferChestAvailableItems = function(surface)
	local buffers = surface.find_entities_filtered{
		position={0,0},
		radius=9,
		name="logistic-chest-buffer"
	}

	local dictionary = {}

	vonn.kprint(#buffers)
	for index,buffer in pairs(buffers) do
		local inventory = buffer.get_inventory(defines.inventory.chest)
		local contents = inventory.get_contents()
		--vonn.kprint(serpent.block(inventory.get_contents()))
		for item,count in pairs(contents) do
			if not dictionary[item] then
				dictionary[item] = 0
			end
			dictionary[item] = count + dictionary[item]
		end
	end

	return dictionary
end

railbot.on_tick = function(event)
	local eventName = vonn.eventNameMapping[event.name]

	railbot.ghostBehavior(event)
end

script.on_nth_tick(90*4,railbot.on_tick)


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
	local surface = game.surfaces["nauvis"]
	local force = "player"
	if player and player.valid then
		surface = player.surface
		force = player.force
	end
	local compilatron = surface.create_entity{name="compilatron",position={0,1.1},force=force}

	railbot.spawnBeam(surface,{-19,-19},compilatron)
	railbot.spawnBeam(surface,{ 19,-19},compilatron)
	railbot.spawnBeam(surface,{-19, 19},compilatron)
	railbot.spawnBeam(surface,{ 19, 19},compilatron)

	surface.create_trivial_smoke{name="fire-smoke",position=compilatron.position}
	surface.create_trivial_smoke{name="artillery-smoke",position=compilatron.position}
	surface.create_trivial_smoke{name="nuclear-smoke",position=compilatron.position}
	surface.create_trivial_smoke{name="smoke-explosion-particle",position=compilatron.position}
	surface.create_trivial_smoke{name="smoke-fast",position=compilatron.position}
	surface.create_trivial_smoke{name="tank-smoke",position=compilatron.position}
	surface.create_trivial_smoke{name="turbine-smoke",position=compilatron.position}

	return compilatron
end

railbot.findRailbot = function(player)
	local surface = game.surfaces["nauvis"]
	if player and player.valid then
		surface = player.surface
	end
	local compilatrons = surface.find_entities_filtered({force = "player", name="compilatron"})

	log("#compilatrons" .. #compilatrons)

	if #compilatrons>=1 then
		-- TODO deal with bonus compilatrons?
		return compilatrons[1]

	elseif #compilatrons<1 and player and player.valid then
		return railbot.spawnRailbot(player)

	end

end


railbot.addGui = function(player)
	local gui = player.gui.left
	for index,name in pairs(gui.children_names) do
		if name == "railbot_gui" then
			return
		end
	end

	local railbot_gui = gui.add{type="frame", name="railbot_gui", caption="Railbot"}

	local railbot_gui_follow = railbot_gui.add{type="button",name="railbot_gui_follow",caption="Follow"}
	local railbot_gui_stay = railbot_gui.add{type="button",name="railbot_gui_stay",caption="Stay"}
	local railbot_gui_home = railbot_gui.add{type="button",name="railbot_gui_home",caption="Home"}
end

railbot.command = function(player,command)
	local compilatron = railbot.findRailbot(player)

	if command==nil then
		player.print("need a command: follow, home, stay")

	elseif string.find(command, "follow") then
		game.print("Railbot is following " .. player.name)
		compilatron.set_command{type = defines.command.go_to_location, destination = player.position}

	elseif string.find(command, "home") then
		log("railbot home " .. player.name)
		game.print("Railbot is going home")
		compilatron.set_command{type = defines.command.go_to_location, destination = {0,0}}

	elseif string.find(command, "stay") then
		log("railbot stay " .. player.name)
		game.print("Railbot is staying here")
		compilatron.set_command{type = defines.command.go_to_location, destination = compilatron.position}

	end
end


railbot.on_gui_click = function(event)
	local player_index=event.player_index
	local player=game.players[player_index]

	if not event.element.valid then return end

	local elementName = event.element.name

	--vonn.kprint(elementName)
	if elementName == "railbot_gui_follow" then
		railbot.command(player,"follow")

	elseif elementName == "railbot_gui_stay" then
		railbot.command(player,"stay")

	elseif elementName == "railbot_gui_home" then
		railbot.command(player,"home")

	else
		railbot.addGui(player)

	end
end

script.on_event({
	defines.events.on_gui_click,
},railbot.on_gui_click)


railbot.commandLine = function(param)
	local player_index=param.player_index
	local player=game.players[player_index]
	local name = param.name
	local tick = param.tick
	local parameter  = param.parameter

	railbot.addGui(player)

	if parameter==nil then
		player.print("need a command: follow, home, stay")

	else
		railbot.command(player,parameter)

	end
end


commands.add_command("railbot", "railbot", railbot.commandLine)

