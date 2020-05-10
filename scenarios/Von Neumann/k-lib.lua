-- Kizrak


local function kprint(msg)
	print(msg)
	log(msg)
	if game and not game.is_multiplayer() then
		game.print(msg,{r=255,g=255})
	end
end


local function createScript()
	local script = {}

	script.k_lib_events = {}

	script.on_event = function(events,action)
		for _,eventID in pairs(events) do
			script.k_lib_events[eventID] = action
		end
	end

	script.on_nth_tick = function(n,action)
		log("TODO script.on_nth_tick")
	end

	script.on_init = function(action)
		log("TODO script.on_init")
	end

	return script
end


return function()
	return createScript(), kprint
end

