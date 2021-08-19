local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local effect_entity = EntityCreateNew()
EntitySetTransform(effect_entity, x, y)
EntityAddComponent2(effect_entity, "LooseGroundComponent", {
  probability=0.15,
  chunk_probability=0.05,
  collapse_images="data/procedural_gfx/collapse_small/$[0-14].png",
})
EntityAddComponent2(effect_entity, "LifetimeComponent", {
  lifetime=180,
})
