-- Necessary to differentiate between items that use the same physics image
local check_material = {
  ["data/items_gfx/goldnugget_01.png"] = true,
  ["data/items_gfx/goldnugget_9px.png"] = true,
}

local by_physics_image = {
  ["data/items_gfx/broken_wand.png"] = { "wand", "data/entities/items/wand_unshuffle_02.xml" },
  ["data/items_gfx/brimstone.png"] = { "potion", "liquid_fire" },
  ["data/items_gfx/runestones/runestone_lava.png"] = { "potion", "lava" },
  ["data/items_gfx/runestones/runestone_disc.png"] = { "potion", "runestone_disc", material = "concrete_static" },
  ["data/items_gfx/runestones/runestone_slow.png"] = { "potion", "runestone_slow", material = "cloud" },
  ["data/items_gfx/runestones/runestone_laser.png"] = { "potion", "runestone_laser", material = "spark_green_bright" },
  ["data/items_gfx/runestones/runestone_fireball.png"] = { "potion", "runestone_fireball", material = "liquid_fire" },
  ["data/items_gfx/runestones/runestone_null.png"] = { "potion", "runestone_null", material = "metal" },
  ["data/buildings_gfx/chest_random.png"] = { "potion", "chest_random", material = "gold" },
  ["data/buildings_gfx/chest_random_super.png"] = { "potion", "chest_random_super", material = "gold" },
  ["data/items_gfx/egg_hollow.png"] = { "potion", "egg", material = "purifying_powder" },
  ["data/items_gfx/egg.png"] = { "potion", "egg", material = "purifying_powder" },
  ["data/items_gfx/egg_purple.png"] = { "potion", "egg", material = "purifying_powder" },
  ["data/items_gfx/egg_red.png"] = { "potion", "egg", material = "purifying_powder" },
  ["data/items_gfx/egg_worm.png"] = { "potion", "egg", material = "purifying_powder" },
  ["data/items_gfx/egg_slime.png"] = { "potion", "egg", material = "purifying_powder" },
  ["data/items_gfx/gourd.png"] = { "potion", "gourd", material = "spark_teal" },
  ["data/items_gfx/moon.png"] = { "potion", "moon", material = "spark_white_bright" },
  ["data/props_gfx/die.png"] = { "potion", "physics_die", material = "spark_white_bright" },
  ["data/items_gfx/safe_haven.png"] = { "potion", "safe_haven", material = "spark_teal" },
  ["data/items_gfx/smallgem_03.png"] = { "potion", "thunderstone", material = "bloodgold_box2d" },
  ["data/items_gfx/waterstone.png"] = { "potion", "water" },
  ["data/items_gfx/goldnugget_01.png_gem_box2d_turquoise"] = { "potion", "wandstone", material = "spark_teal" },
  ["data/items_gfx/goldnugget_01.png_gem_box2d_white"] = { "potion", "sunseed", material = "spark_red" },
  ["data/items_gfx/goldnugget_9px.png_gem_box2d_red_float"] = { "potion", "sunstone", material = "liquid_fire_weak" },
  ["data/items_gfx/beamstone.png"] = { "potion", "beamstone", material = "spark_teal" },
  ["data/items_gfx/evil_eye.png"] = { "potion", "evil_eye", material = "spark_red" },
  ["data/items_gfx/musicstone.png"] = { "potion", "musicstone", material = "spark_teal" },
  ["data/items_gfx/orb.png"] = { "potion", "physics_gold_orb", material = "gold" },
  ["data/items_gfx/orb_greed.png"] = { "potion", "physics_gold_orb_greed", material = "spark_red" },
  ["data/props_gfx/greed_die.png"] = { "potion", "physics_greed_die", material = "magic_gas_hp_regeneration" },
  ["data/items_gfx/stonestone.png"] = { "potion", "stonestone", material = "soil" },
  ["data/items_gfx/broken_spell.png"] = { "potion", "summon_portal_broken", material = "magic_liquid_random_polymorph" },
  ["data/items_gfx/runestones/runestone_metal.png"] = { "potion", "runestone_metal", material = "metal" },
  ["data/items_gfx/key.png"] = { "potion", "key", material = "spark_teal" },
  ["data/items_gfx/kakke.png"] = { "potion", "poopstone", material = "poo" },
}

-- Build material lookup table, for instance ["key"] = "spark_teal"
material_emitter_lookup = {}
for i, v in pairs(by_physics_image) do
  if v.material then
    material_emitter_lookup[v[2]] = v.material
  end
end

function get_equivalent(item_id)
  local physics_image_shape_component = EntityGetFirstComponentIncludingDisabled(item_id, "PhysicsImageShapeComponent")
  local image_file = physics_image_shape_component and ComponentGetValue2(physics_image_shape_component, "image_file")
  if check_material[image_file] then
    local material = physics_image_shape_component and ComponentGetValue2(physics_image_shape_component, "material")
    image_file = image_file .. "_" .. CellFactory_GetName(material)
  end
  return unpack(by_physics_image[image_file] or {})
end

function register_physics_item(args)
  -- #region Parameter validation
  if type(args) ~= "table" then
    error("Expected arguments as a table.", 2)
  end

  if #args > 0 then
    error("Table should consist of key/value pairs. e.g.: physics_image_file = 'data/items_gfx/smallgem_03.png'", 2)
  end

  -- The physics image file by which it is identified
  local physics_image_file = args.physics_image_file
  if type(physics_image_file) ~= "string" then
    error("Parameter 'physics_image_file' is required and must be the path to the physics image file used by the item: PhysicsImageShapeComponent:image_file", 2)
  end

  -- What this item should count as, "potion"/effect tablet or wand
  local equivalent_type = args.type
  local valid_types = { effect = true, tablet = true, wand = true }
  if type(equivalent_type) ~= "string" or not valid_types[equivalent_type] then
    error("Parameter 'type' is required and must be one of the following: 'effect', 'tablet', 'wand'", 2)
  end

  -- Which wand entity should be fed into the anvil
  local wand_entity_file = args.wand_entity_file
  if equivalent_type == "wand" and type(wand_entity_file) ~= "string" then
    error("Parameter 'wand_entity_file' is required when type = 'wand'", 2)
  end

  -- Which effect registered with append_effect should be used
  local effect_name = args.effect_name
  if equivalent_type == "effect" and type(effect_name) ~= "string" then
    error("Parameter 'effect_name' is required when type = 'effect'", 2)
  end

  -- Which material should be used for the particle effect
  local emitter_material = args.emitter_material
  if equivalent_type == "effect" and type(emitter_material) ~= "string" then
    error("Parameter 'emitter_material' is required when type = 'effect'", 2)
  end

  -- If there are multiple items with the same physics image,
  -- we need to differentiate them by their material
  local check_physics_material = args.check_physics_material
  if check_physics_material and type(check_physics_material) ~= "boolean" then
    error("Parameter 'check_physics_material' must be a boolean (true/false)", 2)
  end

  local physics_material = args.physics_material
  if check_physics_material and type(physics_material) ~= "string" then
    error("Parameter 'physics_material' is required when check_physics_material = true", 2)
  end
  -- #endregion Parameter validation

  if check_physics_material then
    check_material[physics_image_file] = true
    physics_image_file = physics_image_file .. "_" .. physics_material
  end
  if equivalent_type == "effect" then
    equivalent_type = "potion"
  end
  by_physics_image[physics_image_file] = { equivalent_type, effect_name }
  if equivalent_type == "wand" then
    by_physics_image[physics_image_file][2] = wand_entity_file
  end
  if emitter_material then
    material_emitter_lookup[effect_name] = emitter_material
  end
end

-- Set up some dummy functions that aren't available here but in potion_bonuses.lua,
-- but will be called from the appended functions by other mods
function add_spells_to_effect() end
function append_effect() end
dofile("mods/anvil_of_destiny/files/scripts/modded_content.lua")
