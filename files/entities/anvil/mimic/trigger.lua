dofile_once("data/scripts/lib/coroutines.lua")
dofile_once("mods/anvil_of_destiny/files/scripts/utils.lua")

function awaken()
  local entity_id = GetUpdatedEntityID()
  local x, y = EntityGetTransform(entity_id)
  local collision_trigger_component = EntityGetFirstComponentIncludingDisabled(entity_id, "CollisionTriggerComponent")
  if not collision_trigger_component then
    return
  end
  EntityRemoveComponent(entity_id, collision_trigger_component)

  -- Enable outline
  for i, comp in ipairs(EntityGetComponentIncludingDisabled(entity_id, "ParticleEmitterComponent") or {}) do
    if ComponentGetValue2(comp, "image_animation_file") == "mods/anvil_of_destiny/files/entities/anvil/mimic/aura.png" then
      EntitySetComponentIsEnabled(entity_id, comp, true)
      break
    end
  end
  -- Disable sound
  for i, comp in ipairs(EntityGetComponentIncludingDisabled(entity_id, "AudioLoopComponent") or {}) do
    EntityRemoveComponent(entity_id, comp)
    break
  end
  -- Change white sparke emitters to blood
  for i, comp in ipairs(EntityGetComponentIncludingDisabled(entity_id, "ParticleEmitterComponent") or {}) do
    if ComponentGetValue2(comp, "emitted_material_name") == "spark_white_bright" then
      ComponentSetValue2(comp, "emitted_material_name", "blood")
      ComponentSetValue2(comp, "gravity", 0, 200)
      ComponentSetValue2(comp, "count_min", 5)
      ComponentSetValue2(comp, "count_max", 5)
      ComponentSetValue2(comp, "draw_as_long", true)
      ComponentSetValue2(comp, "y_pos_offset_min", -70)
      ComponentSetValue2(comp, "y_pos_offset_max", 30)
      ComponentSetValue2(comp, "lifetime_min", 1.5)
      ComponentSetValue2(comp, "lifetime_min", 2)
      ComponentSetValue2(comp, "collide_with_grid", true)
      break
    end
  end
  -- Add hammer spawner script
  EntityAddComponent2(entity_id, "LuaComponent", {
    script_source_file = "mods/anvil_of_destiny/files/entities/anvil/mimic/haunt.lua",
    execute_every_n_frame = 60,
    execute_on_added = true,
    enable_coroutines = true,
  })
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
      ComponentSetValue2(particle_emitter_component, "emitted_material_name", "fire")
      ComponentSetValue2(particle_emitter_component, "lifetime_min", 0.5)
      ComponentSetValue2(particle_emitter_component, "lifetime_max", 1)
      ComponentSetValue2(particle_emitter_component, "emission_interval_min_frames", 1)
      ComponentSetValue2(particle_emitter_component, "emission_interval_max_frames", 1)
      ComponentSetValue2(particle_emitter_component, "airflow_force", 0.1)
      ComponentSetValue2(particle_emitter_component, "airflow_scale", 0.1)
      ComponentSetValue2(particle_emitter_component, "airflow_time", 0.1)
    end
  end
  -- EntityLoad("mods/anvil_of_destiny/files/entities/anvil/laser_activation_sequencer.xml", x, y)
end

function collision_trigger(colliding_entity_id)
  awaken()
end

function transition_to_phase2(x, y)
  EntityLoad("mods/anvil_of_destiny/files/entities/anvil/mimic/anvil2_start.xml", x, y + 20)
end

-- function script_damage_about_to_be_received(damage, x, y, entity_thats_responsible, critical_hit_chance)
--   return damage, critical_hit_chance
-- end

function damage_received(damage, message, entity_thats_responsible, is_fatal, projectile_thats_responsible)
  -- local player = EntityGetWithTag("player_unit")[1]
  -- if entity_thats_responsible == player then
    awaken()
    if is_fatal then
      local entity_id = GetUpdatedEntityID()
      local physics_body2_component = EntityGetFirstComponentIncludingDisabled(entity_id, "PhysicsBody2Component")
      if physics_body2_component then
        EntityRemoveComponent(entity_id, physics_body2_component)
      end
      -- Get the statues and disable their glowing eyes
      local x, y = EntityGetTransform(entity_id)
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
          EntitySetComponentIsEnabled(statue, particle_emitter_component, false)
        end
      end
      transition_to_phase2(x, y)
    end
  -- end
end
