local entity_id = GetUpdatedEntityID()
if ModSettingGet("anvil_of_destiny.fog_of_war_hole") then
  local sprite_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "SpriteComponent")
  ComponentSetValue2(sprite_comp, "image_file", "mods/anvil_of_destiny/files/entities/anvil/god_rays_weak.png")
  EntityAddComponent2(entity_id, "SpriteComponent", {
    image_file="mods/anvil_of_destiny/files/entities/anvil/god_rays_weak.png",
    z_index=255,
    alpha=1.0,
    offset_x=128,
    offset_y=81,
    fog_of_war_hole=true,
  })
end
if ModSettingGet("anvil_of_destiny.allow_wand_editing") then
  local workshop_entity = EntityCreateNew()
  EntityAddTag(workshop_entity, "workshop")
  EntityAddComponent2(workshop_entity, "HitboxComponent", {
    aabb_min_x=-50,
    aabb_min_y=-30,
    aabb_max_x=50,
    aabb_max_y=50,
  })
  EntityAddComponent2(workshop_entity, "InheritTransformComponent", {})
  EntityAddChild(entity_id, workshop_entity)
end
