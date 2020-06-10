-- Kizrak


local script,kprint = require('k-lib')() -- luacheck: ignore 211

local sb = serpent.block -- luacheck: ignore 211


local cage = {}


local function on_player_changed_position(event)
	local player = game.players[event.player_index]
	log(sb( event ))
	log(sb( player.name ))
end

script.on_event({
	defines.events.on_player_changed_position,
},on_player_changed_position)


script.register_object(cage)

return cage

