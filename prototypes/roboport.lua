-- Kizrak

-- log(serpent.block( data.raw ))

if false then
	log("keys in data.raw")
	for k, v in pairs(data.raw) do
		log(k)
	end

	log("keys in data.raw.roboport")
	for k, v in pairs(data.raw["roboport"]) do
		log(k)
	end
end


local roboport = table.deepcopy( data.raw["roboport"]["roboport"] )
roboport.name = "vn-roboport"
roboport.order = "c[signal]-a[roboport]"

data:extend{roboport}
log(serpent.block( roboport ))

