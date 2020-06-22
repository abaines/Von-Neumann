-- Kizrak


-- railbot !
local railbot = table.deepcopy(data.raw["unit"]["compilatron"])
railbot.name = "railbot"
railbot.max_health = 250
railbot.healing_per_tick = 1.0/60.0
railbot.map_color.a = 1
railbot.collision_box = { { -0.01, -0.01 }, { 0.01, 0.01 } }
railbot.attack_parameters = {
	type="projectile",
	range=0,
	cooldown=120,
	ammo_category = "melee",
	ammo_type = {
		category = "melee",
		target_type = "entity",
		action = {
			type = "direct",
			action_delivery = {
				type = "instant",
				target_effects = {
					type = "damage",
					damage = {
						amount = 6,
						type = "physical",
					}
				}
			}
		}
	},
	animation = railbot.attack_parameters.animation
}
railbot.resistances = {
	{
		type = "fire",
		decrease = 3,
		percent = 80,
	},
}
railbot.corpse = "big-remnants"
data:extend{railbot}

