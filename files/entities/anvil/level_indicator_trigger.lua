-- This should simply remove itself and add a LuaComponent that executes level_indicator.lua as soon as the player gets close,
-- which in turn waits 1 second then checks if an actively held wand is close, if so, display level, if not remove itself and
-- re-attach the trigger, all this to safe performance (hopefully)

function collision_trigger(colliding_entity_id)
  -- Remove itself and add level_indicator.lua
  local entity_id = GetUpdatedEntityID()
  EntityRemoveComponent(entity_id, GetUpdatedComponentID())
  local level_indicator = EntityAddComponent(entity_id, "LuaComponent", {
    script_source_file="mods/anvil_of_destiny/files/entities/anvil/level_indicator.lua",
    execute_on_added="0",
    execute_every_n_frame="10" -- This should be fast enough
  })
end
