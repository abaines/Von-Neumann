-- Kizrak


local sb = serpent.block -- luacheck: ignore 211

-- replace __base__ path with __vonNeumann__
local function pathReplace(base) -- luacheck: ignore 211
	return string.gsub(base,"__base__","__vonNeumann__")
end

local generator = table.deepcopy( data.raw['electric-energy-interface']['crash-site-generator'] )

generator.name = "vn-crash-site-generator"
generator.gui_mode = "none"

local kWproduction = 3*900

generator.energy_production = ""..(kWproduction+1).."kW"

generator.energy_source = {
	buffer_capacity = ""..(kWproduction).."kW",
	type = "electric",
	usage_priority = "primary-output",
	render_no_power_icon = false,
}

generator.max_health = 2000

log(sb(generator))

data:extend{generator}

