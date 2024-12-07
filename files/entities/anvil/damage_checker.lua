dofile_once("mods/anvil_of_destiny/files/scripts/utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local physics_body
local children = EntityGetAllChildren(entity_id)
if children ~= nil then
  for i, v in ipairs(children) do
    if EntityGetName(v) == "physics_body" then
      physics_body = EntityGetFirstComponent(v, "PhysicsBody2Component")
    end
  end
end


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
    GamePrintImportant("$log_AoD_anvil_defiled", "$log_AoD_anvil_defiled_desc")
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
    EntityLoad("mods/anvil_of_destiny/files/entities/anvil/converter.xml", x, y)
  end
end
