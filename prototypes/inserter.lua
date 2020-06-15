-- Kizrak


local sb = serpent.block -- luacheck: ignore 211


-- replace __base__ path with __vonNeumann__
local function pathReplace(base)
	return string.gsub(base,"__base__","__vonNeumann__")
end


local function isTable(t)
	return type(t) == 'table'
end

local function isString(t)
	return type(t) == 'string'
end

local function ends_with(str, ending)
	return ending == "" or str:sub(-#ending) == ending
end

local function pathReplaceRecursively(object)
	for k,v in pairs(object) do

		if isTable(v) then
			pathReplaceRecursively(v)

		elseif isString(v) and ends_with(v,".png") and not string.find(v, "shadow") then
			log(v)
			object[k] = pathReplace(v)

		end

	end
end


data.raw.inserter["burner-inserter"].allow_burner_leech = true


local new_item = table.deepcopy( data.raw.item["inserter"] )
new_item.name = "vn-inserter"
new_item.place_result = "vn-inserter"
new_item.order = "Z[inserter]"

new_item.icon = pathReplace(new_item.icon)

data:extend{ new_item }
log(sb( new_item ))


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
log(sb( inserter ))

