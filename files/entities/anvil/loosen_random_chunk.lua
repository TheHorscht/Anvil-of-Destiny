local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

SetRandomSeed(GameGetFrameNum(), GameGetFrameNum())
for i=0, 3 do
  LooseChunk(x + Random(-40, 40), y + Random(-20, 25), "data/procedural_gfx/collapse_small/"..Random(0, 14)..".png")
end
