-- Kizrak


local script,kprint,reverseEventLookup = require('k-lib')()


local sb = serpent.block -- luacheck: ignore 211

local function sbs(obj)
	local s = sb( obj ):gsub("%s+", " ")
	return s
end


local permissions = {}


-- /toggle-action-logging

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


local input_actionNameMapping = {}
for input_actionName,input_actionId in pairs(defines.input_action) do
	input_actionNameMapping[input_actionId] = input_actionName
end


local permissionsToKeepDisabled = {}
permissionsToKeepDisabled[defines.input_action.begin_mining] = true -- 2
permissionsToKeepDisabled[defines.input_action.change_picking_state] = true -- 180
permissionsToKeepDisabled[defines.input_action.cursor_transfer] = true -- 62
permissionsToKeepDisabled[defines.input_action.fast_entity_transfer] = true -- 192
permissionsToKeepDisabled[defines.input_action.inventory_transfer] = true -- 65
permissionsToKeepDisabled[defines.input_action.paste_entity_settings] = true -- 21
permissionsToKeepDisabled[defines.input_action.reset_assembling_machine] = true -- 12
permissionsToKeepDisabled[defines.input_action.stack_transfer] = true
permissionsToKeepDisabled[defines.input_action.stack_split] = true
permissionsToKeepDisabled[defines.input_action.cursor_split] = true
permissionsToKeepDisabled[defines.input_action.inventory_split] = true
permissionsToKeepDisabled[defines.input_action.craft] = true


local function fixPermission(permissionGroup, input_action)
	local allows_action = permissionGroup.allows_action(input_action)

	if allows_action then
		local reverseInput_actionLookup = input_actionNameMapping[input_action]
		log(permissionGroup.group_id .. "  " .. permissionGroup.name .. "  " .. input_action .. "  " .. reverseInput_actionLookup  .. " (" .. input_action .. ")")
		permissionGroup.set_allows_action(input_action,false)
	end
end

local function resetPermissions()
	log("resetPermissions()")
	local groups = game.permissions.groups
	for _,permissionGroup in pairs(groups) do
		for input_action in pairs(permissionsToKeepDisabled) do
			fixPermission(permissionGroup,input_action)
		end
	end
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


local function on_player_joined_game(event)
	resetPermissions()
end

script.on_event({
	defines.events.on_player_joined_game,
},on_player_joined_game)




script.register_object(permissions)


return permissions

