local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

frame = (frame or 0) + 1

EntitySetTransform(entity_id, x, y + math.sin(frame * 0.04) * 0.1)
print(math.sin(frame))
