local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local sprite_component = EntityGetComponent(entity_id, "SpriteComponent")
if sprite_component ~= nil and sprite_component[1] ~= nil then
  local alpha = ComponentGetValue(sprite_component[1], "alpha")
  if alpha ~= nil then
    alpha = tonumber(alpha)
  end
  ComponentSetValue(sprite_component[1], "alpha", alpha - 0.016666666)
end
