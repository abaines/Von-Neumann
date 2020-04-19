-- Kizrak

if false then
	log("keys in data.raw[mining-drill]") -- luacheck: ignore
	for k, _ in pairs( data.raw["mining-drill"] ) do
		log("   " .. k)
	end
end


--log(serpent.block( data.raw["mining-drill"]["burner-mining-drill"] ))


local mining_drill_item = table.deepcopy( data.raw.item["electric-mining-drill"] )
mining_drill_item.name = "vn-electric-mining-drill"
mining_drill_item.place_result = "vn-electric-mining-drill"
mining_drill_item.order = "a[items]-Z[burner-mining-drill]"

data:extend{ mining_drill_item }
--log(serpent.block( mining_drill_item ))



local mining_drill = table.deepcopy( data.raw["mining-drill"]["electric-mining-drill"] )
mining_drill.name = "vn-electric-mining-drill"
mining_drill.minable.result = "vn-electric-mining-drill"

mining_drill.circuit_connector_sprites = nil
mining_drill.circuit_wire_connection_points = nil
mining_drill.circuit_wire_max_distance = nil

mining_drill.input_fluid_patch_window_sprites = nil
mining_drill.input_fluid_patch_window_flow_sprites = nil
mining_drill.input_fluid_patch_window_base_sprites = nil
mining_drill.input_fluid_patch_sprites = nil
mining_drill.input_fluid_patch_shadow_sprites = nil
mining_drill.input_fluid_patch_shadow_animations = nil
mining_drill.input_fluid_box = nil

mining_drill.pipe_picture = nil
mining_drill.pipe_covers = nil


mining_drill.resource_searching_radius = 1.49
mining_drill.energy_source = {
	emissions_per_minute = 10*3,
	type = "electric",
	usage_priority = "secondary-input"
}
mining_drill.energy_usage = "180kW"
mining_drill.mining_speed = 0.5 / 2
mining_drill.module_specification = nil


data:extend{ mining_drill }
--log(serpent.block( mining_drill ))

