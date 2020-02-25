dofile_once("data/scripts/lib/coroutines.lua")
-- dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local sprite_component = EntityGetFirstComponent(entity_id, "SpriteComponent")

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
    ComponentSetValue(sprite_component, "rect_animation", v.number)
    ComponentSetValue(sprite_component, "alpha", 1)

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
