
-- taken from Factorio version 0.18.19

local compilatron_chest = {
	type = "item",
	name = "compilatron-chest",
	icon = "__base__/graphics/icons/compilatron-chest.png",
	icon_size = 64, icon_mipmaps = 4,
	flags = {"hidden"},
	subgroup = "storage",
	order = "a[items]-d[compilatron-chest]",
	place_result = "compilatron-chest",
	stack_size = 50,
}

data:extend{compilatron_chest}

