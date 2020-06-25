-- Kizrak


local sb = serpent.block -- luacheck: ignore 211


local item = data.raw["item"]

local chest = item["logistic-chest-storage"]

chest.flags = chest.flags or {}

log(sb( chest ))

local flags = chest.flags

log(sb( flags ))

table.insert(flags,"always_show")

log(sb( chest ))

log(sb( flags ))

