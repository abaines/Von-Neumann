-- Kizrak

--data.raw.character.inventory_size = 1
data.raw["character"]["character"].inventory_size = 2
data.raw.character.character.inventory_size = 1
local gc = data.raw["god-controller"]

print(serpent.block(gc))
log(serpent.block(gc))

gc.default.inventory_size = 1

--local gc2 = gc["god-controller"]
--gc2.inventory_size = 1

print("data-final-fixes.lua")
log("data-final-fixes.lua")
