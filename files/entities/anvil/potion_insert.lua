dofile_once("mods/anvil_of_destiny/files/entities/anvil/anvil.lua")

function color_to_material(color)
  local t = {
    [-1525963520] = "acid",
    [-1274785627] = "alcohol",
    [-16777085] = "blood",
    [-7910083] = "blood_cold",
    [-16646013] = "blood_fading",
    [-1334491739] = "blood_fungi",
    [-754934875] = "blood_worm",
    [-8355712] = "cement",
    [-452984667] = "cloud_blood",
    [-697812571] = "cloud_slime",
    [-9169096] = "creepy_liquid",
    [-1526710619] = "lava",
    [-1342153819] = "liquid_fire",
    [-1291808603] = "liquid_fire_weak",
    [-1519802971] = "magic_liquid",
    [-1438300763] = "magic_liquid_berserk",
    [-649582171] = "magic_liquid_charm",
    [-1352686226] = "magic_liquid_hp_regeneration",
    [-1352620690] = "magic_liquid_hp_regeneration_unstable",
    [-593142487] = "magic_liquid_invisibility",
    [-1516985081] = "magic_liquid_mana_regeneration",
    [-1065572974] = "magic_liquid_movement_faster",
    [-1348378715] = "magic_liquid_polymorph",
    [-1122144091] = "magic_liquid_protection_all",
    [-6334813] = "magic_liquid_random_polymorph",
    [-1264217767] = "magic_liquid_teleportation",
    [-8883096] = "magic_liquid_worm_attractor",
    [-1237219419] = "material_confusion",
    [-12566464] = "metal_molten",
    [-1342148699] = "midas",
    [-1515903465] = "midas_precursor",
    [-14141635] = "oil",
    [-129784509] = "peat",
    [-1515881439] = "plasma_fading",
    [-8424589] = "plastic_molten",
    [-140181365] = "plastic_red_molten",
    [-1515903371] = "poison",
    [-1526028939] = "radioactive_liquid",
    [-1515870811] = "rocket_particles",
    [-446549595] = "slime",
    [-148069044] = "slime_green",
    [-1515879051] = "slush",
    [-16109777] = "swamp",
    [-1526687067] = "urine",
    [-16777216] = "void_liquid",
    [-10919369] = "water",
    [-9870793] = "water_ice",
    [-11766481] = "water_salt",
    [-13871825] = "water_swamp",
    [-11578065] = "water_temp",
    [-1267107419] = "wax_molten",
  }
  --[[ local a = bit.rshift(bit.band(0xff000000, color), 24)
  local b = bit.rshift(bit.band(0x00ff0000, color), 16)
  local g = bit.rshift(bit.band(0x0000ff00, color), 8)
  local r = bit.band(0x000000ff, color) ]]

  return t[color]
end

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
      local liquid_color = GameGetPotionColorUint(active_item)
      local material_name = color_to_material(liquid_color)
      local amount = ComponentGetValueInt(material_sucker_component, "mAmountUsed")
      if amount > 800 then
        feed_anvil(anvil_id, "potion", active_item, material_name)
      end
    end
  end
end
