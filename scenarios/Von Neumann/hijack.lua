-- Kizrak

-- special thanks to Kovus, Thuro, & Diablo-D3 for making this happen

-- script.on_event -- script.on_event -- script.on_event -- script.on_event

local old_script_on_event = script.on_event

local table_event = {}

local on_event_history = {}

local function doAllEvents(event)
	local name = event.name

	for index,value in ipairs(table_event[name]) do
		value(event)
	end
end

script.on_event = function(event_ids, _function)
	local event_ids = (type(event_ids) == "table" and event_ids) or {event_ids}

	for _, event_id in pairs(event_ids) do
		if not table_event[event_id] then
			table_event[event_id] = {}
		end

		table.insert(on_event_history,event_id)
		table.insert(table_event[event_id],_function)

		old_script_on_event(event_id,doAllEvents);
	end
end


-- script.on_init -- script.on_init -- script.on_init -- script.on_init

local old_script_on_init = script.on_init

local table_init = {}

local function doAllInits(event)
	for index,value in ipairs(table_init) do
		value(event)
	end
end

script.on_init(doAllInits)

script.on_init = function(_function)
	table.insert(table_init,_function)
end



-- history command -- history command -- history command -- history command

local function print_on_event_history(event)
	local player = game.players[event.player_index]

	player.print("on_event_history #"..#on_event_history)
	player.print(serpent.block(on_event_history))

	local printHelper = {}
	local count = 0
	for key,value in pairs(table_event) do
		printHelper[key] = #value
		count = #value + count
	end

	player.print("table_event #"..#table_event..'  '..count)
	player.print(serpent.block(table_event))
	player.print(serpent.block(printHelper))

	log(serpent.block(printHelper))
	log(serpent.block(table_event))

	player.print("table_init #"..#table_init)
end

commands.add_command("history", "history", print_on_event_history)
