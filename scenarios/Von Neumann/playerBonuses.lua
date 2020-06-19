-- Kizrak


local script,kprint = require('k-lib')() -- luacheck: ignore 211


local log_spam_guard = {}


local function disableGodResearches()
	local playerForce = game.forces["player"]

	local researchesToDisable = {
		["atomic-bomb"] = true,
		["auto-character-logistic-trash-slots"] = true,
		["battery-equipment"] = true,
		["battery-mk2-equipment"] = true,
		["belt-immunity-equipment"] = true,
		["character-logistic-slots-1"] = true,
		["character-logistic-slots-2"] = true,
		["character-logistic-slots-3"] = true,
		["character-logistic-slots-4"] = true,
		["character-logistic-slots-5"] = true,
		["character-logistic-slots-6"] = true,
		["character-logistic-trash-slots-1"] = true,
		["character-logistic-trash-slots-2"] = true,
		["character-logistic-trash-slots-3"] = true,
		["character-logistic-trash-slots-4"] = true,
		["character-logistic-trash-slots-5"] = true,
		["combat-robotics"] = true,
		["combat-robotics-2"] = true,
		["combat-robotics-3"] = true,
		["discharge-defense-equipment"] = true,
		["energy-shield-equipment"] = true,
		["energy-shield-mk2-equipment"] = true,
		["exoskeleton-equipment"] = true,
		["explosive-rocketry"] = true,
		["follower-robot-count-1"] = true,
		["follower-robot-count-2"] = true,
		["follower-robot-count-3"] = true,
		["follower-robot-count-4"] = true,
		["follower-robot-count-5"] = true,
		["follower-robot-count-6"] = true,
		["follower-robot-count-7"] = true,
		["fusion-reactor-equipment"] = true,
		["heavy-armor"] = true,
		["modular-armor"] = true,
		["night-vision-equipment"] = true,
		["personal-laser-defense-equipment"] = true,
		["personal-roboport-equipment"] = true,
		["personal-roboport-mk2-equipment"] = true,
		["power-armor"] = true,
		["power-armor-mk2"] = true,
		["rocketry"] = true,
		["solar-panel-equipment"] = true,
		["steel-axe"] = true,
		["toolbelt"] = true,
		["weapon-shooting-speed-1"] = true,
		["weapon-shooting-speed-2"] = true,
		["weapon-shooting-speed-3"] = true,
		["weapon-shooting-speed-4"] = true,
		["weapon-shooting-speed-5"] = true,
		["weapon-shooting-speed-6"] = true,
	}

	for research, _ in pairs(researchesToDisable) do
		if playerForce.technologies[research] then
			playerForce.technologies[research].enabled = false
			playerForce.technologies[research].visible_when_disabled = false
		elseif not log_spam_guard[research] then
			log(research)
			log_spam_guard[research] = true
		end
	end

	local researchedToEnable = {
		["automobilism"] = true,
		["military"] = true,
		["military-4"] = true,
		["stronger-explosives-1"] = true,
		["tanks"] = true,
	}

	for research,_ in pairs(researchedToEnable) do
		playerForce.technologies[research].enabled = true
		playerForce.technologies[research].researched = true
		playerForce.technologies[research].visible_when_disabled = false
	end

	local recipesToDisable = {
		["car"] = true,
		["tank"] = true,
		["pistol"] = true,
		["combat-shotgun"] = true,
		["shotgun"] = true,
		["shotgun-shell"] = true,
		["piercing-shotgun-shell"] = true,
		["cluster-grenade"] = true,
		["submachine-gun"] = true,
		["light-armor"] = true,
		["explosive-cannon-shell"] = true,
		["cannon-shell"] = true,
	}

	for recipe_name,_ in pairs(recipesToDisable) do
		local recipe = playerForce.recipes[recipe_name]
		recipe.enabled  = false
	end


	-- "steel-processing"
	local recipesBasedOnSteel = {
		["rail"] = true,
		["train-stop"] = true,
		["locomotive"] = true,
		["cargo-wagon"] = true,
		["engine-unit"] = true,
	}

	local steelProcessingResearched = playerForce.technologies["steel-processing"].researched

	for recipe_name in pairs(recipesBasedOnSteel) do
		local recipe = playerForce.recipes[recipe_name]
		recipe.enabled  = steelProcessingResearched
	end


	--[[
	local recipesBasedOnAdvancedElectronics = {
		["logistic-robot"] = true,
		["logistic-chest-active-provider"] = true,
		["logistic-chest-buffer"] = true,
		["logistic-chest-passive-provider"] = true,
		["logistic-chest-requester"] = true,
		["logistic-chest-storage"] = true,
		["roboport"] = true,
	}

	local advancedElectronicsResearched = playerForce.technologies["advanced-electronics"].researched

	for recipe_name in pairs(recipesBasedOnAdvancedElectronics) do
		local recipe = playerForce.recipes[recipe_name]
		recipe.enabled  = advancedElectronicsResearched
	end
	]]--


	-- "logistic-science-pack"
	local recipesWaitingForLogisticSciencePack = {
		["logistic-robot"] = true,
		["construction-robot"] = true,
		["logistic-chest-active-provider"] = true,
		["logistic-chest-passive-provider"] = true,
		["logistic-chest-storage"] = true,
		["logistic-chest-buffer"] = true,
		["logistic-chest-requester"] = true,
		["roboport"] = true,
		["pipe"] = true,
		["pipe-to-ground"] = true,
		["stone-brick"] = true,
		["repair-pack"] = true,
		["boiler"] = true,
		["steam-engine"] = true,
		["offshore-pump"] = true,
		["firearm-magazine"] = true,
		["radar"] = true,
	}

	local logisticSciencePackResearched = playerForce.technologies["logistic-science-pack"].researched
	or playerForce.technologies["automation"].researched
	or playerForce.technologies["logistics"].researched
	or playerForce.technologies["steel-processing"].researched
	or playerForce.technologies["electronics"].researched

	for recipe_name in pairs(recipesWaitingForLogisticSciencePack) do
		local recipe = playerForce.recipes[recipe_name]
		recipe.enabled  = logisticSciencePackResearched
	end
end

script.on_event({
	defines.events.on_research_finished,
},disableGodResearches)


local function apply_bonuses(event)
	if false then
		-- luacheck: ignore 511
		game.forces.player.character_build_distance_bonus = 125
		game.forces.player.character_reach_distance_bonus = 125
		game.forces.player.character_resource_reach_distance_bonus = 7
		game.forces.player.character_item_pickup_distance_bonus = 7
	end
	game.forces.player.character_inventory_slots_bonus = 80

	for i, player in pairs(game.players) do
		player.game_view_settings.show_rail_block_visualisation = true

		player.force.technologies['engine'].researched=true
		player.force.technologies['railway'].researched=true
		player.force.technologies['automated-rail-transportation'].researched=true
		player.force.technologies['logistic-system'].researched=true
		player.force.technologies['logistic-robotics'].researched=true
		player.force.technologies['construction-robotics'].researched=true

		player.force.zoom_to_world_ghost_building_enabled = true
		player.force.zoom_to_world_blueprint_enabled = true
		player.force.zoom_to_world_deconstruction_planner_enabled = true
		player.force.zoom_to_world_selection_tool_enabled = true
	end

	disableGodResearches()

	local player = game.players[event.player_index]

	local numberPlayers = #game.players
	local msg = "Bonuses applied to " ..player.name .. "     (" .. numberPlayers .. ")"
	log(msg)
end


script.on_event({
defines.events.on_player_created,
},apply_bonuses)

commands.add_command("bonus", "bonus", apply_bonuses)


local playerBonuses = {}

script.register_object(playerBonuses)

return playerBonuses

