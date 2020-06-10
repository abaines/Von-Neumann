-- Kizrak


local script,kprint = require('k-lib')() -- luacheck: ignore 211

local sb = serpent.block -- luacheck: ignore 211


local cage = {}


local function validPosition(player)
	local x = math.floor(player.position.x / 32)
	local y = math.floor(player.position.y / 32)

	local force = player.force
	local surface = player.surface

	for xx=-2,2 do
		for yy=-2,2 do
			local pos = {x+xx,y+yy}
			if not force.is_chunk_charted(surface,pos) then
				return false
			end
		end
	end

	return true
end


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

