-- Kizrak


local mapGenPresetsDefault = data.raw["map-gen-presets"].default

local rail_world_autoplace_controls = table.deepcopy( mapGenPresetsDefault["rail-world"].basic_settings.autoplace_controls )

rail_world_autoplace_controls.trees = {
	frequency = 1,
	richness = 1,
	size = 2
}

local vonnMapPreset = {
	basic_settings = {
		height = 800, -- like ribbon-world [25*32]
		terrain_segmentation = 0.5, -- like rail-world
		water = 1.5, -- like rail-world
		autoplace_controls = rail_world_autoplace_controls, -- like rail-world
	},
	order = 'v',
	advanced_settings = {
		difficulty_settings  = { research_queue_setting  = "always" },
		enemy_evolution = {
			time_factor = 0.000002, -- like rail-world
			pollution_factor = 0.0000012, -- like death-world
		},
		enemy_expansion = { -- kinda like rail-world???
			min_expansion_cooldown = 30 * 3600, -- 4*3600
			max_expansion_cooldown = 40 * 3600, -- 60*3600
		}
	},
	seed = 1687102566, -- https://wiki.factorio.com/Types/MapGenPreset#seed
}

mapGenPresetsDefault["Vonn"] = vonnMapPreset
--log(serpent.block( mapGenPresetsDefault["Vonn"] ))

