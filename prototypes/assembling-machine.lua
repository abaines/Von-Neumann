-- Kizrak


local sb = serpent.block

local assembling_machine = table.deepcopy( data.raw["assembling-machine"]["assembling-machine-1"] )
assembling_machine.name = "damaged-assembling-machine"
assembling_machine.order = "a[assembling-machine-1]"
assembling_machine.subgroup = "production-machine"


data:extend{assembling_machine}
log(sb( assembling_machine ))

