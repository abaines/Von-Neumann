data.raw["character"]["character"].collision_box = { { 0, 0 }, { 0, 0 } }

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

animations[1].idle = defender.idle
animations[1].idle_with_gun = defender.idle
animations[1].mining_with_tool = defender.idle
animations[1].running = table.deepcopy(defender.in_motion)
animations[1].running_with_gun = table.deepcopy(defender.in_motion)


log("------------------------------ animations[1].running_with_gun.layers ------------------------------")
local layers = animations[1].running_with_gun.layers
for _,layer in pairs(layers) do
	layer.direction_count = 18
	layer.hr_version = nil
	layer.y = nil
	layer.line_length = nil
	layer.scale = 0.5
	layer.animation_speed = 60

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
--running_gun.frame_count = 1
--running_gun.stripes = util.multiplystripes(2,
--	{{
--		filename = "__base__/graphics/entity/defender-robot/defender-robot.png",
--		width_in_frames = 16,
--		height_in_frames = 1
--	}}
--)


--[[
3 north
4 northeast
4 east
4 southeast
3 south

59 height
56 width
]]--

--[[
animations[1].running_with_gun = defender.in_motion
animations[1].running_with_gun.direction_count = 18
]]--


--local layers = animations[1].running_with_gun.layers
--log("--------------------------------------------------------------------------------")
--log(#layers)
--log(serpent.block(layers))
--log("--------------------------------------------------------------------------------")

--[[
for i=1,#animations do
	for j=1,#animations[i].running_with_gun.layers do
		animations[i].running_with_gun.layers[j].frame_count=1
		animations[i].running_with_gun.layers[j].hr_version.frame_count=1
		log(animations[i].running_with_gun.layers[j].hr_version.scale)
		log(animations[i].running_with_gun.layers[j].hr_version.filename)
	end
end
]]--

--log("--------------------------------------------------------------------------------")

--layers[1].frame_count = 1
--layers[2].frame_count = 1
--layers[3].frame_count = 1
--layers[4].frame_count = 1
--layers[5].frame_count = 1

--layers[1].hr_version.frame_count = 1
--layers[2].hr_version.frame_count = 1
--layers[3].hr_version.frame_count = 1
--layers[4].hr_version.frame_count = 1
--layers[5].hr_version.frame_count = 1

--[[
local hr_version = layers[1].hr_version
log("--------------------------------------------------------------------------------")
log(serpent.block(hr_version))
log("--------------------------------------------------------------------------------")

hr_version.filename = "__vonNeumann__/graphics/hr_character_running_gun.png"
hr_version.height = 59
hr_version.width = 56
--hr_version.scale = 0.5
--hr_version.frame_count = 1


log("--------------------------------------------------------------------------------")
log(serpent.block(animations[1].running_with_gun))
log("--------------------------------------------------------------------------------")
log(serpent.block(animations[2].running_with_gun))
log("--------------------------------------------------------------------------------")
log(serpent.block(animations[3].running_with_gun))
log("--------------------------------------------------------------------------------")
log(#animations)
for i=1,3 do
	log(#animations[i].running_with_gun.layers)
end
log("--------------------------------------------------------------------------------")


animations[1].running = defender.in_motion

--[[
animations[1].running_with_gun = {
	layers = {
		running_gun = {
			width = 40,
			height = 52,
			frame_count = 2,
			axially_symmetrical = false,
			direction_count = 18,
			shift = util.by_pixel(0.0, -14.0),
			stripes = { {
					filename = "__base__/graphics/entity/defender-robot/defender-robot.png",
					width_in_frames = 2,
					height_in_frames = 16
				}, {
					filename = "__base__/graphics/entity/defender-robot/defender-robot.png",
					width_in_frames = 2,
					height_in_frames = 16
				}
			},

			hr_version = {
				width = 78,
				height = 104,
				frame_count = 2,
				axially_symmetrical = false,
				direction_count = 18,
				shift = util.by_pixel(0.0, -14),
				scale = 0.5,
				stripes = { {
						filename = "__base__/graphics/entity/defender-robot/hr-defender-robot.png",
						width_in_frames = 2,
						height_in_frames = 16
					}, {
						filename = "__base__/graphics/entity/defender-robot/hr-defender-robot.png",
						width_in_frames = 2,
						height_in_frames = 16
					}
				},
			}
		},
		running_gun_shadow = {
			width = 72,
			height = 30,
			frame_count = 2,
			direction_count = 18,
			shift = util.by_pixel(19, 0.0),
			draw_as_shadow = true,
			stripes = util.multiplystripes(2, { {
						filename = "__base__/graphics/entity/defender-robot/defender-robot-shadow.png",
						width_in_frames = 1,
						height_in_frames = 32
					}
				}),
			hr_version = {
				width = 142,
				height = 56,
				frame_count = 2,
				axially_symmetrical = false,
				direction_count = 18,
				shift = util.by_pixel(15.5, -0.5),
				draw_as_shadow = true,
				scale = 0.5,
				stripes = util.multiplystripes(2, { {
							filename = "__base__/graphics/entity/defender-robot/hr-defender-robot-shadow.png",
							width_in_frames = 1,
							height_in_frames = 32
						}
					})
			}
		}
	}
}
]]--

--animations[1].running_sound_animation_positions = {1}

--[[
	data.raw["character"]["character"].animations = { {
			idle = defender.idle,
			idle_with_gun = defender.idle,
			running = defender.idle,
			running_with_gun = defender.idle,
		}
	}
]]--

--]]--

--log("--------------------------------------------------------------------------------")
--log(serpent.block(character.animations))
--log("--------------------------------------------------------------------------------")


local railbot = table.deepcopy(data.raw["unit"]["compilatron"])
railbot.name = "railbot"
data:extend{railbot}
--log(serpent.block(railbot))

