-- Kizrak


local sb = serpent.block -- luacheck: ignore 211

-- replace __base__ path with __vonNeumann__
local function pathReplace(base)
	return string.gsub(base,"__base__","__vonNeumann__")
end

local accumulator = table.deepcopy( data.raw.accumulator.accumulator )

accumulator.name = "vn-accumulator"
accumulator.circuit_wire_max_distance = 16 --default: 9

accumulator.energy_source = {
	buffer_capacity = "3GJ",
	type = "electric",
	usage_priority = "tertiary",
}

accumulator.max_health = 2000

data:extend{accumulator}

