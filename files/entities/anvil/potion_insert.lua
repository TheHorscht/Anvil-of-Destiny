dofile_once("mods/anvil_of_destiny/files/entities/anvil/anvil.lua")

function get_active_item()
  local player_entities = EntityGetWithTag("player_unit")
  if #player_entities == 0 then
    return
  end
  local player_entity = player_entities[1]
  local inventory_component = EntityGetFirstComponent(player_entity, "Inventory2Component")
  if inventory_component ~= nil then
    return ComponentGetValueInt(inventory_component, "mActiveItem")
  end
end

function item_pickup(entity_item, entity_who_picked, item_name)
  local x, y = EntityGetTransform(entity_item)
  -- This "item" will now be in players inventory, but we don't want it there so kill it off and respawn it if anvil is found
  EntityKill(entity_item)

  local anvil_id
  local entities_in_radius = EntityGetInRadius(x, y, 50)
  for i, entity in ipairs(entities_in_radius) do
    if EntityGetName(entity) == "anvil_of_destiny" then
      anvil_id = entity
      break
    end
  end

  if anvil_id == nil then return end

  local state = get_state(anvil_id)

  EntityLoad("mods/anvil_of_destiny/files/entities/anvil/potion_place.xml", x, y)

  local active_item = get_active_item()
  if active_item ~= nil then
    -- Check if it's a potion
    local material_sucker_component = EntityGetFirstComponent(active_item, "MaterialSuckerComponent")
    local material_inventory_component = EntityGetFirstComponent(active_item, "MaterialInventoryComponent")
    if material_sucker_component ~= nil and material_inventory_component ~= nil then
      local amount = ComponentGetValueInt(material_sucker_component, "mAmountUsed")
      if amount > 800 then
        feed_anvil(anvil_id, "potion", active_item)
      end
    end
  end
end
