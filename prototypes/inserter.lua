-- Kizrak

if false then
	log("keys in data.raw[inserter]")
	for k, v in pairs( data.raw["inserter"] ) do
		log("   " .. k)
	end
end


data.raw.inserter["burner-inserter"].allow_burner_leech = true


local new_item = table.deepcopy( data.raw.item["inserter"] )
new_item.name = "vn-inserter"
new_item.place_result = "vn-inserter"

data:extend{ new_item }


local inserter = table.deepcopy( data.raw["inserter"]["inserter"] )
inserter.name = "vn-inserter"
inserter.minable.result = "vn-inserter"
inserter.next_upgrade = "inserter"

inserter.circuit_connector_sprites = nil
inserter.circuit_wire_connection_points = nil
inserter.circuit_wire_max_distance = nil

inserter.energy_per_movement = "70kJ"
inserter.energy_per_rotation = "70kJ"
inserter.energy_source = {
	drain = "1.8kW",
	type = "electric",
	usage_priority = "secondary-input"
}
inserter.extension_speed = 0.03/2
inserter.rotation_speed = 0.014/2

inserter.max_health = 100

data:extend{ inserter }
--log(serpent.block( inserter ))

