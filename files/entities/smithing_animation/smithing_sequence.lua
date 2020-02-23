dofile_once("data/scripts/lib/coroutines.lua")
dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local children = EntityGetAllChildren(entity_id)
local sparks_entity = children[1]
local sprite_component = EntityGetFirstComponent(entity_id, "SpriteComponent")
local PI = 3.141592
local rotational_speed = 0.005
local rotational_acceleration = 0.02

SetRandomSeed(GameGetFrameNum(), GameGetFrameNum())

async(function()
  local x, y, rot, scale_x = EntityGetTransform(entity_id)
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
      spawn_sparks()
      GamePlaySound("mods/anvil_of_destiny/audio/anvil_of_destiny.bank", "hammer_hit"..Random(1,3), x - 46 * scale_x, y + 10)
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

  local alpha = 1
  while alpha > 0 do
    wait(1)
    alpha = ComponentGetValue(sprite_component, "alpha")
    alpha = alpha - 0.08
    ComponentSetValue(sprite_component, "alpha", alpha)
  end

  EntityKill(entity_id)
end)

local function get_component_with_member(entity_id, member_name)
	local components = EntityGetAllComponents(entity_id)
	for _, component_id in ipairs(components) do
		for k, v in pairs(ComponentGetMembers(component_id)) do
			if(k == member_name) then
				return component_id
			end
		end
	end
end

function spawn_sparks()
  local x, y = EntityGetTransform(sparks_entity)
  EntityLoad("mods/anvil_of_destiny/files/entities/smithing_animation/sparks.xml", x, y + 9)
end
