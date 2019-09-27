-- kizrak


-- raw data copies
local character = table.deepcopy(data.raw["character"]["character"])
character.name = "vonn"

-- combat-robot defender copy reference
local defender = table.deepcopy(data.raw["combat-robot"]["defender"])


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

--[[
	3 north
	4 northeast
	4 east
	4 southeast
	3 south
]]--
data:extend{character}


log(serpent.block( data.raw["utility-constants"].default.zoom_to_world_can_use_nightvision ))
log(serpent.block( data.raw["utility-constants"].default.zoom_to_world_effect_strength ))
log(serpent.block( data.raw["utility-constants"].default.zoom_to_world_darkness_multiplier ))

data.raw["utility-constants"].default.zoom_to_world_can_use_nightvision = true
data.raw["utility-constants"].default.zoom_to_world_effect_strength = 0.05
data.raw["utility-constants"].default.zoom_to_world_darkness_multiplier = 0.5


-- railbot !
local railbot = table.deepcopy(data.raw["unit"]["compilatron"])
railbot.name = "railbot"
data:extend{railbot}

