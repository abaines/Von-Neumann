
-- taken from Factorio version 0.18.19

local sounds = {}

sounds.car_wood_impact = function(volume)
	return
	{
		{
			filename = "__base__/sound/car-wood-impact.ogg", volume = volume
		},
		{
			filename = "__base__/sound/car-wood-impact-02.ogg", volume = volume
		},
		{
			filename = "__base__/sound/car-wood-impact-03.ogg", volume = volume
		},
		{
			filename = "__base__/sound/car-wood-impact-04.ogg", volume = volume
		},
		{
			filename = "__base__/sound/car-wood-impact-05.ogg", volume = volume
		},
	}
end

return sounds

