-- Kizrak


local sb = serpent.block -- luacheck: ignore 211

-- replace __base__ path with __vonNeumann__
local function pathReplace(base) -- luacheck: ignore 211
	return string.gsub(base,"__base__","__vonNeumann__")
end

local generator = table.deepcopy( data.raw['electric-energy-interface']['crash-site-generator'] )

generator.name = "vn-crash-site-generator"
generator.gui_mode = "none"

generator.energy_production = "160001kW"

generator.energy_source = {
	buffer_capacity = "160MW",
	type = "electric",
	usage_priority = "primary-output",
}

generator.max_health = 2000

log(sb(generator))

data:extend{generator}

