-- Kizrak


local sb = serpent.block -- luacheck: ignore 211

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
	order = 'VONN',
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



local resource = data.raw["resource"]

for name,value in pairs(data.raw["autoplace-control"]) do
	local category = value.category
	if category == "resource" then
		--log(name .. "   " .. tostring(resource[name].category))
		--log(sb(value))

		local autoplace_control  = {
			frequency = 1/4,  -- railworld: 1/3
			size = 3/2,       -- railworld: 3
			richness = 1,     -- railworld: 1
		}

		if resource[name] and resource[name].category == "basic-fluid" then -- luacheck: ignore 542
			-- use above

		elseif resource[name] and resource[name].infinite then
			autoplace_control.frequency = 1/6
			autoplace_control.size = 1/2
			autoplace_control.richness = 1/2

		end

		vonnMapPreset.basic_settings.autoplace_controls[name] = autoplace_control
	end
end


mapGenPresetsDefault["Vonn"] = vonnMapPreset
--log(sb( vonnMapPreset.basic_settings.autoplace_controls ))


-- you are using mods, and you are an AI robot, you should be able to handle a research queue!
data.raw["map-settings"]["map-settings"]["difficulty_settings"].research_queue_setting = "always"
--log(sb( data.raw["map-settings"]["map-settings"] ))

