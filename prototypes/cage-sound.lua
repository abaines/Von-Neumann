-- Kizrak


local sb = serpent.block -- luacheck: ignore 211


local cage_sound = {}

cage_sound.name = "cage-sound"
cage_sound.type = "sound"
cage_sound.filename = "__vonNeumann__/sound/max-communication-range.ogg"
cage_sound.category = "game-effect"


data:extend{cage_sound}
log(sb( cage_sound ))

