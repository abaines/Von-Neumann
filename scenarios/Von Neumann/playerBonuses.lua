-- Kizrak

--- needs "hijack"



function disableGodResearches()
	local playerForce = game.forces["player"]

	local researchesToDisable = {
		["atomic-bomb"] = true,
		["auto-character-logistic-trash-slots"] = true,
		["automobilism"] = true,
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
		["military"] = true,
		["military-3"] = true,
		["military-4"] = true,
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
		["stronger-explosives-1"] = true,
		["tanks"] = true,
		["toolbelt"] = true,
		["weapon-shooting-speed-1"] = true,
		["weapon-shooting-speed-2"] = true,
		["weapon-shooting-speed-3"] = true,
		["weapon-shooting-speed-4"] = true,
		["weapon-shooting-speed-5"] = true,
		["weapon-shooting-speed-6"] = true,
	}

	for research,visible_when_disabled in pairs(researchesToDisable) do
		playerForce.technologies[research].enabled = false
		playerForce.technologies[research].visible_when_disabled = visible_when_disabled
	end
end


function apply_bonuses()
	if false then
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

		for _,recipe in pairs(player.force.recipes) do
			player.force.set_hand_crafting_disabled_for_recipe(recipe,true)
		end

		player.force.zoom_to_world_ghost_building_enabled = true
		player.force.zoom_to_world_blueprint_enabled = true
		player.force.zoom_to_world_deconstruction_planner_enabled = true
		player.force.zoom_to_world_selection_tool_enabled = true
	end

	disableGodResearches()

	local numberPlayers = #game.players
	local msg = "apply_bonuses complete: " .. numberPlayers
	print(msg)
	log(msg)
	if not game.is_multiplayer() then
		game.print(msg,{r=255,g=255})
	end
end

script.on_init(apply_bonuses)

script.on_event({
defines.events.on_player_joined_game,
defines.events.on_player_created,
defines.on_player_respawned,
},apply_bonuses)

commands.add_command("bonus", "bonus", apply_bonuses)

