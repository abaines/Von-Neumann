-- Kizrak


---------------------------------------------------------------------------------------------------
-- Grey Belt --- Grey Belt --- Grey Belt --- Grey Belt --- Grey Belt --- Grey Belt --- Grey Belt --
---------------------------------------------------------------------------------------------------

-- replace __base__ path with __vonNeumann__
local function pathReplace(base)
	return string.gsub(base,"__base__","__vonNeumann__")
end


local grey_belt_item = table.deepcopy(data.raw.item["transport-belt"])
grey_belt_item.name = "vn-transport-belt"
grey_belt_item.place_result = "vn-transport-belt"
grey_belt_item.icon = pathReplace(grey_belt_item.icon)

log( "grey_belt_item" )
log(serpent.block( grey_belt_item ))



local grey_belt_entity = table.deepcopy(data.raw["transport-belt"]["transport-belt"])
grey_belt_entity.name = "vn-transport-belt"
grey_belt_entity.speed = 7.5 / 480 -- 7.5 items per second
grey_belt_entity.minable.result = "vn-transport-belt"
grey_belt_entity.next_upgrade = "transport-belt"
grey_belt_entity.max_health = 100

grey_belt_entity.circuit_connector_sprites = nil
grey_belt_entity.circuit_wire_connection_points = nil
grey_belt_entity.circuit_wire_max_distance = nil

grey_belt_entity.icon = pathReplace(grey_belt_entity.icon)
local animation_set = grey_belt_entity.belt_animation_set.animation_set
animation_set.filename = pathReplace(animation_set.filename)
animation_set.hr_version.filename = pathReplace(animation_set.hr_version.filename)

-- TODO: corpse

log ( "grey_belt_entity" )
log(serpent.block( grey_belt_entity ))



data:extend{grey_belt_item}
data:extend{grey_belt_entity}

