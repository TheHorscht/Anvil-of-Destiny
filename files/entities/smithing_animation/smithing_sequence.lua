dofile_once("data/scripts/lib/coroutines.lua")
dofile_once("data/scripts/lib/utilities.lua")
local EZWand = dofile_once("mods/anvil_of_destiny/lib/EZWand/EZWand.lua")

local entity_id = GetUpdatedEntityID()
local children = EntityGetAllChildren(entity_id)
local sparks_entity = children[1]
local sprite_component = EntityGetFirstComponent(entity_id, "SpriteComponent")
local PI = 3.141592
local rotational_speed = 0.005
local rotational_acceleration = 0.02

SetRandomSeed(GameGetFrameNum(), GameGetFrameNum())

local function get_wand_storage(anvil_id)
  local children = EntityGetAllChildren(anvil_id)
  for i, child in ipairs(children) do
    if EntityGetName(child) == "wand_storage" then
      return child
    end
  end
end

local function retrieve_wand(anvil_id, index)
  local wand_storage = get_wand_storage(anvil_id)
  local stored_wands = EntityGetAllChildren(wand_storage)

  return stored_wands[index]
end

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
      local anvil_id = EntityGetParent(entity_id)
      local anvil_x, anvil_y = EntityGetTransform(anvil_id)
      local sound_x, sound_y = anvil_x + 4, anvil_y - 20
      GamePlaySound("mods/anvil_of_destiny/audio/anvil_of_destiny.bank", "hammer_hit"..Random(1,3), sound_x, sound_y)
      GameScreenshake(10, anvil_x, anvil_y)
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
  -- First hammer is non rotated (scale_x 1), if it's the first hammer, spawn the second one, otherwise we're done
  local anvil_id = EntityGetParent(entity_id)
  if scale_x > 0 then
    local smithing_sequence = EntityLoad("mods/anvil_of_destiny/files/entities/smithing_animation/smithing_sequence.xml", x - 92, y)
    EntitySetTransform(smithing_sequence, x - 92, y, 0, -1, 1)
    EntityAddChild(anvil_id, smithing_sequence)
  else
--[[     local smithing_sequence = EntityLoad("mods/anvil_of_destiny/files/entities/smithing_animation/smithing_sequence.xml", x + 92, y)
    EntitySetTransform(smithing_sequence, x + 92, y, 0, 1, 1)
    EntityAddChild(anvil_id, smithing_sequence) ]]

    -- Spit out the stored wand
    local wand_id = retrieve_wand(anvil_id, 1)
    local anvil_x, anvil_y = EntityGetTransform(anvil_id)
    EntityRemoveFromParent(wand_id)
    EZWand(wand_id):PlaceAt(anvil_x + 4, anvil_y - 30)
    --EZWand(wand_id):PlaceAt(anvil_x + 4, anvil_y - 30)

    --GameCreateSpriteForXFrames("data/debug/box_10x10.png", anvil_x + 4, anvil_y - 30, true, 0, 0, 120)

    GameScreenshake(20, anvil_x, anvil_y)
    GamePrintImportant("A gift from the gods", "")
    GamePlaySound("mods/anvil_of_destiny/audio/anvil_of_destiny.snd", "fanfare", anvil_x + 4, anvil_y - 30)
    edit_component(anvil_id, "AudioLoopComponent", function(comp, vars)
      EntityRemoveComponent(anvil_id, comp)
    end)
    edit_all_components(anvil_id, "CollisionTriggerComponent", function(comp, vars)
      EntityRemoveComponent(anvil_id, comp)
    end)
  end
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
  EntityLoad("mods/anvil_of_destiny/files/entities/smithing_animation/sparks.xml", x, y + 8)
end
