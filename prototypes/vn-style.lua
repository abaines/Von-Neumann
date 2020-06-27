-- Kizrak


local sb = serpent.block -- luacheck: ignore 211


local function isTable(t) -- luacheck: ignore 211
	return type(t) == 'table'
end


local gui_style_default = data.raw['gui-style'].default


local vn_frame = table.deepcopy(gui_style_default.frame)

vn_frame.graphical_set.base.opacity = 0.15
vn_frame.graphical_set.base.background_blur = false
vn_frame.header_filler_style.parent = "vn-draggable_space_header"

gui_style_default['vn-frame'] = vn_frame


local vn_header = table.deepcopy(gui_style_default["draggable_space_header"] )

vn_header.parent = "vn-draggable_space"

gui_style_default['vn-draggable_space_header'] = vn_header


local vn_space = table.deepcopy(gui_style_default["draggable_space"] )

vn_space.graphical_set.base.opacity = 0.15

gui_style_default['vn-draggable_space'] = vn_space


--[[
log(string.rep("+",80))

local extras = {}
local keys = {}

for k,v in pairs(gui_style_default) do
	if isTable(v) then
		local vtype = v.type
		if string.find(vtype,"frame") then
			log(k .. '   [' .. vtype .. ']')
			for k2,_ in pairs(v) do
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


log(sb( gui_style_default["vn-frame"] ))
log(sb( gui_style_default["vn-draggable_space_header"] ))
log(sb( gui_style_default["vn-draggable_space"] ))
]]--

