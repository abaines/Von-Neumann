-- Kizrak


local sb = serpent.block


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


data:extend{assembling_machine}
log(sb( assembling_machine ))

