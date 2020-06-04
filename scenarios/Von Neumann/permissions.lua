-- Kizrak


local script,kprint,reverseEventLookup = require('k-lib')()


local sb = serpent.block -- luacheck: ignore 211

local function sbs(obj)
	local s = sb( obj ):gsub("%s+", " ")
	return s
end


local permissions = {}



-- https://lua-api.factorio.com/latest/defines.html#defines.input_action
-- https://lua-api.factorio.com/latest/LuaPermissionGroup.html#LuaPermissionGroup.set_allows_action
-- https://factorioconsolecommands.com/factorio-console-commands/toggle-action-logging-g2893r8


log("new code goes here")


--  748.025 Info GameActionHandler.cpp:301: Action performed [108075 0 ChangePickingState]
--  863.674 Info GameActionHandler.cpp:301: Action performed [115014 0 ResetAssemblingMachine]
--  914.141 Info GameActionHandler.cpp:301: Action performed [118042 0 CursorTransfer]
--  932.592 Info GameActionHandler.cpp:301: Action performed [119149 0 InventoryTransfer]
-- 1107.146 Info GameActionHandler.cpp:301: Action performed [129622 0 BeginMining]
-- 1136.481 Info GameActionHandler.cpp:301: Action performed [131382 0 FastEntityTransfer]
-- 1523.457 Info GameActionHandler.cpp:301: Action performed [154588 0 PasteEntitySettings]

local function resetPermissions()
	log("resetPermissions()")
end

local function on_gui_closed(event)
	local gui_type = event.gui_type
	local name = event.name
	local player_index = event.player_index
	local tick = event.tick

	if gui_type == defines.gui_type.permissions then
		resetPermissions()
	end
end

script.on_event({
	defines.events.on_gui_closed,
},on_gui_closed)




script.register_object(permissions)


return permissions

