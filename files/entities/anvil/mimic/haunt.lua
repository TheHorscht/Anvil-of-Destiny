dofile_once("data/scripts/lib/coroutines.lua")

local player = EntityGetWithTag("player_unit")[1]
if not player then return end
local px, py = EntityGetTransform(player)
local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local dx = x - px
local dy = y - py
local dist2 = dx*dx + dy*dy
-- Stop hammering when too far away
if dist2 > 400 * 400 then
  return
end

-- Spawn hammers regularly on top of the player
SetRandomSeed(px + GameGetFrameNum(), py)
local direction = 1 - Random(1) * 2
local hammer = EntityLoad("mods/anvil_of_destiny/files/entities/anvil/mimic/hammer.xml", px + 47 * direction, py - 12)
EntitySetTransform(hammer, px + 47 * direction, py - 12, 0, direction)
