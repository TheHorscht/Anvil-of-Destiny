dofile("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
-- shoot_projectile(0, "data/entities/projectiles/deck/crumbling_earth.xml", x, y, 0, 0, false)
EntityLoad("data/entities/animals/necromancer.xml", x, y)
EntityKill(entity_id)
