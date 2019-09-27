data.raw["character"]["character"].collision_box = { { 0, 0 }, { 0, 0 } }

local defender = table.deepcopy(data.raw["combat-robot"]["defender"])
log(serpent.block(defender.in_motion))

local character = data.raw["character"]["character"]

log(serpent.block(character.animations))
local animations = {{}}
character.animations = animations

animations[1].idle = defender.idle
animations[1].idle_with_gun = defender.idle
animations[1].mining_with_tool = defender.idle
animations[1].running = defender.in_motion

animations[1].running_with_gun = { layers = { running_gun = {} } }

local running_gun = animations[1].running_with_gun.layers.running_gun

running_gun.direction_count = 18
running_gun.height = 33--59
running_gun.width = 32--56
running_gun.frame_count = 1
running_gun.stripes =
    {
      {
        filename = "__base__/graphics/entity/defender-robot/defender-robot.png",
        width_in_frames = 16,
        height_in_frames = 1
      },
      {
        filename = "__base__/graphics/entity/defender-robot/defender-robot.png",
        width_in_frames = 16,
        height_in_frames = 1
      }
    }


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

for i=1,#animations do
	for j=1,#animations[i].running_with_gun.layers do
		animations[i].running_with_gun.layers[j].frame_count=1
		animations[i].running_with_gun.layers[j].hr_version.frame_count=1
		log(animations[i].running_with_gun.layers[j].hr_version.scale)
		log(animations[i].running_with_gun.layers[j].hr_version.filename)
	end
end

log("--------------------------------------------------------------------------------")

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

log("--------------------------------------------------------------------------------")
log(serpent.block(character.animations))
log("--------------------------------------------------------------------------------")


local railbot = table.deepcopy(data.raw["unit"]["compilatron"])
railbot.name = "railbot"
data:extend{railbot}
log(serpent.block(railbot))

