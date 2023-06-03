local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local sprite_component = EntityGetFirstComponentIncludingDisabled(entity_id, "SpriteComponent")

if not sprite_component then
  EntityKill(entity_id)
  return
end

-- We need to finish the bite animation if it is currently "playing"
if GetValueNumber("animation_frame", 0) == 0 then
  local image_file = ComponentGetValue2(sprite_component, "image_file")
  local animation_frame = image_file:match("anim_(%d).png")
  if not animation_frame then
    EntityKill(entity_id)
    return
  end
  SetValueNumber("animation_frame", animation_frame)
end

function set_rect_animation(animation)
  ComponentSetValue2(sprite_component, "image_file", animation)
  EntityRefreshSprite(entity_id, sprite_component)
end

local animation_frame_start = GetValueNumber("animation_frame", 0)
local frames_max = 6
local frame_delay = 4
local frame = GetValueInteger("frame", animation_frame_start * frame_delay)
if frame < frames_max * frame_delay then
  frame = (frame + 1) % (frame_delay * frames_max + 1)
  local animation_frame = math.floor(frame / frame_delay)
  if animation_frame + 1 > frames_max then
    animation_frame = 0
  end
  set_rect_animation(("mods/anvil_of_destiny/files/entities/anvil/mimic/anim_%d.png"):format(animation_frame + 1))
end

local alpha = ComponentGetValue2(sprite_component, "alpha")
alpha = alpha - 0.02
if alpha <= 0 then
  EntityKill(entity_id)
end
ComponentSetValue2(sprite_component, "alpha", alpha)
SetValueInteger("frame", frame)
