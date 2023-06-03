dofile_once("data/scripts/lib/coroutines.lua")
dofile_once("data/scripts/lib/utilities.lua")

local PI = 3.141592
local rotational_speed = 0.003
-- local rotational_speed = 0.005
-- local rotational_acceleration = 0.05
local rotational_acceleration = 0.0075

function spawn_sparks(sparks_entity)
  local x, y = EntityGetTransform(sparks_entity)
  EntityLoad("mods/anvil_of_destiny/files/entities/hammer_animation/sparks.xml", x, y + 7)
  shoot_projectile(sparks_entity, "data/entities/projectiles/explosion.xml", x, y + 5, 0, 0, false)
end

async(function()
  local entity_id = GetUpdatedEntityID()
  local x, y, rot, scale_x = EntityGetTransform(entity_id)
  local child = (EntityGetAllChildren(entity_id) or {})[1]
  -- PI/2 = 90° to the right
  -- -PI/2 = 90° to the left
  while (scale_x > 0 and rot > -PI / 2) or (scale_x < 0 and rot < PI / 2) do
    x, y, rot, scale_x = EntityGetTransform(entity_id)
    wait(1)
    rot = rot - rotational_speed * scale_x
    if (scale_x > 0 and rot < -PI / 2) or (scale_x < 0 and rot > PI / 2) then
      rot = (-PI * scale_x) / 2
      rotational_speed = -rotational_speed * 0.2
      rot = rot - rotational_speed * scale_x
      EntitySetTransform(entity_id, x, y, rot)
      spawn_sparks(child)
      local event_x, event_y = x - scale_x * 46, y + 10
      GamePlaySound("mods/anvil_of_destiny/audio/anvil_of_destiny.bank", "hammer_hit", event_x, event_y)
      GameScreenshake(8, event_x, event_y)
      break
    end
    rotational_speed = rotational_speed + rotational_acceleration
    EntitySetTransform(entity_id, x, y, rot)
  end

  while (scale_x > 0 and rot > -PI / 2) or (scale_x < 0 and rot < PI / 2) do
    x, y, rot = EntityGetTransform(entity_id)
    wait(1)
    rot = rot - rotational_speed * scale_x
    if (scale_x > 0 and rot < -PI / 2) or (scale_x < 0 and rot > PI / 2) then
      EntitySetTransform(entity_id, x, y, (-PI * scale_x) / 2)
      break
    end
    rotational_speed = rotational_speed + rotational_acceleration
    EntitySetTransform(entity_id, x, y, rot)
  end

  local sprite_component = EntityGetFirstComponentIncludingDisabled(entity_id, "SpriteComponent")
  local alpha = 1
  while alpha > 0 do
    wait(1)
    alpha = ComponentGetValue(sprite_component, "alpha")
    alpha = alpha - 0.08
    ComponentSetValue(sprite_component, "alpha", alpha)
  end

  EntityKill(entity_id)
end)
