-- From Factorio 1.0.0

local sb = serpent.block -- luacheck: ignore 211


for k,v in pairs( data.raw['electric-energy-interface'] ) do
	log(sb(k))
end

log("crash-site-generator:\n"..sb( data.raw['electric-energy-interface']['crash-site-generator'] ))

