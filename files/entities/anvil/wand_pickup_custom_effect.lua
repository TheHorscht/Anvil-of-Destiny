function get_var(entity_id, variable_name)
  local variable_storage_components = EntityGetComponent(entity_id, "VariableStorageComponent")
  for i, comp in ipairs(variable_storage_components) do
    local name = ComponentGetValue(comp, "name")
    if name == variable_name then
      return ComponentGetValue(comp, "value_string")
    end
  end
end

local effects = {
  blood_worm = function(entity_item, entity_pickupper, x, y)
    -- Spawn worms and apply nightvision drug effect
    local radius = 100
    for i=1,4 do
      local pie = 2 * math.pi / 10
      EntityLoad("data/entities/animals/worm.xml", x + math.cos(i * pie) * radius, y + math.sin(i * pie) * radius)
    end
    local drug_effect_component = EntityGetFirstComponent(entity_pickupper, "DrugEffectComponent")
    if drug_effect_component ~= nil then
      ComponentSetValue(drug_effect_component, "nightvision_amount", 2)
    end
  end,
  magic_liquid_invisibility = function(entity_item, entity_pickupper, x, y)
    -- Apply invisibility to the player
    LoadGameEffectEntityTo(entity_pickupper, "mods/anvil_of_destiny/files/entities/anvil/invisibility.xml")
  end,
  magic_liquid_hp_regeneration = function(entity_item, entity_pickupper, x, y)
    local radius = 50
    for i=1,4 do
      local pie = 2 * math.pi / 10
      EntityLoad("data/entities/animals/scavenger_heal.xml", x + math.cos(i * pie) * radius, y + math.sin(i * pie) * radius)
    end
  end,
  magic_liquid_worm_attractor = function(entity_item, entity_pickupper, x, y)
    local radius = 100
    for i=1,4 do
      local pie = 2 * math.pi / 10
      EntityLoad("data/entities/animals/worm.xml", x + math.cos(i * pie) * radius, y + math.sin(i * pie) * radius)
    end
  end,
}

function item_pickup(entity_item, entity_pickupper, item_name)
  local entity_id = GetUpdatedEntityID()
  local x, y = EntityGetTransform(entity_id)
  local material = get_var(entity_id, "material")
  -- GameCreateSpriteForXFrames("data/debug/circle_16.png", x, y, true, 0, 0, 999999)

  if effects[material] ~= nil then
    effects[material](entity_item, entity_pickupper, x, y)
  else
    error("We should never get here, material: " .. material)
  end
end
