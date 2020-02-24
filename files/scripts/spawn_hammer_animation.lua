function spawn_hammer_animation(x, y, direction, delay)
  if delay < 1 then
    delay = 1
  end
  -- Create a temporary Entity whos only job it is to spawn the hammer after a delay
  -- The hammer spawning happens in part 2
  local spawner_entity = EntityCreateNew()
  EntitySetTransform(spawner_entity, x, y, 0, direction, 1)
  EntityAddComponent(spawner_entity, "LuaComponent", {
    script_source_file="mods/anvil_of_destiny/files/scripts/spawn_hammer_animation2.lua",
    execute_on_added="0",
    execute_every_n_frame=tostring(delay),
    remove_after_executed="1",
    kill_entity="1",
  })
end
