local entity_id = GetUpdatedEntityID()
local component_id = GetUpdatedComponentID()

local function smoothstep(edge0, edge1, x)
	x = math.max(0, math.min((x - edge0) / (edge1 - edge0), 1))
	return x * x * (3 - 2 * x)
end

local img_w, img_h = 600, 340
local alpha = GetValueNumber("alpha", 0)
local alpha_dir = GetValueInteger("alpha_dir", 1)
local alpha_change_speed = 1 / 60 / 60
alpha = alpha + alpha_dir * alpha_change_speed
if alpha >= 1 then
  alpha_dir = -1
  SetValueInteger("alpha_dir", alpha_dir)
elseif alpha <= 0 then
  alpha_dir = 1
  SetValueInteger("alpha_dir", alpha_dir)
  GuiDestroy(gui)
  EntityRemoveComponent(entity_id, component_id)
  return
end
SetValueNumber("alpha", alpha)
gui = gui or GuiCreate()
GuiStartFrame(gui)
local screen_w, screen_h = GuiGetScreenDimensions(gui)
GuiOptionsAddForNextWidget(gui, 2)
local scale_x, scale_y = screen_w / img_w, screen_h / img_h
GuiImage(gui, 2, (screen_w - img_w * scale_x) / 2, (screen_h - img_h * scale_y) / 2, "mods/anvil_of_destiny/files/entities/portable_anvil/image_outline.png", smoothstep(0, 1, alpha) * 0.04, scale_x, scale_y, 0)
