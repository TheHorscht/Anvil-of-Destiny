local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

SetRandomSeed(GameGetFrameNum(), GameGetFrameNum())
-- for i=0, 3 do
--   LooseChunk(x + Random(-40, 40), y + Random(-20, 25), "data/procedural_gfx/collapse_small/"..Random(0, 14)..".png", 99999999999999999999999)
-- end

if not is_debug() then
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
end
