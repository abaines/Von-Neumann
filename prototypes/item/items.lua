-- Kizrak


local sb = serpent.block -- luacheck: ignore 211


local function add_always_show_flag(item_prototype_name)
	local item = data.raw.item[item_prototype_name]
		or data.raw.ammo[item_prototype_name]
		or (data.raw["item-with-entity-data"] and data.raw["item-with-entity-data"][item_prototype_name])

	if not item then
		error("vonNeumann requires base prototype: " .. item_prototype_name)
	end

	item.flags = item.flags or {}
	table.insert(item.flags, "always-show")
end


add_always_show_flag("logistic-chest-storage")
add_always_show_flag("big-electric-pole")
add_always_show_flag("roboport")
add_always_show_flag("gun-turret")
add_always_show_flag("laser-turret")
add_always_show_flag("radar")
add_always_show_flag("accumulator")
add_always_show_flag("solar-panel")
add_always_show_flag("firearm-magazine")

