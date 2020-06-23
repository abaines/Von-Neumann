-- Kizrak


local sb = serpent.block -- luacheck: ignore 211


local function isTable(t)
	return type(t) == 'table'
end


local gui_style_default = data.raw['gui-style'].default


local vn_frame = table.deepcopy(gui_style_default.blurry_frame)

vn_frame.graphical_set.base.opacity = 0.15

log(sb( vn_frame ))

gui_style_default['vn-frame'] = vn_frame

log(string.rep("+",80))

local extras = {}

for k,v in pairs(gui_style_default) do
	if isTable(v) then
		local vtype = v.type
		if string.find(vtype,"frame") then
			log(k .. '   [' .. vtype .. ']')
			for k2,v2 in pairs(v) do
				if not (k2=='type') then
					log("   " .. k2)
				end
			end
		end
	else
		extras[k] = v
	end
end

log(string.rep("=",80))

log(sb( extras ))

