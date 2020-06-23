-- Kizrak


local sb = serpent.block -- luacheck: ignore 211


local function isTable(t)
	return type(t) == 'table'
end


local gui_style = table.deepcopy( data.raw['gui-style'] )

log(string.rep("+",80))

local extras = {}

for k,v in pairs(gui_style.default) do
	if isTable(v) then
		log(k .. '   [' .. v.type .. ']')
		for k2,v2 in pairs(v) do
			if not (k2=="type") then
				log("   " .. k2)
			end
		end
	else
		extras[k] = v
	end
end

log(string.rep("=",80))

log(sb( extras ))

