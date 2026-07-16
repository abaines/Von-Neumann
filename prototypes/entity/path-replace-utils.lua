-- Kizrak


local function replace_base_path(base)
	return string.gsub(base, "__base__", "__vonNeumann__")
end

local function ends_with(str, ending)
	return ending == "" or str:sub(-#ending) == ending
end

local function isTable(t)
	return type(t) == "table"
end

local function isString(t)
	return type(t) == "string"
end

local function replace_png_paths_recursively(object)
	for k, v in pairs(object) do
		if isTable(v) then
			replace_png_paths_recursively(v)
		elseif isString(v) and ends_with(v, ".png") and not string.find(v, "shadow", 1, true) and not string.find(v, "reflection", 1, true) and not string.find(v, "circuit-connector", 1, true) then
			object[k] = replace_base_path(v)
		end
	end

	return object
end

return {
	replace_base_path = replace_base_path,
	replace_png_paths_recursively = replace_png_paths_recursively,
}