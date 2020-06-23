-- Kizrak


local sb = serpent.block -- luacheck: ignore 211


local cage_sound = {}

cage_sound.name = "cage-sound"
cage_sound.type = "sound"
cage_sound.filename = "__vonNeumann__/sound/max-communication-range.ogg"
cage_sound.category = "game-effect"

cage_sound.aggregation = {
	max_count = 1, -- uint32 - Mandatory.
	progress_threshold = 1.0, -- float - Optional. - Default: 1.0 - If count already playing is true, this will determine maximum progress when instance is counted toward playing sounds.
	remove = false, -- bool - Mandatory.
	count_already_playing = false, -- bool - Optional. - Default: false - If true already playing sounds are taken into account when checking maxCount.
}

data:extend{cage_sound}
--log(sb( cage_sound ))

