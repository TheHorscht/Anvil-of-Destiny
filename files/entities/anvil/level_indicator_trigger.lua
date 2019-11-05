function get_wand_level(entity_id)
  for i=0,6 do
    if EntityHasTag(entity_id, "wand_level_"..i) then
      return i
    end
  end
end

function collision_trigger(colliding_entity_id)
  local entity_id = GetUpdatedEntityID()
  print("TRIGG")
  -- Check if it's a wand being held by the player
  if EntityHasTag(colliding_entity_id, "wand") and EntityGetParent(colliding_entity_id) ~= 0 then
    -- Show level indicator
    local level = get_wand_level(colliding_entity_id)
    local level_indicator = EntityGetFirstComponent(entity_id, "SpriteComponent", "level_indicator")
    local level_indicator_number = EntityGetFirstComponent(entity_id, "SpriteComponent", "level_indicator_number")
    print("wand_level: " .. level)
    ComponentSetValue(level_indicator, "visible", "1")
    ComponentSetValue(level_indicator_number, "visible", "1")
    ComponentSetValue(level_indicator_number, "rect_animation", tostring(level))
  end
end
