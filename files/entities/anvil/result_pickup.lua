dofile_once("mods/anvil_of_destiny/files/entities/anvil/anvil.lua")

function item_pickup(entity_item, entity_pickupper, item_name)
  local x, y = EntityGetTransform(entity_item)
  local anvil_id
  for i, entity in ipairs(EntityGetInRadius(x, y + 20, 20)) do
    if EntityGetName(entity) == "anvil_of_destiny" then
      anvil_id = entity
      break
    end
  end
  if anvil_id then
    reenable_anvil(anvil_id)
  end
  EntityRemoveComponent(entity_item, GetUpdatedComponentID())
end
