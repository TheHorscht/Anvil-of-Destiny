dofile_once("mods/anvil_of_destiny/files/scripts/utils.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

current_frame = 0
local variablestorages = EntityGetComponent( entity_id, "VariableStorageComponent")

if variablestorages ~= nil then
  for i,variablestorage in ipairs(variablestorages) do
    if ComponentGetValue(variablestorage, "name") == "current_frame" then
      current_frame = ComponentGetValueInt(variablestorage, "value_int")
      current_frame = current_frame + 30
      ComponentSetValue(variablestorage, "value_int", current_frame)
    end
  end
end

if current_frame == 240 then
  -- Get left facing statue
  local entities_in_radius = EntityGetInRadius(x, y, 100)
  for i, entity in ipairs(entities_in_radius) do
    local entity_type = get_stored_entity_type(entity)
    if entity_type == "statue_facing_left" then
      EntityAddComponent(entity, "LuaComponent", {
        script_source_file="mods/anvil_of_destiny/files/entities/statue/angery.lua",
        execute_on_added="1",
        execute_every_n_frame="60",
        execute_times="-1",
      })
    end
  end
end

if current_frame == 270 then
  -- Get right facing statue
  local entities_in_radius = EntityGetInRadius(x, y, 100)
  for i, entity in ipairs(entities_in_radius) do
    local entity_type = get_stored_entity_type(entity)
    if entity_type == "statue_facing_right" then
      EntityAddComponent(entity, "LuaComponent", {
        script_source_file="mods/anvil_of_destiny/files/entities/statue/angery.lua",
        execute_on_added="1",
        execute_every_n_frame="60",
        execute_times="-1",
      })
    end
  end
  -- We are done
  local entity = GetUpdatedEntityID()
  EntityRemoveComponent(entity, EntityGetFirstComponent(entity, "LuaComponent"))
end