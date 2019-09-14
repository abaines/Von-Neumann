-- Kizrak

--- needs "hijack"


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

		if true then
			player.force.technologies['engine'].researched=true
			player.force.technologies['railway'].researched=true
			player.force.technologies['automated-rail-transportation'].researched=true
			player.force.technologies['logistic-system'].researched=true
			player.force.technologies['logistic-robotics'].researched=true
			player.force.technologies['construction-robotics'].researched=true

			player.force.technologies['heavy-armor'].enabled = false
			player.force.technologies['heavy-armor'].visible_when_disabled = true

			player.force.technologies['stronger-explosives-1'].enabled = false
			player.force.technologies['stronger-explosives-1'].visible_when_disabled = true

			player.force.technologies['combat-robotics'].enabled = false
			player.force.technologies['combat-robotics'].visible_when_disabled = true

			player.force.technologies['steel-axe'].enabled = false
			player.force.technologies['steel-axe'].visible_when_disabled = true
		end

		for _,recipe in pairs(player.force.recipes) do
			player.force.set_hand_crafting_disabled_for_recipe(recipe,true)
		end

		player.force.zoom_to_world_ghost_building_enabled = true
		player.force.zoom_to_world_blueprint_enabled = true
		player.force.zoom_to_world_deconstruction_planner_enabled = true
		player.force.zoom_to_world_selection_tool_enabled = true
	end

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

