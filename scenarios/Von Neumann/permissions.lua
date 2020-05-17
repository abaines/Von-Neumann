-- Kizrak


local script,kprint,reverseEventLookup = require('k-lib')()


local sb = serpent.block -- luacheck: ignore 211

local function sbs(obj)
	local s = sb( obj ):gsub("%s+", " ")
	return s
end


local permissions = {}



log("new code goes here")



script.register_object(permissions)


return permissions

