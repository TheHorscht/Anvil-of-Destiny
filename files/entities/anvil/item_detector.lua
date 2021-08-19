-- Necessary to differentiate between items that use the same physics image
local check_material = {
  ["data/items_gfx/goldnugget_01.png"] = true,
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
  ["data/items_gfx/goldnugget_9px.png"] = { "potion", "sunstone", material = "liquid_fire_weak" },
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
