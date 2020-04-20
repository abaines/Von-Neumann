-- Kizrak


local vonn = require("vonNeumann")

local railbot = {}


railbot.allowedGhostNames = {
	"curved-rail",
	"straight-rail",
	"train-stop",
	"rail-chain-signal",
	"rail-signal",

	"big-electric-pole",
	"roboport",
	"inserter",
	"vn-inserter",
	"logistic-chest-storage",
}

railbot.searchGhost = function()
	local railbotUnit = railbot.findRailbot()
	if not ( railbotUnit and railbotUnit.valid ) then return end

	local ghosts = railbotUnit.surface.find_entities_filtered{
		position=railbotUnit.position,
		radius=60,
		ghost_name=railbot.allowedGhostNames
	}

	return ghosts, railbotUnit
end

railbot.manhattanDistanceEntities = function(entityA, entityB)
	return railbot.manhattanDistance(entityA.position,entityB.position)
end

railbot.manhattanDistance = function(positionA, positionB)
	return math.abs(positionA.x - positionB.x) + math.abs(positionA.y - positionB.y)
end

railbot.getBuffers = function(surface)
	local buffers = surface.find_entities_filtered{
		position={0,0},
		radius=9,
		name="logistic-chest-buffer"
	}
	return buffers
end

railbot.removeFromBuffers = function(surface,item,count)
	count = count or 1
	local buffers = railbot.getBuffers(surface)

	vonn.kprint(item.." " .. #buffers.." " .. count)
	for index,buffer in pairs(buffers) do
		local inventory = buffer.get_inventory(defines.inventory.chest)
		local removed = inventory.remove({name=item, count=count})

		if removed>=count then
			return
		else
			count = count - removed
		end
	end
end



railbot.ghostBehavior = function(_)
	local ghosts, railbotUnit = railbot.searchGhost()

	if ghosts and #ghosts>0 and railbotUnit and railbotUnit.valid then
		table.sort(ghosts,function(a,b)
			return railbot.manhattanDistanceEntities(railbotUnit,a)<railbot.manhattanDistanceEntities(railbotUnit,b)
		end)

		local surface = railbotUnit.surface

		local itemsAvailable = railbot.bufferChestAvailableItems(surface)

		for index,ghost in pairs(ghosts) do
			local ghost_name = ghost.ghost_name
			if ghost_name == "curved-rail" or ghost_name == "straight-rail" then
				ghost_name = "rail"
			end

			if itemsAvailable[ghost_name] then
				local position = ghost.position
				-- replace ghost with item
				ghost.revive()
				-- delete item from buffer
				railbot.removeFromBuffers(surface,ghost_name)
				-- TODO: lasers!
				surface.create_entity{
					name="laser-beam",
					source=railbotUnit,
					target_position=position,
					position={0,0},duration=60*4.5
				}
				return

			else -- luacheck: ignore 542
				--vonn.kprint(game.tick .. " " .. ghost_name)

			end
		end
	end
end

railbot.bufferChestAvailableItems = function(surface)
	local buffers = railbot.getBuffers(surface)

	local dictionary = {}

	--vonn.kprint(#buffers)
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
	--local eventName = vonn.eventNameMapping[event.name]

	railbot.ghostBehavior(event)
end

script.on_nth_tick(8,railbot.on_tick)


railbot.findTreesMarkedForDecon = function(railbotUnit)
	if not ( railbotUnit and railbotUnit.valid ) then return {} end

	local trees = railbotUnit.surface.find_entities_filtered{
		position=railbotUnit.position,
		radius=60,
		type="tree"
	}

	local deconTrees = {}

	for index,tree in pairs(trees) do
		if tree.to_be_deconstructed(railbotUnit.force) then
			table.insert(deconTrees, tree)
		end
	end

	local function sortTrees(a,b)
		return railbot.manhattanDistanceEntities(railbotUnit,a)<railbot.manhattanDistanceEntities(railbotUnit,b)
	end

	table.sort(deconTrees,sortTrees)

	return deconTrees
end

railbot.burnTrees = function(railbotUnit)
	if not ( railbotUnit and railbotUnit.valid ) then return end

	local trees = railbot.findTreesMarkedForDecon(railbotUnit)

	-- we only want to burn the first tree we find
	for index,tree in pairs(trees) do -- luacheck: ignore 512
		railbotUnit.surface.create_entity{
			name="fire-flame",
			position=tree.position,
			initial_ground_flame_count=85
		}
		railbotUnit.surface.create_entity{
			name="laser-beam",
			source=railbotUnit,
			target_position=tree.position,
			position={0,0},duration=20
		}
		tree.damage(5,railbotUnit.force,"explosion")

		return
	end
end

railbot.burnTreeBehavior = function(_)
	local railbotUnit = railbot.findRailbot()
	if not ( railbotUnit and railbotUnit.valid ) then return end

	local robots = railbotUnit.surface.find_entities_filtered{
		position=railbotUnit.position,
		radius=60,
		type = {"construction-robot", "logistic-robot" }
	}

	if #robots>1 then
		return
	end

	railbot.burnTrees(railbotUnit)
end

script.on_nth_tick(20,railbot.burnTreeBehavior)


railbot.spawnBeam = function(surface,target_position,railbotUnit)
	return surface.create_entity{
		name="electric-beam",
		source=railbotUnit,
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

	local crashSiteGenerators = surface.find_entities_filtered{name="crash-site-generator"}
	local neededEnergy = 5000000*600*0.999
	vonn.kprint("#crashSiteGenerators "..#crashSiteGenerators)
	for _,crashSiteGenerator in pairs(crashSiteGenerators) do
		local energy = crashSiteGenerator.energy
		vonn.kprint(energy)

		if energy<neededEnergy then
			local ratio = energy/neededEnergy*100
			player.print("Not enough energy in main reactor core (3GJ) to create Railbot: " .. tonumber(string.format("%.3f", ratio)) .. " %")
			return
		end
	end

	local railbotUnit = surface.create_entity{name="railbot",position={0,1.1},force=force}

	rendering.draw_light{
		sprite="utility/light_medium",
		target=railbotUnit,
		surface=railbotUnit.surface,
		forces={railbotUnit.force},
		scale = 40,
		color = {r=0.1,g=0.1,b=1},
	}

	railbot.spawnBeam(surface,{-19,-19},railbotUnit)
	railbot.spawnBeam(surface,{ 19,-19},railbotUnit)
	railbot.spawnBeam(surface,{-19, 19},railbotUnit)
	railbot.spawnBeam(surface,{ 19, 19},railbotUnit)

	surface.create_trivial_smoke{name="fire-smoke",position=railbotUnit.position}
	surface.create_trivial_smoke{name="artillery-smoke",position=railbotUnit.position}
	surface.create_trivial_smoke{name="nuclear-smoke",position=railbotUnit.position}
	surface.create_trivial_smoke{name="smoke-explosion-particle",position=railbotUnit.position}
	surface.create_trivial_smoke{name="smoke-fast",position=railbotUnit.position}
	surface.create_trivial_smoke{name="tank-smoke",position=railbotUnit.position}
	surface.create_trivial_smoke{name="turbine-smoke",position=railbotUnit.position}

	for _,crashSiteGenerator in pairs(crashSiteGenerators) do
		crashSiteGenerator.energy=crashSiteGenerator.energy-neededEnergy
	end

	return railbotUnit
end

railbot.findRailbot = function(player)
	local surface = game.surfaces["nauvis"]
	if player and player.valid then
		surface = player.surface
	end
	local railbotUnits = surface.find_entities_filtered({force = "player", name="railbot"})

	--log("#railbotUnits" .. #railbotUnits)

	if #railbotUnits>=1 then
		-- TODO deal with bonus railbotUnits?
		return railbotUnits[1]

	elseif #railbotUnits<1 and player and player.valid then
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

	-- luacheck: ignore 211
	local railbot_gui_follow = railbot_gui.add{type="button",name="railbot_gui_follow",caption="Follow"}
	local railbot_gui_stay = railbot_gui.add{type="button",name="railbot_gui_stay",caption="Stay"}
	local railbot_gui_home = railbot_gui.add{type="button",name="railbot_gui_home",caption="Home"}
end

railbot.command = function(player,command)
	local railbotUnit = railbot.findRailbot(player)
	if not ( railbotUnit and railbotUnit.valid ) then return end

	if command==nil then
		player.print("need a command: follow, home, stay")

	elseif string.find(command, "follow") then
		game.print("Railbot is following " .. player.name)
		railbotUnit.set_command{type = defines.command.go_to_location, destination = player.position}
		railbotUnit.surface.create_entity{
			name="laser-beam",
			source=railbotUnit,
			target_position=player.position,
			position={0,0},duration=6
		}

	elseif string.find(command, "home") then
		log("railbot home " .. player.name)
		game.print("Railbot is going home")
		railbotUnit.set_command{type = defines.command.go_to_location, destination = {0,0}}
		railbotUnit.surface.create_entity{
			name="laser-beam",
			source=railbotUnit,
			target_position={0,0},
			position={0,0},duration=6
		}

	elseif string.find(command, "stay") then
		log("railbot stay " .. player.name)
		game.print("Railbot is staying here")
		railbotUnit.set_command{type = defines.command.go_to_location, destination = railbotUnit.position}

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
	--local name = param.name
	--local tick = param.tick
	local parameter  = param.parameter

	railbot.addGui(player)

	if parameter==nil then
		player.print("need a command: follow, home, stay")

	else
		railbot.command(player,parameter)

	end
end


railbot.on_entity_died = function(event)
	local cause = event.cause
	local entity = event.entity

	if cause and cause.valid and cause.name == "railbot" and entity.valid and entity.force.name=="enemy" then
		local surface = cause.surface
		cause.surface.create_entity{name="atomic-rocket",position=cause.position,target=cause,speed=0.01,max_range=2000}
		cause.die()

		local crashSiteGenerators = surface.find_entities_filtered{name="crash-site-generator"}
		vonn.kprint(#crashSiteGenerators)
		for index,crashSiteGenerator in pairs(crashSiteGenerators) do
			crashSiteGenerator.energy=0
		end
		local playerForce = game.forces["player"]
		playerForce.print("Railbot suffered critical reactor damage and exploded, resulting in an EMP that has wiped out the main reactor's energy storage!")
	end
end

script.on_event({
	defines.events.on_entity_died,
},railbot.on_entity_died)


commands.add_command("railbot", "railbot", railbot.commandLine)

