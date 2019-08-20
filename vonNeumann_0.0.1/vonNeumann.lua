-- Kizrak

--- needs "hijack"

function kprint(msg)
	print(msg)
	log(msg)
	if not game.is_multiplayer() then
		game.print(msg,{r=255,g=255})
	end
end


function newPlayer(event)
	kprint("newPlayer: "..serpent.block(event.player_index),{r=255,g=255})

	for i, player in pairs(game.players) do
		local playerCharacter = player.character
		player.character = nil
	end

	for i, entity in pairs(game.surfaces[1].find_entities_filtered{}) do -- iterate through entities
		if entity.type == "character" then -- it's an inserter, do something to it
			--kprint("T::"..entity.type)
			--kprint("E::"..serpent.block(entity))
			entity.destroy()
		end
	end

	--[[playerCharacter.destroy()
	local characters = game.surfaces[1].find_entities_filtered{type= "character"}
	kprint("CS::" .. serpent.block(characters))
	for character in pairs(characters) do
		kprint("C::" .. serpent.block(character))
		character.destory()
	end]]--

	local numberPlayers = #game.players
	local msg = "newPlayer complete: " .. numberPlayers
	kprint(msg)
end



script.on_event({
defines.events.on_player_joined_game,
defines.events.on_player_created,
defines.events.on_player_left_game,
defines.events.on_player_changed_force,
defines.events.on_player_removed,
defines.events.on_pre_player_left_game,
},newPlayer)

