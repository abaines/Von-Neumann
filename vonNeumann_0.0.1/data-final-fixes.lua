-- Kizrak

data.raw.character.character.inventory_size = 1
local godController = data.raw["god-controller"]

print(serpent.block(godController))
log(serpent.block(godController))

godController.default.inventory_size = 1

print("data-final-fixes.lua")
log("data-final-fixes.lua")
