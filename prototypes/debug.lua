-- Kizrak


local sb = serpent.block



local function compactLog(preamble,list,max_size)
	-- full|total size of input list
	local size = #list
	log(size)

	-- return result
	local r = preamble

	-- max number of rows (lines) for displaying list
	local max_rows = math.ceil(size/max_size)
	log(max_rows)

	-- math desired number of items per line|row (should always be <= max_size)
	local columns = math.ceil(size/max_rows)
	log(columns)

	-- number of rows that contain columns-1 number of items
	local shortRows = math.ceil(size/columns)*columns-size
	log(shortRows)


	local s = 0
	--log(string.rep("=",80))
	for var=1,max_rows-shortRows do
		local sublist = {table.unpack(list, s+1,s+columns)}
		s = columns + s
		--log(var.."\t"..s)
		--log(sb(sublist))
		r = r .. "\n   " .. table.concat(sublist,", ")
	end
	for var=1+max_rows-shortRows,max_rows do
		local sublist = {table.unpack(list, s+1,s+columns-1)}
		s = columns + s - 1
		--log(var.."\t"..s)
		--log(sb(sublist))
		r = r .. "\n   " .. table.concat(sublist,", ")
	end
	--log(string.rep("-",80))

	return r
end



local a = "abcdefghijklmnopqrstuvwxyz"
s={}
a:gsub(".",function(c) table.insert(s,""..c) end)
--log(sb(s))
log(compactLog("s",s,5))



local dataRawTypeList = {}
for k, v in pairs(data.raw) do
	table.insert(dataRawTypeList,k)
end
log("types in `data.raw`\n"..table.concat(dataRawTypeList, ", "))
log(compactLog("types in `data.raw`",dataRawTypeList,7))



local rawType = "assembling-machine"
local rawTypeList = {}
for k, v in pairs(data.raw[rawType]) do
	table.insert(rawTypeList,k)
end
log("keys in `data.raw."..rawType.."`\n"..table.concat(rawTypeList, ", "))
log(compactLog("keys in `data.raw."..rawType.."`",rawTypeList,7))



local recipeCategoryMap = {}
for k, v in pairs(data.raw.recipe) do
	local category = v.category
	if category then
		if not recipeCategoryMap[category] then
			recipeCategoryMap[category] = {}
		end
		table.insert(recipeCategoryMap[category],k)
	end
end
--log(sb( recipeCategoryMap ))

