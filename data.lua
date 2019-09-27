-- kizrak


-- flying
data.raw["character"]["character"].collision_box = { { 0, 0 }, { 0, 0 } }




--data.raw["character"]["character"].running_sound_animation_positions = {}




local animation_speed = 0.1

local defender = table.deepcopy(data.raw["combat-robot"]["defender"])
log("------------------------------ defender.idle ------------------------------")
local defender_for_logging = table.deepcopy(defender.idle)
defender_for_logging.layers[1].hr_version = nil
defender_for_logging.layers[2].hr_version = nil
log(serpent.block(defender_for_logging))
log("------------------------------ defender.in_motion ------------------------------")
local defender_for_logging = table.deepcopy(defender.in_motion)
defender_for_logging.layers[1].hr_version = nil
defender_for_logging.layers[2].hr_version = nil
log(serpent.block(defender_for_logging))

local character = data.raw["character"]["character"]

--log(serpent.block(character.animations))
local animations = {{}}
character.animations = animations

character.running_sound_animation_positions = {0}

animations[1].idle = defender.idle
animations[1].idle_with_gun = defender.idle
animations[1].mining_with_tool = defender.idle
animations[1].running = table.deepcopy(defender.in_motion)

--animations[0].running[1].running_sound_animation_positions = {14, 29}

log("------------------------------ animations[1].running ------------------------------")
--animations[1].running.layers.animation_speed = 0.1
for _,layer in pairs(animations[1].running.layers) do
	--layer.animation_speed = animation_speed
	--layer.running_sound_animation_positions = {14, 29}
	log(layer.filename)
	layer.animation_speed = animation_speed
	layer.hr_version.animation_speed = animation_speed
	log(serpent.block(layer))
end






animations[1].running_with_gun = table.deepcopy(defender.in_motion)

log("------------------------------ animations[1].running_with_gun.layers ------------------------------")
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

	log(serpent.block(layer))
end


-- 21 by 28

--running_gun.direction_count = 18
--running_gun.height = 33--59
--running_gun.width = 32--56



--[[
3 north
4 northeast
4 east
4 southeast
3 south

59 height
56 width
]]--

--animations[1].running_sound_animation_positions = {1}




local railbot = table.deepcopy(data.raw["unit"]["compilatron"])
railbot.name = "railbot"
data:extend{railbot}
--log(serpent.block(railbot))

