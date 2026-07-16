-- Kizrak


local script,kprint = require('k-lib')() -- luacheck: ignore 211


local crash_site = {}


function crash_site.createCrashSiteGenerator(position)
	local electricGenerator = crash_site.createEntity{name="vn-crash-site-generator",position=position}

	local accumulator = crash_site.createEntity{name="vn-accumulator",position=position}
	accumulator.energy = accumulator.electric_buffer_size

	return electricGenerator
end


function crash_site.createEntity(options)
	if type(options.name)~="string" then
		error("no name: "..type(options.name))
	elseif type(options.position)~="table" then
		error("no position: "..type(options.position))
	end

	local entity = game.surfaces[options.surface or "nauvis"].create_entity{
		name=options.name,
		position=options.position,
		force=options.force or "player"
	}
	if entity == nil then
		error("⨀ failed to create entity: " .. options.name)
	end

	-- entity.minable = false  -- TODO FIXME
	entity.destructible = true
	entity.rotatable = true
	entity.operable = true

	return entity
end


function crash_site.createSiteChest(options,itemsTable)
	local entity = crash_site.createEntity(options)

	for k, v in pairs (itemsTable) do
		entity.insert({name = k, count = v})
	end

	return entity
end

function crash_site.setLogisticRequestSlot(entity, slotIndex, itemName, itemCount)
	local logisticSections = entity.get_logistic_sections()
	if logisticSections == nil then
		error("⨀ entity has no logistic sections: " .. entity.name)
	end

	local section = logisticSections.get_section(1)
	if section == nil then
		section = logisticSections.add_section()
	end
	if section == nil then
		error("⨀ failed to get logistic section for entity: " .. entity.name)
	end

	section.set_slot(slotIndex, {
		value = {
			type = "item",
			name = itemName,
			quality = "normal"
		},
		min = itemCount
	})
end

function crash_site.randomTableElement(someTable)
	local keys = {}
	for key in pairs(someTable) do
		table.insert(keys,key)
	end
	return keys[ math.random( #keys ) ]
end

function crash_site.randomCircleSpill(surface,item)
	local theta = math.random() * 2 * math.pi
	local r = math.sqrt(math.random(9*9,18*18))
	local x = r * math.cos(theta)
	local y = r * math.sin(theta)

	surface.spill_item_stack({x,y},{name=item, count=1},false,nil,false)
end

function crash_site.spillItemsRandomly(surface)
	local items = {
		coal=5,
		['burner-mining-drill']=4,
		["vn-electric-mining-drill"]=7,
		['stone-furnace']=8,

		['burner-inserter']=20,
		['vn-inserter']=30,
		['vn-transport-belt']=100,

		['firearm-magazine']=39,
		['gun-turret']=3,
		['laser-turret']=2,

		['damaged-assembling-machine']=24,
		['big-electric-pole']=12,

		['electronic-circuit']=15,
		['radar']=2,

		roboport=10,
		['construction-robot']=100,
		['logistic-robot']=10,

		['vn-logistic-chest-requester']=15,

		["copper-cable"] = 10,
		["green-wire"] = 10,
		["red-wire"] = 10,

		["accumulator"] = 3,
		["solar-panel"] = 2,
	}

	local logisticsAssemblerReboot_enabled = game.active_mods["LogisticAssemblingMachine-rebooted"]
	if (logisticsAssemblerReboot_enabled) then
		items["logistic-assembling-machine"]=4
	end

	while table_size(items)>0 do
		local item = crash_site.randomTableElement(items)
		items[item] = items[item] - 1
		if items[item]<=0 then
			items[item] = nil
		end
		crash_site.randomCircleSpill(surface,item)
	end
end

function crash_site.spawnRobo(position)
	local robo = crash_site.createSiteChest({name="vn-roboport",position=position},{
		['construction-robot']=250,
		['logistic-robot']=50,
		['repair-pack']=50,
	})
	robo.energy = robo.prototype.electric_energy_source_prototype.buffer_capacity
	return robo
end


function crash_site.spawnCrashSite()
	if global.donecrashsite then
		return
	end
	global.donecrashsite=true

	--log(serpent.block( game.surfaces["nauvis"].map_gen_settings ))
	log("map_gen_settings.seed: " .. game.surfaces["nauvis"].map_gen_settings.seed)

	local electricEnergyInterface = crash_site.createCrashSiteGenerator({0,0})
	local substationDistance = 23
	crash_site.createEntity{name="vn-substation",position={-1*substationDistance,-1*substationDistance}}
	crash_site.createEntity{name="vn-substation",position={ 1*substationDistance, 1*substationDistance}}
	crash_site.createEntity{name="vn-substation",position={-1*substationDistance, 1*substationDistance}}
	crash_site.createEntity{name="vn-substation",position={ 1*substationDistance,-1*substationDistance}}

	crash_site.createEntity{name="crash-site-lab-repaired",position={0,5}}

	crash_site.createEntity{name="crash-site-assembling-machine-1-repaired",position={4,-6}}.set_recipe("iron-gear-wheel")
	crash_site.createEntity{name="crash-site-assembling-machine-2-repaired",position={-4,-6}}.set_recipe("automation-science-pack")

	crash_site.createSiteChest({name="crash-site-chest-1",position={-7,0}},{['flying-robot-frame']=250})
	crash_site.createSiteChest({name="crash-site-chest-2",position={7,-1}},{})

	local chest1items = {
		['burner-mining-drill']=1,
		['stone-furnace']=1,
		['burner-inserter']=1,
		['inserter']=1,
		['big-electric-pole']=1,
		roboport=1,

		['damaged-assembling-machine']=1,
		["vn-electric-mining-drill"]=1,
		['vn-inserter']=1,
		['vn-transport-belt']=600,
		['vn-logistic-chest-requester']=1,

		['construction-robot']=1,
		['logistic-robot']=1,

		['electronic-circuit']=1,

		['firearm-magazine']=1,
		['laser-turret']=1,
		['gun-turret']=1,

		['copper-cable']=1,
		['green-wire']=1,
		['red-wire']=1,

		['accumulator']=1,
		['solar-panel']=1,
		['radar']=1,
	}

	-- logistic-chest-storage
	crash_site.createSiteChest({name="vn-logistic-chest-storage",position={-2,-1}},chest1items)
	crash_site.createSiteChest({name="active-provider-chest",position={-2,0}}, {})

	local chest3 = crash_site.createSiteChest({name="buffer-chest",position={1,0}}, {
		['rail']=10,
		['train-stop']=1,
		['rail-chain-signal']=1,
		['rail-signal']=1,

		['big-electric-pole']=1,
		['roboport']=1,
		['vn-inserter']=1,
		['inserter']=1,
		['storage-chest']=1,
	})
	crash_site.setLogisticRequestSlot(chest3, 1, "rail", 100)
	crash_site.setLogisticRequestSlot(chest3, 2, "train-stop", 1)
	crash_site.setLogisticRequestSlot(chest3, 3, "rail-chain-signal", 1)
	crash_site.setLogisticRequestSlot(chest3, 4, "rail-signal", 1)

	crash_site.setLogisticRequestSlot(chest3, 7, "big-electric-pole", 1)
	crash_site.setLogisticRequestSlot(chest3, 8, "roboport", 1)
	crash_site.setLogisticRequestSlot(chest3, 9, "vn-inserter", 1)
	crash_site.setLogisticRequestSlot(chest3, 10, "inserter", 1)
	crash_site.setLogisticRequestSlot(chest3, 11, "storage-chest", 1)

	crash_site.createSiteChest({name="vn-logistic-chest-storage",position={1,-1}},{
		['coal']=1,
		['stone']=1,
		['wood']=1,
		['iron-ore']=1,
		['copper-ore']=1,
	})

	local roboRadius = 25
	crash_site.spawnRobo({-1*roboRadius,-1*roboRadius})
	crash_site.spawnRobo({roboRadius   ,-1*roboRadius})
	crash_site.spawnRobo({-1*roboRadius,roboRadius   })
	crash_site.spawnRobo({roboRadius   ,roboRadius   })


	crash_site.spillItemsRandomly(game.surfaces["nauvis"])

	rendering.draw_light{
		sprite="utility/light_medium",
		target=electricEnergyInterface,
		surface=electricEnergyInterface.surface,
		forces={electricEnergyInterface.force},
		scale = 40,
		color = {r=1,g=1,b=0.1},
	}

	local surface = game.surfaces["nauvis"]
	for r=0,20 do
		surface.request_to_generate_chunks({0,0},r)
	end

	-- chart the spawn point for player force
	local force = game.forces["player"]
	for r=0,32*6,32 do
		force.chart(surface, {
			{-1*r+1, -1*r+1},
			{r-1, r-1}
		})
	end

	global.clearSpawnResources = true
end

script.on_init(crash_site.spawnCrashSite)


script.register_object(crash_site)


return crash_site

