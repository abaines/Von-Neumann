-- Kizrak


local sb = serpent.block -- luacheck: ignore 211


local item = data.raw["item"]

local chest = item["logistic-chest-storage"]


log(sb( chest ))

chest.flags = chest.flags or {}

log(sb( chest ))

local flags = chest.flags

log(sb( flags ))

--table.insert(flags,"always_show")
table.insert(flags,"hide-from-bonus-gui")
table.insert(flags,"hidden")

--flags["always-show"] = true

log(sb( chest ))



log(sb( data.raw["item"]["logistic-chest-storage"].flags ))

