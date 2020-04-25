
-- taken from Factorio version 0.18.19

local sounds = require("prototypes.entity.demo-sounds")

local compilatron_chest = {
	type = "container",
	name = "compilatron-chest",
	icon = "__vonNeumann__/graphics/icons/compilatron-chest.png",
	icon_size = 64, icon_mipmaps = 4,
	flags = {"placeable-neutral", "player-creation"},
	minable = {mining_time = 0.1, result = "compilatron-chest"},
	max_health = 100,
	corpse = "small-remnants",
	collision_box = {{-0.35, -0.35}, {0.35, 0.35}},
	fast_replaceable_group = "container",
	selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
	inventory_size = 32,
	open_sound = { filename = "__base__/sound/wooden-chest-open.ogg", volume = 0.8 },
	close_sound = { filename = "__base__/sound/wooden-chest-close.ogg", volume = 0.8 },
	vehicle_impact_sound = sounds.car_wood_impact(0.5),
	picture =
	{
		layers =
		{
			{
				filename = "__vonNeumann__/graphics/entity/compilatron-chest/compilatron-chest.png",
				priority = "extra-high",
				width = 34,
				height = 40,
				shift = util.by_pixel(0, -3),
				hr_version =
				{
					filename = "__vonNeumann__/graphics/entity/compilatron-chest/hr-compilatron-chest.png",
					priority = "extra-high",
					width = 68,
					height = 79,
					shift = util.by_pixel(0, -3),
					scale = 0.5
				}
			},
			{
				filename = "__vonNeumann__/graphics/entity/compilatron-chest/compilatron-chest-shadow.png",
				priority = "extra-high",
				width = 57,
				height = 21,
				shift = util.by_pixel(12, 6),
				draw_as_shadow = true,
				hr_version =
				{
					filename = "__vonNeumann__/graphics/entity/compilatron-chest/hr-compilatron-chest-shadow.png",
					priority = "extra-high",
					width = 114,
					height = 41,
					shift = util.by_pixel(12, 6),
					draw_as_shadow = true,
					scale = 0.5
				}
			}
		}
	},
	circuit_wire_connection_point = circuit_connector_definitions["chest"].points,
	circuit_connector_sprites = circuit_connector_definitions["chest"].sprites,
	circuit_wire_max_distance = default_circuit_wire_max_distance
}

data:extend{compilatron_chest}

