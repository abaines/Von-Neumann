-- Kizrak

-- log(serpent.block( data.raw ))

if false then
	log("keys in data.raw")
	for k, v in pairs(data.raw) do
		log(k)
	end

	log("keys in data.raw.electric-pole")
	for k, v in pairs(data.raw["electric-pole"]) do
		log(k)
	end
end


local substation = table.deepcopy( data.raw["electric-pole"]["substation"] )
substation.name = "vn-substation"
substation.order = "a[energy]-d[substation]"
substation.supply_area_distance = 16
substation.maximum_wire_distance = 64

data:extend{substation}
--log(serpent.block( substation ))

