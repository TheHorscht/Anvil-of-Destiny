local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
SetRandomSeed(GameGetFrameNum() + entity_id, x + y)
local random_number = Random(1, 1000)
local spawn_direction_angle = Random(-3.1415, 3.1415)
local entity_to_spawn = nil

if random_number <= 2 then -- 2%
  entity_to_spawn = "data/entities/animals/worm_big.xml"
elseif random_number <= 10 then -- 8%
  entity_to_spawn = "data/entities/animals/worm.xml"
elseif random_number <= 30 then -- 20%
  entity_to_spawn = "data/entities/animals/worm_tiny.xml"
end

local inventory_id = EntityGetParent(entity_id)
if inventory_id == 0 then return end
local owner_id = EntityGetParent(inventory_id)
if owner_id == 0 then return end
local game_effect_component = GetGameEffectLoadTo(owner_id, "WORM_ATTRACTOR", true)
ComponentSetValue2(game_effect_component, "frames", 60)

if entity_to_spawn then
  local radius = 300
  EntityLoad(entity_to_spawn, x + math.cos(spawn_direction_angle) * radius, y + math.sin(spawn_direction_angle) * radius)
end
