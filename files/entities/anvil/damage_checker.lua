local entity_id = GetUpdatedEntityID()
local physics_body = EntityGetFirstComponent(entity_id, "PhysicsBodyComponent")
local x, y = EntityGetTransform(entity_id)
 
function disable_all_components(entity_id, component_type_name)
  local components = EntityGetComponent(entity_id, component_type_name)
  if components ~= nil then
    for _, comp in ipairs(components) do
      EntitySetComponentIsEnabled(entity_id, comp, false)
    end
  end
end

function wrath_of_the_gods()
  GameScreenshake(100, x, y)
  GamePrintImportant("An anvil has been defiled!", "This vile act shall not go unpunished!")
  EntityAddComponent(entity_id, "LuaComponent", {
    script_source_file = "mods/anvil_of_destiny/files/entities/anvil/statues_angery.lua",
    execute_on_added="0",
    execute_every_n_frame="20",
    execute_times="-1"
  })
end

if physics_body ~= nil then
  local pixels = ComponentGetValueInt(physics_body, "mPixelCount")

  if (pixels < 800) then
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

    wrath_of_the_gods()
  end
end
