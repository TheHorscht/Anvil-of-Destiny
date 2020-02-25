dofile_once("mods/anvil_of_destiny/files/scripts/utils.lua")

function material_area_checker_failed(x, y)
  local entity_id = GetUpdatedEntityID()
  local x, y = EntityGetTransform(entity_id)

  disable_all_components(entity_id, "ParticleEmitterComponent")
  disable_all_components(entity_id, "AudioLoopComponent")
  disable_all_components(entity_id, "CollisionTriggerComponent")
  disable_all_components(entity_id, "LuaComponent")
  disable_all_components(entity_id, "SpriteComponent")
  disable_all_components(entity_id, "MaterialAreaCheckerComponent")
  
  local children = EntityGetAllChildren(entity_id)
  if children ~= nil then
    for i, v in ipairs(children) do
      if EntityGetName(v) == "anvil_of_destiny_divine_sparkles" then
        EntityKill(v)
        break
      end
    end
  end

  GameScreenshake(50)
  GamePlaySound("data/audio/Desktop/event_cues.snd", "event_cues/sampo_pick/create", x, y)
  GamePrintImportant("A holy artifact has been defiled!", "This vile act shall not go unpunished")
  local entity_id = GetUpdatedEntityID()
  local x, y = EntityGetTransform(entity_id)
  -- Get the statues and enable their glowing eyes
  local entities_in_radius = EntityGetInRadius(x, y, 100)
  local statues = {}
  for i, entity in ipairs(entities_in_radius) do
    local entity_type = get_stored_entity_type(entity)
    if entity_type == "statue_facing_left" or entity_type == "statue_facing_right" then
      table.insert(statues, entity)
    end
  end
  for i,statue in ipairs(statues) do
    local particle_emitter_component = get_component_with_member(statue, "emitted_material_name")
    if particle_emitter_component ~= nil then
      EntitySetComponentIsEnabled(statue, particle_emitter_component, true)
    end
  end

  EntityLoad("mods/anvil_of_destiny/files/entities/anvil/laser_activation_sequencer.xml", x, y)
  EntityConvertToMaterial(entity_id, "lava")

end

function disable_all_components(entity_id, component_type_name)
  local components = EntityGetComponent(entity_id, component_type_name)
  if components ~= nil then
    for _, comp in ipairs(components) do
      EntitySetComponentIsEnabled(entity_id, comp, false)
    end
  end
end
