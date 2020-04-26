-- Kizrak

-- log(serpent.block( data.raw ))

if false then
	log("keys in data.raw") -- luacheck: ignore 511
	for k, _ in pairs(data.raw) do
		log(k)
	end

	log("keys in data.raw.container")
	for k, _ in pairs(data.raw.container) do
		log(k)
	end

	log("keys in data.raw.logistic-container")
	for k, _ in pairs(data.raw["logistic-container"]) do
		log(k)
	end
end



local logistic_chest_storage = table.deepcopy(data.raw["logistic-container"]["logistic-chest-storage"])
logistic_chest_storage.name = "vn-logistic-chest-storage"
logistic_chest_storage.inventory_size = 8000
logistic_chest_storage.order = "b[storage]-c[logistic-chest-storage]"
logistic_chest_storage.subgroup = "logistic-network"

data:extend{logistic_chest_storage}
--log(serpent.block( logistic_chest_storage ))



local logistic_chest_requester = table.deepcopy(data.raw["logistic-container"]["logistic-chest-requester"])
logistic_chest_requester.name = "vn-logistic-chest-requester"
logistic_chest_requester.inventory_size = 4
logistic_chest_requester.subgroup = "logistic-network"
logistic_chest_requester.logistic_slots_count = 1
logistic_chest_requester.circuit_wire_max_distance = 0
logistic_chest_requester.minable.result = "vn-logistic-chest-requester"

data:extend{logistic_chest_requester}
--log(serpent.block( logistic_chest_requester ))



local logistic_chest_requester_item = table.deepcopy(data.raw.item["logistic-chest-requester"])
logistic_chest_requester_item.name = "vn-logistic-chest-requester"
logistic_chest_requester_item.place_result = "vn-logistic-chest-requester"
logistic_chest_requester_item.order = "zk-b[storage]-e[logistic-chest-requester]"

data:extend{logistic_chest_requester_item}
--log(serpent.block( logistic_chest_requester_item ))

