-- Kizrak


local function kprint(msg)
	print(msg)
	log(msg)
	if game and not game.is_multiplayer() then
		game.print(msg,{r=255,g=255})
	end
end


local eventNameMapping = {}
for eventName,eventId in pairs(defines.events) do
	eventNameMapping[eventId] = eventName
end


local function reverseEventLookup(eventId)
	return eventNameMapping[eventId]
end


local function createScript()
	local script = {}


	local k_lib_events = {}

	script.on_event = function(events,action)
		for _,eventID in pairs(events) do
			k_lib_events[eventID] = action
		end
	end


	local k_lib_nth_tick = {}

	script.on_nth_tick = function(n,action)
		k_lib_nth_tick[n] = action
	end


	local k_lib_on_init = nil

	script.on_init = function(action)
		k_lib_on_init = action
	end


	script.register_object = function(object)
		object.events = k_lib_events
		object.on_init = k_lib_on_init
		object.on_nth_tick = k_lib_nth_tick

		return object
	end

	return script
end


return function()
	return createScript(), kprint, reverseEventLookup
end

