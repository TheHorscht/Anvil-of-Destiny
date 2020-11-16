local by_physics_image_file = {
  ["data/items_gfx/brimstone.png"] = { "potion", "liquid_fire" },
  ["data/items_gfx/runestones/runestone_lava.png"] = { "potion", "lava" },
  ["data/items_gfx/runestones/runestone_disc.png"] = { "potion", "runestone_disc" },
  ["data/items_gfx/runestones/runestone_slow.png"] = { "potion", "runestone_slow" },
  ["data/items_gfx/runestones/runestone_laser.png"] = { "potion", "runestone_laser" },
  ["data/items_gfx/runestones/runestone_fireball.png"] = { "potion", "runestone_fireball" },
  ["data/items_gfx/runestones/runestone_null.png"] = { "potion", "runestone_null" },
  ["data/buildings_gfx/chest_random.png"] = { "potion", "chest_random" },
  ["data/buildings_gfx/chest_random_super.png"] = { "potion", "chest_random_super" },
  ["data/items_gfx/egg_hollow.png"] = { "potion", "egg" },
  ["data/items_gfx/egg.png"] = { "potion", "egg" },
  ["data/items_gfx/egg_purple.png"] = { "potion", "egg" },
  ["data/items_gfx/egg_red.png"] = { "potion", "egg" },
  ["data/items_gfx/egg_spiders.png"] = { "potion", "egg" },
  ["data/items_gfx/egg_worm.png"] = { "potion", "egg" },
  ["data/items_gfx/egg_slime.png"] = { "potion", "egg" },
  ["data/items_gfx/gourd.png"] = { "potion", "gourd" },
  ["data/items_gfx/moon.png"] = { "potion", "moon" },
  ["data/props_gfx/die.png"] = { "potion", "physics_die" },
  ["data/items_gfx/safe_haven.png"] = { "potion", "safe_haven" },
  ["data/items_gfx/smallgem_03.png"] = { "potion", "thunderstone" },
  ["data/items_gfx/waterstone.png"] = { "potion", "water" },
}

material_emitter_lookup = {
  runestone_disc = "concrete_static",
  runestone_slow = "cloud",
  runestone_laser = "spark_green_bright",
  runestone_fireball = "liquid_fire",
  runestone_null = "metal",
  chest_random = "gold",
  chest_random_super = "gold",
  egg = "purifying_powder",
  gourd = "spark_teal",
  moon = "spark_white_bright",
  physics_die = "spark_white_bright",
  safe_haven = "spark_teal",
  thunderstone = "bloodgold_box2d",
}

function get_equivalent(item_id)
  -- Broken wand
  if EntityHasTag(item_id, "broken_wand") then
    return "wand", "data/entities/items/wand_unshuffle_02.xml"
  end
  local physics_image_shape_component = EntityGetFirstComponentIncludingDisabled(item_id, "PhysicsImageShapeComponent")
  local physics_image_file = physics_image_shape_component and ComponentGetValue2(physics_image_shape_component, "image_file")
  -- string.match("data/items_gfx/egg_red.png", "(egg)_.*%.png")
  return unpack(by_physics_image_file[physics_image_file] or {})
end
