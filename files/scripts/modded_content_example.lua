-- In your init.lua:
-- ModLuaFileAppend("mods/anvil_of_destiny/files/scripts/modded_content.lua", "mods/your_mod/files/aod_modded_content_append.lua")

-- If you want to add your new spells to an existing potion/item recipe
add_spells_to_effect("blood", { "WAVE_OF_AGONY", "BLOOD_BALL" })

-- If you have a custom material that you want to add an effect for, or add an effect to an existing one
-- If the effect already exists, will run all appended effects one after the other at the end of the original function
append_effect("blood", function(wand)
  wand.capacity = 66
end)
-- Potions containing new_juice will now be accepted and this effect applied
append_effect("new_juice", function(wand)
  wand.capacity = 66
end)

-- If you have a custom physics item that you want to be detected and used by the anvil
register_physics_item({
  physics_image_file = "mods/your_mod/files/super_broken_wand.png",
  type = "wand", -- effect, wand or tablet
  wand_entity_file = "data/entities/items/wand_unshuffle_06.xml"
})
register_physics_item({
  physics_image_file = "mods/your_mod/files/blood_bone.png",
  type = "effect", -- Use an existing or newly registered effect
  effect_name = "blood", -- Will use the effect of the blood potion
})
register_physics_item({
  physics_image_file = "mods/your_mod/files/ancient_tablet.png",
  type = "tablet", -- Will count this item as a tablet
})
-- When your physics item shares the same physics image as another, like the sun stone and gold nugget
-- you need to enable the additional material check to check not just the image but also material
-- so the items can be differentiated
register_physics_item({
  physics_image_file = "mods/your_mod/files/ancient_tablet.png",
  type = "tablet", -- Will count this item as a tablet
  check_physics_material = true,
  physics_material = "item_box2d_ancient_tablet",
})
