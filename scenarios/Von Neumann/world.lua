-- Kizrak


local script,kprint,reverseEventLookup,profile_method,profile_eventHandler = require('k-lib')() -- luacheck: ignore 211


local vn_world = {}


function vn_world.clearStartingArea(surface,boundingBox)
	local existing_entities = surface.find_entities(boundingBox)
	for i, entity in pairs(existing_entities) do
		entity.order_deconstruction("player")
		if entity.type=="resource" then
			entity.destroy()
		end
	end
end


function vn_world.clearStartingAreaPosition(surface,position,size)
	local a = position[1]
	local b = position[2]
	vn_world.clearStartingArea(surface,{{a-size,b-size},{a+size,b+size}})
end


function vn_world.on_tick(_)
	if global.clearSpawnResources and game.tick>1 then
		local roboRadius = 25
		local clearSize = 3.0
		local surface = game.surfaces["nauvis"]
		vn_world.clearStartingAreaPosition(surface,{-1*roboRadius,-1*roboRadius},clearSize)
		vn_world.clearStartingAreaPosition(surface,{roboRadius   ,-1*roboRadius},clearSize)
		vn_world.clearStartingAreaPosition(surface,{-1*roboRadius,roboRadius   },clearSize)
		vn_world.clearStartingAreaPosition(surface,{roboRadius   ,roboRadius   },clearSize)
		vn_world.clearStartingAreaPosition(surface,{0,0},9)

		global.clearSpawnResources = false
	end
end

--script.on_event({defines.events.on_tick},profile_eventHandler("vn_world.on_tick",vn_world.on_tick))
script.on_event({defines.events.on_tick},vn_world.on_tick)


function vn_world.forResourceOnNewChunk(surface,resource)
	local products = game.entity_prototypes[resource.name].mineable_properties.products

	for _,product in pairs(products) do
		if product.type=="item" then
			surface.spill_item_stack(resource.position,{name=product.name, count=1},false,nil,false)
		end
	end
end

function vn_world.on_chunk_generated(event)
	local area = event.area
	local surface = event.surface

	local arrayOfLuaEntity = surface.find_entities_filtered{area=area,type = "resource"}
	local size = table_size(arrayOfLuaEntity)
	if size>0 then
		for _,entity in pairs(arrayOfLuaEntity) do
			vn_world.forResourceOnNewChunk(surface,entity)
		end
	end
end

script.on_event({
	defines.events.on_chunk_generated,
},vn_world.on_chunk_generated)


script.register_object(vn_world)

return vn_world

