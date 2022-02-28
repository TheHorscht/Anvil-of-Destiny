local gui = GuiCreate()

local function get_direction( x1, y1, x2, y2 )
	return math.atan2( ( y2 - y1 ), ( x2 - x1 ) )
end

return function(dest_x, dest_y)
  local entity_name = "__debug_arrow"
  local arrow_entity = EntityGetWithName(entity_name)
  if arrow_entity == 0 then
    arrow_entity = EntityCreateNew(entity_name)
    EntityAddComponent2(arrow_entity, "SpriteComponent", {
      image_file = "mods/anvil_of_destiny/files/arrow.png",
      offset_x = 32,
      ui_is_parent = true,
    })
  end
  GuiStartFrame(gui)
  local screen_width, screen_height = GuiGetScreenDimensions(gui)
  local cx, cy = GameGetCameraPos() 
  local dir = get_direction(cx, cy, dest_x, dest_y)
  local rot = dir + math.pi/2
  local scale_x, scale_y = 1, 1
  dest_x = math.min(screen_width * 2, math.max(0, (dest_x - cx) * 2 + screen_width))
  dest_y = math.min(screen_height * 2, math.max(0, (dest_y - cy) * 2 + screen_height))
  EntitySetTransform(arrow_entity, dest_x, dest_y, rot, scale_x, scale_y)
end
