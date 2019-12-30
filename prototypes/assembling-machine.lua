-- Kizrak


local sb = serpent.block

-- replace __base__ path with __vonNeumann__
local function pathReplace(base)
	return string.gsub(base,"__base__","__vonNeumann__")
end


local item = table.deepcopy( data.raw.item["assembling-machine-1"] )
item.name = "damaged-assembling-machine"
item.place_result = "damaged-assembling-machine"
data:extend{item}



local assembling_machine = table.deepcopy( data.raw["assembling-machine"]["assembling-machine-1"] )
assembling_machine.name = "damaged-assembling-machine"
assembling_machine.order = "a[assembling-machine-1]"
assembling_machine.subgroup = "production-machine"
assembling_machine.minable.result = "damaged-assembling-machine"
assembling_machine.next_upgrade = "assembling-machine-1"

-- graphics
local layer1 = assembling_machine.animation.layers[1]
layer1.filename = pathReplace(layer1.filename)
layer1.hr_version.filename = pathReplace(layer1.hr_version.filename)


data:extend{assembling_machine}
log(sb( assembling_machine ))

