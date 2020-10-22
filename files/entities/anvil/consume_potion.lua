dofile_once("mods/anvil_of_destiny/files/entities/anvil/anvil.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local var_stores = EntityGetComponent(entity_id, "VariableStorageComponent")
for i, var_store in ipairs(var_stores) do
  if ComponentGetValue2(var_store, "name") == "potion_material_poured" then
    local material_name = ComponentGetValue2(var_store, "value_string")
    feed_anvil(entity_id, "potion", material_name)
  end
end
local state = get_state(entity_id)
if not state.is_disabled then
  local collision_trigger_components = EntityGetComponentIncludingDisabled(entity_id, "CollisionTriggerComponent") or {}
  for i, comp in ipairs(collision_trigger_components) do
    EntitySetComponentIsEnabled(entity_id, comp, true)
  end
end

EntityRemoveComponent(entity_id, GetUpdatedComponentID())
