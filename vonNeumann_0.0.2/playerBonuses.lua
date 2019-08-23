-- Kizrak

--- needs "hijack"


function apply_bonuses()
	game.forces.player.character_build_distance_bonus = 125
	game.forces.player.character_reach_distance_bonus = 125
	game.forces.player.character_resource_reach_distance_bonus = 7
	game.forces.player.character_item_pickup_distance_bonus = 7
	game.forces.player.character_inventory_slots_bonus = 80

	if false then
		game.player.force.technologies['engine'].researched=true
		game.player.force.technologies['railway'].researched=true
		game.player.force.technologies['automated-rail-transportation'].researched=true
	end

	for i, player in pairs(game.players) do
		player.game_view_settings.show_rail_block_visualisation = true
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

