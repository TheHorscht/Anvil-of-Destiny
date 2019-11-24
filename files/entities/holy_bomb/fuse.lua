if not DOFILE_CACHE then dofile("mods/anvil_of_destiny/files/scripts/dofile_cacher.lua") end
dofile_cached("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local bomb_holy = shoot_projectile(entity_id, "mods/anvil_of_destiny/files/entities/holy_bomb/explosion.xml", x, y, 0, 0, false)
