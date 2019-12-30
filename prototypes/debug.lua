-- Kizrak


local sb = serpent.block


local dataRawTypeList = {}
for k, v in pairs(data.raw) do
	table.insert(dataRawTypeList,k)
end

log("types in `data.raw`")
log( table.concat(dataRawTypeList, ", ") )


local rawType = "assembling-machine"

log("keys in `data.raw."..rawType.."`")
for k, v in pairs(data.raw[rawType]) do
	log("   "..k)
end

log(sb( data.raw['assembling-machine']['assembling-machine-1'] ))

