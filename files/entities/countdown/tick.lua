dofile_once("data/scripts/lib/coroutines.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

async(function()
  local sequence = {
    { number=1, delay=0 },
    { number=2, delay=0 },
    { number=5, delay=0 },
    { number=3, delay=45 },
  }
  for i, v in ipairs(sequence) do
    if v.delay > 0 then
      wait(v.delay)
    end
    local sprite_components = EntityGetComponent(entity_id, "SpriteComponent") or {}
    for i, comp in ipairs(sprite_components) do
      EntityRemoveComponent(entity_id, comp)
    end
    local sprite_component = EntityAddComponent2(entity_id, "SpriteComponent", {
      image_file="data/fonts/font_pixel_white.xml",
      is_text_sprite=true,
      has_special_scale=true,
      offset_x=1.8,
      offset_y=3,
      special_scale_x=2,
      special_scale_y=2,
      update_transform=true,
      update_transform_rotation=false,
      text=tostring(v.number),
      z_index=-9999,
      alpha=1,
    })
    if v.number == 5 then
      GamePlaySound("mods/anvil_of_destiny/audio/anvil_of_destiny.snd", "tick_high", x, y)
    else
      GamePlaySound("mods/anvil_of_destiny/audio/anvil_of_destiny.snd", "tick_low", x, y)
    end

    local alpha = ComponentGetValue(sprite_component, "alpha")
    while tonumber(alpha) > 0 do
      wait(1)
      alpha = ComponentGetValue(sprite_component, "alpha")
      alpha = tonumber(alpha)
      ComponentSetValue(sprite_component, "alpha", alpha - 0.035)
    end
    ComponentSetValue(sprite_component, "alpha", 0)
  end
end)
