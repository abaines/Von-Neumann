-- Kizrak

-- log(serpent.block( data.raw ))

if false then
	log("keys in data.raw")
	for k, v in pairs(data.raw) do
		log(k)
	end

	log("keys in data.raw.roboport")
	for k, v in pairs(data.raw["roboport"]) do
		log(k)
	end
end


local roboport = table.deepcopy( data.raw["roboport"]["roboport"] )
roboport.name = "vn-roboport"
roboport.order = "c[signal]-a[roboport]"
roboport.charging_energy = "1000kW"
roboport.construction_radius = 55
roboport.dying_explosion = "massive-explosion"
roboport.energy_usage = "0kW"
roboport.energy_source = {
	buffer_capacity = "100MJ",
	input_flow_limit = "5MW",
	type = "electric",
	usage_priority = "secondary-input"
}
roboport.material_slots_count = 30
roboport.robot_slots_count = 30
roboport.recharge_minimum = "40MJ"

data:extend{roboport}
log(serpent.block( roboport ))

