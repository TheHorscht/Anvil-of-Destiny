dofile_once("data/scripts/lib/coroutines.lua")

function clamp(x, lowerlimit, upperlimit)
  if (x < lowerlimit) then
    x = lowerlimit
  end
  if (x > upperlimit) then
    x = upperlimit
  end
  return x
end

function smootherstep(edge0, edge1, x)
  x = clamp((x - edge0) / (edge1 - edge0), 0.0, 1.0)
  return x * x * x * (x * (x * 6 - 15) + 10)
end

async(function()
  local entity_id = GetUpdatedEntityID()
  local x, y = EntityGetTransform(entity_id)
  step = 0
  wait(5)
  -- Rotate
  while step < 1 do
    wait(0)
    -- local rot = smoothstep(0, (math.pi / 180 * 135), step)
    local rot = smootherstep(0, 1, step)
    step = step + 0.025
    step = clamp(step, 0, 1)
    EntitySetTransform(entity_id, x, y, -rot * (math.pi / 180 * 135))
  end
  -- Do particle pouring
  local offset_x = -6
  local offset_y = -14
  local material_name
  local var_stores = EntityGetComponent(entity_id, "VariableStorageComponent")
  for i, var_store in ipairs(var_stores) do
    if ComponentGetValue2(var_store, "name") == "potion_material" then
      material_name = ComponentGetValue2(var_store, "value_string")
    end
  end
  local particle_emitter_component = EntityAddComponent2(entity_id, "ParticleEmitterComponent", {
    emitted_material_name=material_name,
    lifetime_min=1,
    lifetime_max=1,
    count_min=1,
    count_max=1,
    y_vel_min=-10,
    y_vel_max=10,
    x_vel_min=-10,
    x_vel_max=10,
    y_pos_offset_min=offset_y,
    y_pos_offset_max=offset_y,
    x_pos_offset_min=offset_x,
    x_pos_offset_max=offset_x,
    airflow_force=0,
    airflow_time=0,
    airflow_scale=0,
    render_on_grid=false,
    fade_based_on_lifetime=true,
    emission_interval_min_frames=1,
    emission_interval_max_frames=1,
    emit_cosmetic_particles=true,
    image_animation_file="mods/anvil_of_destiny/files/entities/anvil/potion_pour_particle_animation.png",
    image_animation_speed=4,
    image_animation_loop=false,
    image_animation_emission_probability=1,
    is_emitting=true,
  })
  ComponentSetValue2(particle_emitter_component, "gravity", 0, 0)
  wait(40)
  -- Fade alpha
  local sprite_component = EntityGetFirstComponentIncludingDisabled(entity_id, "SpriteComponent")
  if sprite_component then
    local step = 0
    while step < 1 do
      wait(0)
      step = step + 0.04
      ComponentSetValue2(sprite_component, "alpha", 1 - smootherstep(0, 1, step))
    end
  end
  wait(30)
  EntityKill(entity_id)
end)
