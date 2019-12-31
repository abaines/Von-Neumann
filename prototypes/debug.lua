-- Kizrak


local sb = serpent.block



local function compactLog(preamble,list,max_size)
	-- full|total size of input list
	local size = #list

	-- return result
	local r = preamble

	-- max number of rows (lines) for displaying list
	local max_rows = math.ceil(size/max_size)

	-- math desired number of items per line|row (should always be <= max_size)
	local columns = math.ceil(size/max_rows)

	-- number of rows that contain columns-1 number of items
	local shortRows = math.ceil(size/columns)*columns-size


	--log(string.rep("=",80))
	local i = 1
	for row=1,max_rows-shortRows do
		local sublist = {table.unpack(list, i, i+columns-1)}
		i = columns + i
		r = r .. "\n   " .. table.concat(sublist,", ")..","
	end
	for row=1+max_rows-shortRows,max_rows do
		local sublist = {table.unpack(list, i, i+columns-1-1)}
		i = columns + i - 1
		r = r .. "\n   " .. table.concat(sublist,", ")..","
	end
	--log(string.rep("-",80))

	return r
end



local a = "abcdefghijklmnopqrstuvwxyz"
s={}
a:gsub(".",function(c) table.insert(s,""..c) end)
log(compactLog("s:",s,2))
log(compactLog("s:",s,3))
log(compactLog("s:",s,4))
log(compactLog("s:",s,5))
log(compactLog("s:",s,6))
log(compactLog("s:",s,7))
log(compactLog("s:",s,8))
log(compactLog("s:",s,9))
log(compactLog("s:",s,10))
log(compactLog("s:",s,11))
log(compactLog("s:",s,12))
log(compactLog("s:",s,14))
log(compactLog("s:",s,15))



local dataRawTypeList = {}
for k, v in pairs(data.raw) do
	table.insert(dataRawTypeList,k)
end
log(compactLog("types in `data.raw`:",dataRawTypeList,6))



local rawType = "assembling-machine"
local rawTypeList = {}
for k, v in pairs(data.raw[rawType]) do
	table.insert(rawTypeList,k)
end
log(compactLog("keys in `data.raw."..rawType.."`:",rawTypeList,6))



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

