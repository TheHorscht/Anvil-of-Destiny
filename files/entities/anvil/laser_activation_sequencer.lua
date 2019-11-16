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
  local statues = EntityGetInRadiusWithTag(x, y, 100, "anvil_of_destiny_statue")
  if statues ~= nil then
    for i,statue in ipairs(statues) do
      if EntityHasTag(statue, "facing_left") then
        EntityAddComponent(statue, "LuaComponent", {
          script_source_file="mods/anvil_of_destiny/files/entities/statue/angery.lua",
          execute_on_added="1",
          execute_every_n_frame="60",
          execute_times="-1",
        })
      end
    end
  end
end

if current_frame == 270 then
  local statues = EntityGetInRadiusWithTag(x, y, 100, "anvil_of_destiny_statue")
  if statues ~= nil then
    for i,statue in ipairs(statues) do
      if EntityHasTag(statue, "facing_right") then
        EntityAddComponent(statue, "LuaComponent", {
          script_source_file="mods/anvil_of_destiny/files/entities/statue/angery.lua",
          execute_on_added="1",
          execute_every_n_frame="60",
          execute_times="-1",
        })
      end
    end
  end
  -- We are done
  local entity = GetUpdatedEntityID()
  EntityRemoveComponent(entity, EntityGetFirstComponent(entity, "LuaComponent", "counter_example_script"))
end