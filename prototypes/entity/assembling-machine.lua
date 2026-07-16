-- Kizrak


local sb = serpent.block -- luacheck: ignore 211

-- replace __base__ path with __vonNeumann__
local function pathReplace(base)
	return string.gsub(base,"__base__","__vonNeumann__")
end


local item = table.deepcopy( data.raw.item["assembling-machine-1"] )
item.name = "damaged-assembling-machine"
item.place_result = "damaged-assembling-machine"
item.order = "a[assembling-machine--0]"
item.icon = pathReplace(item.icon)
data:extend{item}



local assembling_machine = table.deepcopy( data.raw["assembling-machine"]["assembling-machine-1"] )
assembling_machine.name = "damaged-assembling-machine"
assembling_machine.order = "a[assembling-machine--0]"
assembling_machine.subgroup = "production-machine"
assembling_machine.minable.result = "damaged-assembling-machine"
assembling_machine.next_upgrade = nil

assembling_machine.crafting_speed = 0.25
assembling_machine.energy_source.emissions_per_minute = { pollution = 5 }
assembling_machine.energy_usage = "150kW"
assembling_machine.max_health = 250
assembling_machine.ingredient_count = 3

assembling_machine.crafting_categories = {
	"basic-crafting",
	"crafting",
}

-- graphics
-- In Factorio 2.1, just use the base graphics as-is
-- No additional scaling needed for this prototype

assembling_machine.collision_box = {{-1.7,-1.7},{1.7,1.7}}
assembling_machine.selection_box = {{-2,-2},{2,2}}

assembling_machine.icon = pathReplace(assembling_machine.icon)

data:extend{assembling_machine}


local debugObj = table.deepcopy( assembling_machine )
debugObj.animated_drawing = nil
debugObj.working_sound = nil
debugObj.vehicle_impact_sound = nil
debugObj.close_sound = nil
debugObj.open_sound = nil
--log(sb( debugObj ))



local recipe = table.deepcopy(data.raw.recipe["assembling-machine-1"])
recipe.name = "damaged-assembling-machine"
recipe.results = {{type = "item", name = "damaged-assembling-machine", amount = 1}}
recipe.order = "a[assembling-machine--0]"
recipe.enabled = true

recipe.ingredients = {
	{type = "item", name = "iron-plate", amount = 9},
	{type = "item", name = "iron-gear-wheel", amount = 5},
	{type = "item", name = "copper-cable", amount = 8},
}
recipe.energy_required = 5.5

data:extend{recipe}

