-- Kizrak


local sb = serpent.block -- luacheck: ignore 511

-- replace __base__ path with __vonNeumann__
local function pathReplace(base)
	return string.gsub(base,"__base__","__vonNeumann__")
end


local item = table.deepcopy( data.raw.item["assembling-machine-1"] )
item.name = "damaged-assembling-machine"
item.place_result = "damaged-assembling-machine"
item.order = "a[assembling-machine--0]"
item.icon = pathReplace(item.icon)
item.icon_size = 32
data:extend{item}



local assembling_machine = table.deepcopy( data.raw["assembling-machine"]["assembling-machine-1"] )
assembling_machine.name = "damaged-assembling-machine"
assembling_machine.order = "a[assembling-machine--0]"
assembling_machine.subgroup = "production-machine"
assembling_machine.minable.result = "damaged-assembling-machine"
assembling_machine.next_upgrade = nil

assembling_machine.crafting_speed = 0.25
assembling_machine.energy_source.emissions_per_minute = 5
assembling_machine.energy_usage = "150kW"
assembling_machine.max_health = 250
assembling_machine.ingredient_count = 3

assembling_machine.crafting_categories = {
	"basic-crafting",
	"crafting",
}

-- graphics
local layers = assembling_machine.animation.layers
local layer1 = layers[1]
layer1.filename = pathReplace(layer1.filename)
layer1.hr_version.filename = pathReplace(layer1.hr_version.filename)

for _,layer in pairs(layers) do
	layer.scale = 4/3 * (layer.scale or 1)
	layer.hr_version.scale = 4/3 * (layer.hr_version.scale or 1)
end

assembling_machine.collision_box = {{-1.7,-1.7},{1.7,1.7}}
assembling_machine.selection_box = {{-2,-2},{2,2}}

assembling_machine.icon = pathReplace(assembling_machine.icon)
assembling_machine.icon_size = 32

data:extend{assembling_machine}


local debugObj = table.deepcopy( assembling_machine )
debugObj.animation = nil
debugObj.working_sound = nil
debugObj.vehicle_impact_sound = nil
debugObj.close_sound = nil
debugObj.open_sound = nil
--log(sb( debugObj ))



local recipe = table.deepcopy(data.raw.recipe["assembling-machine-1"])
recipe.name = "damaged-assembling-machine"
recipe.result = "damaged-assembling-machine"
recipe.order = "a[assembling-machine--0]"
recipe.enabled = true

recipe.ingredients = {
	{"iron-plate", 9},
	{"iron-gear-wheel", 5},
	{"copper-cable", 8},
}
recipe.energy_required = 5.5

data:extend{recipe}

