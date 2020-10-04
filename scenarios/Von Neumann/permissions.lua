-- Kizrak


local script,kprint,reverseEventLookup = require('k-lib')() -- luacheck: ignore 211


local sb = serpent.block -- luacheck: ignore 211

local function sbs(obj)  -- luacheck: ignore 211
	local s = sb( obj ):gsub("%s+", " ")
	return s
end


local permissions = {}

-- /toggle-action-logging
-- https://lua-api.factorio.com/latest/defines.html#defines.input_action
-- https://lua-api.factorio.com/latest/LuaPermissionGroup.html#LuaPermissionGroup.set_allows_action
-- https://factorioconsolecommands.com/factorio-console-commands/toggle-action-logging-g2893r8


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

local function resetPermissions(reason)
	log("resetPermissions("..reason..")")
	local groups = game.permissions.groups
	for _,permissionGroup in pairs(groups) do
		for input_action in pairs(permissionsToKeepDisabled) do
			fixPermission(permissionGroup,input_action)
		end
	end
end


script.on_event({
	defines.events.on_permission_group_edited,
},function() resetPermissions("on_permission_group_edited") end)

script.on_event({
	defines.events.on_permission_group_added,
},function() resetPermissions("on_permission_group_added") end)

script.on_event({
	defines.events.on_permission_string_imported,
},function() resetPermissions("on_permission_string_imported") end)

script.on_event({
	defines.events.on_player_joined_game,
},function() resetPermissions("on_player_joined_game") end)



script.register_object(permissions)


return permissions

