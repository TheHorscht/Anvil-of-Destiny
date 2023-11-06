dofile_once("mods/anvil_of_destiny/files/entities/anvil/anvil.lua")

-- Used for debug reasons only, when an error occurs the anvil should spit out the input items
-- and this script will be added to each outputted item, to re-enable the anvil once everything in range has been picked up
-- so it doesn't get swallowed again instantly as soon as the items are spat out

local function get_associated_anvil_location(picked_item_id)
  local var_store_comp = get_variable_storage_component(picked_item_id, "aod_location")
  if var_store_comp then
    local x = ComponentGetValue2(var_store_comp, "value_int")
    local y = ComponentGetValue2(var_store_comp, "value_float")
    return x, y
  end
end

function item_pickup(entity_item, entity_pickupper, item_name)
  local x, y = get_associated_anvil_location(entity_item)
  local anvil_id
  for i, entity in ipairs(EntityGetInRadius(x, y, 30)) do
    if EntityGetName(entity) == "anvil_of_destiny" then
      anvil_id = entity
      break
    end
  end
  if anvil_id then
    -- Everytime one of the items of the error output are picked up, check if no more output items are found, if so, reenable anvil
    local output_entities_left = false
    for i, entity_id in ipairs(EntityGetInRadius(x, y, 50)) do
      local var_store_comp = get_variable_storage_component(entity_id, "aod_location")
      if var_store_comp then
        if entity_item == entity_id then
          EntityRemoveComponent(entity_id, var_store_comp)
        else
          output_entities_left = true
        end
      end
    end
    if not output_entities_left then
      reenable_anvil(anvil_id)
    end
  end
end
