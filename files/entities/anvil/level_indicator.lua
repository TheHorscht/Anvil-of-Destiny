local entity_id = GetUpdatedEntityID()
local level_indicator = EntityGetFirstComponent(entity_id, "SpriteComponent", "level_indicator")
local level_indicator_number = EntityGetFirstComponent(entity_id, "SpriteComponent", "level_indicator_number")
ComponentSetValue(level_indicator, "visible", "0")
ComponentSetValue(level_indicator_number, "visible", "0")

print("Tick")
