dofile_once("mods/anvil_of_destiny/files/scripts/utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local physics_body = EntityGetFirstComponentIncludingDisabled(entity_id, "PhysicsBody2Component")


function disable_all_components(entity_id, component_type_name)
  local components = EntityGetComponent(entity_id, component_type_name)
  if components ~= nil then
    for _, comp in ipairs(components) do
      EntitySetComponentIsEnabled(entity_id, comp, false)
    end
  end
end

if physics_body ~= nil then
  local pixels = ComponentGetValueInt(physics_body, "mPixelCount")

  if pixels ~= 0 and pixels < 800 then
    disable_all_components(entity_id, "ParticleEmitterComponent")
    disable_all_components(entity_id, "AudioLoopComponent")
    disable_all_components(entity_id, "CollisionTriggerComponent")
    disable_all_components(entity_id, "LuaComponent")
    disable_all_components(entity_id, "SpriteComponent")
    GameScreenshake(100)
    GamePlaySound("data/audio/Desktop/event_cues.bank", "event_cues/sampo_pick/create", x, y)
    EntityLoad("mods/anvil_of_destiny/files/entities/anvil/converter.xml", x, y)
  end
end
