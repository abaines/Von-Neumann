-- kizrak


-- raw data copies
local character = table.deepcopy(data.raw["character"]["character"])
character.name = "vonn"

-- combat-robot defender copy reference
local defender = table.deepcopy(data.raw["combat-robot"]["defender"])

-- character adjustments
character.selection_box = {{-0.4, -0.4}, {0.4, 0.2}}
character.mining_categories = nil
character.crafting_categories = nil
character.build_distance = 0
character.item_pickup_distance = 0
character.reach_distance = 200000000
character.loot_pickup_distance = 0
character.reach_resource_distance = 0
character.damage_hit_tint = {r = 1, g = 1, b = 1, a = 0}
character.mining_speed = 0.000001
character.icon = "__base__/graphics/icons/defender.png"
character.running_speed = 0.7
character.distance_per_frame = 0.7
character.tool_attack_result = {type="direct"}
character.character_corpse = "vonn-corpse"


-- flying (no collision box)
character.collision_box = { { 0, 0 }, { 0, 0 } }


-- silent "walking" (flying)
character.running_sound_animation_positions = {0}


-- animations
local animations = {{}}
character.animations = animations

-- defender idle behavior
animations[1].idle = defender.idle
animations[1].idle_with_gun = defender.idle
animations[1].mining_with_tool = defender.idle


-- running animations
animations[1].running = table.deepcopy(defender.in_motion)
for _,layer in pairs(animations[1].running.layers) do
	layer.animation_speed = animation_speed
	layer.hr_version.animation_speed = animation_speed
end


-- running_with_gun animations
animations[1].running_with_gun = table.deepcopy(defender.in_motion)

local layers = animations[1].running_with_gun.layers
for _,layer in pairs(layers) do
	layer.direction_count = 18
	layer.hr_version = nil
	layer.y = nil
	layer.line_length = nil
	layer.scale = 0.5
	layer.animation_speed = animation_speed
	layer.frame_count = 4

	local filename = tostring(layer.filename)

	if string.find(filename,"defender-robot.png",0,true) then
		layer.filename = "__vonNeumann__/graphics/hr_character_running_gun.png"
		layer.height = 59
		layer.width = 56

	elseif string.find(filename,"defender-robot-mask.png",0,true) then
		layer.filename = "__vonNeumann__/graphics/hr_character_running_gun_mask.png"
		layer.height = 21
		layer.width = 28

	else
		log(filename)
		error(filename)

	end
end


---------------------------------------------------------------------------------------------------


--log(serpent.block(character.light))

for _,light in pairs(character.light) do
	light.intensity = 1-((1 - light.intensity)/2)
	light.minimum_darkness = 0.0
	light.size = 2 * light.size
end

character.light = {
	{
		intensity = 1,
		size = 5,
		picture = {
			filename = "__core__/graphics/light-cone.png",
			flags = { "light" },
			height = 200,
			priority = "extra-high",
			scale = 2,
			width = 200
		},
		type = "oriented",
		minimum_darkness = 0.0,
		shift = { 0, -30 },
	}
}

character.light = {
	intensity = 1,
	size = 300,
}

--log(serpent.block(character.light))


---------------------------------------------------------------------------------------------------


--[[
	3 north
	4 northeast
	4 east
	4 southeast
	3 south
]]--
data:extend{character}


---------------------------------------------------------------------------------------------------


-- vonn corpse !
local vonnCorpse = table.deepcopy(data.raw["character-corpse"]["character-corpse"])
vonnCorpse.name = "vonn-corpse"
vonnCorpse.pictures = {
	{
		filename = "__base__/graphics/entity/remnants/hr-medium-remnants.png",
		width=236,
		height=246,
	}
}
vonnCorpse.armor_picture_mapping = {}
vonnCorpse.icon = "__base__/graphics/icons/defender.png"
vonnCorpse.selection_box = {{-3, -3}, {3, 3}}
data:extend{vonnCorpse}


---------------------------------------------------------------------------------------------------


local logCharacter = table.deepcopy(character)
logCharacter.animations = nil
logCharacter.footstep_particle_triggers = nil
--log(serpent.block(logCharacter))


---------------------------------------------------------------------------------------------------


--data.raw["utility-constants"].default.zoom_to_world_can_use_nightvision = true
--data.raw["utility-constants"].default.zoom_to_world_effect_strength = 0.0
--data.raw["utility-constants"].default.zoom_to_world_darkness_multiplier = 0.0


---------------------------------------------------------------------------------------------------


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


---------------------------------------------------------------------------------------------------


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

