dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/anvil_of_destiny/files/scripts/utils.lua")
dofile_once("mods/anvil_of_destiny/files/entities/anvil/anvil.lua")
local potion_bonuses = dofile_once("mods/anvil_of_destiny/files/entities/anvil/potion_bonuses.lua")

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

function scroll_inventory()
  local ent = EntityCreateNew()
  EntityAddComponent2(ent, "LuaComponent", {
    script_source_file="mods/anvil_of_destiny/files/scripts/scroll_inventory.lua",
    execute_every_n_frame=-1,
    execute_on_added=true,
    enable_coroutines=true,
  })
end

function get_fungal_shifted_material_name(material_name, shifts)
  if not shifts then
    local world_state_entity_id = GameGetWorldStateEntity()
    local world_state_component = EntityGetFirstComponentIncludingDisabled(world_state_entity_id, "WorldStateComponent")
    shifts = ComponentGetValue2(world_state_component, "changed_materials")
  end
  local target = material_name
  for i=#shifts-1, 1, -2 do
    local from = shifts[i]
    local to = shifts[i+1]
    if target == from or target == from then
      target = to
    end
  end
  return target
end

function interacting(entity_who_interacted, entity_interacted, interactable_name)
  local anvil_id
  local x, y = EntityGetTransform(entity_interacted)
  local entities_in_radius = EntityGetInRadius(x, y, 50)
  for i, entity in ipairs(entities_in_radius) do
    if EntityGetName(entity) == "anvil_of_destiny" then
      anvil_id = entity
      break
    end
  end

  if anvil_id == nil then return end

  local active_item = get_active_item()
  if active_item ~= nil then
    -- Check if it's a potion
    local material_sucker_component = EntityGetFirstComponent(active_item, "MaterialSuckerComponent")
    local material_inventory_component = EntityGetFirstComponent(active_item, "MaterialInventoryComponent")
    if material_sucker_component and material_inventory_component then
      local counts = ComponentGetValue2(material_inventory_component, "count_per_material_type")
      local material_name, material_amount
      for material_id, amount in pairs(counts) do
        if amount > 800 then
          material_name = CellFactory_GetName(material_id - 1)
          material_amount = amount
          break
        end
      end
      local shifted_material_name = get_fungal_shifted_material_name(material_name)
      if shifted_material_name == nil then return end
      if potion_bonuses[shifted_material_name] ~= nil then -- It's a potion and it has enough material inside
        -- Remove the material from the potion
        AddMaterialInventoryMaterial(active_item, material_name, 0)
        play_pouring_animation(anvil_id, shifted_material_name, x, y)
        EntityKill(entity_interacted)
        if ModSettingGet("anvil_of_destiny.destroy_potion_on_insert") then
          local chance = ModSettingGet("anvil_of_destiny.destroy_potion_on_insert_chance")
          local cx, cy = GameGetCameraPos()
          math.randomseed(cx + cy + GameGetFrameNum())
          if math.random() <= chance then
            GamePrintImportant("$log_AoD_potion_broke", "$log_AoD_potion_broke_desc")
            EntityKill(active_item)
            scroll_inventory()
          end
        end
      end
    end
  end
end

-- Warning: This has side effects beside just playing the animation
function play_pouring_animation(anvil_id, material_name, x, y)
  if not is_debug() then
    local pour_animation = EntityLoad("mods/anvil_of_destiny/files/entities/anvil/potion_pour_animation.xml", x + 1, y - 11)
    EntityAddComponent2(pour_animation, "VariableStorageComponent", {
      name="potion_material",
      value_string=material_name,
    })
  end
  local potion_material_poured_var_store = get_variable_storage_component(anvil_id, "potion_material_poured")
  if not potion_material_poured_var_store then
    EntityAddComponent2(anvil_id, "VariableStorageComponent", {
      name="potion_material_poured",
      value_string=material_name,
    })
  else
    ComponentSetValue2(potion_material_poured_var_store, "value_string", material_name)
  end
  -- Add a script that should run after the animation is done that triggers the feeding/inpu the anvil
  -- The reason I'm doing it like this instead of at the end of the animation.lua is in case the animation somehow breaks,
  -- by e.g. restarting the game in the middle of it
  EntityAddComponent2(anvil_id, "LuaComponent", {
    script_source_file="mods/anvil_of_destiny/files/entities/anvil/consume_potion.lua",
    execute_every_n_frame=is_debug() and 1 or 112,
  })
  -- Disable anvil interactivity while animation is playing, gets reenabled in consume_potion.lua
  local collision_trigger_components = EntityGetComponent(anvil_id, "CollisionTriggerComponent") or {}
  for i, comp in ipairs(collision_trigger_components) do
    EntitySetComponentIsEnabled(anvil_id, comp, false)
  end
end