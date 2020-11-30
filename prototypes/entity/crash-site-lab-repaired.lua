-- From Factorio 1.0.0

local sb = serpent.block -- luacheck: ignore 211


for k,v in pairs( data.raw['lab'] ) do
	log(sb(k))
end

log("crash-site-lab-repaired:\n"..sb( data.raw['lab']['crash-site-lab-repaired'] ))

