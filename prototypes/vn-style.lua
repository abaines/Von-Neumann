-- Kizrak


local sb = serpent.block -- luacheck: ignore 211


local function isTable(t)
	return type(t) == 'table'
end


local gui_style_default = data.raw['gui-style'].default


local vn_frame = table.deepcopy(gui_style_default.frame)

vn_frame.graphical_set.base.opacity = 0.15
vn_frame.graphical_set.base.background_blur = false

gui_style_default['vn-frame'] = vn_frame

log(string.rep("+",80))

local extras = {}
local keys = {}

for k,v in pairs(gui_style_default) do
	if isTable(v) then
		local vtype = v.type
		if string.find(vtype,"frame") then
			log(k .. '   [' .. vtype .. ']')
			for k2,v2 in pairs(v) do
				if not (k2=='type') and false then
					log("   " .. k2)
				end
				keys[k2] = true
			end
		end
	else
		extras[k] = v
	end
end

log(sb( extras ))

local key_array = {}
for k,_ in pairs(keys) do
	table.insert(key_array,k)
end
log(sb( key_array ))

log(string.rep("=",80))

log(sb( vn_frame ))

