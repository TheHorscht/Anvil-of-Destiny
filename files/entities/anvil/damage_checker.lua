local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local physics_body = EntityGetFirstComponent(entity_id, "PhysicsBodyComponent")

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
    -- remove divine sparkles (the only child entity)
    local children = EntityGetAllChildren(entity_id)
    if children ~= nil and children[1] ~= nil then
      EntityKill(children[1])
    end

    GameScreenshake(100)
    GamePlaySound("data/audio/Desktop/event_cues.snd", "event_cues/sampo_pick/create", x, y)
    GamePrintImportant("A holy relic has been defiled!", "This vile act shall not go unpunished")
    local entity_id = GetUpdatedEntityID()
    local x, y = EntityGetTransform(entity_id)
    local statues = EntityGetInRadiusWithTag(x, y, 100, "anvil_of_destiny_statue")
    if statues ~= nil then
      for i,statue in ipairs(statues) do
        local x, y = EntityGetTransform(statue)
        EntityLoad("mods/anvil_of_destiny/files/entities/anvil/spawn_necro_delayed.xml", x + 20, y - 5)
        EntityConvertToMaterial(statue, "bone")
        EntitySetComponentsWithTagEnabled(statue, "enabled_at_start", false)
      end
    end

    EntityKill(entity_id)

  end
end
