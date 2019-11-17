local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

frame = (frame or 0) + 1

EntitySetTransform(entity_id, x, y + math.sin(frame * 0.05) * 0.05)
