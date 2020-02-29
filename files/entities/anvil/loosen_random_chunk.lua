local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

SetRandomSeed(GameGetFrameNum(), GameGetFrameNum())
for i=0, 2 do
  LooseChunk(x + Random(-40, 40), y + Random(-20, 20), "data/collapse_masks/small/"..Random(0, 14)..".png")
end
