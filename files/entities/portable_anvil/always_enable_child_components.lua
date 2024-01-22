local entity_id = GetUpdatedEntityID()
local is_in_world = EntityGetParent(EntityGetParent(entity_id)) == 0
for i, child in ipairs(EntityGetAllChildren(entity_id) or {}) do
  if EntityGetName(child) == "outline" then
    local inherit_transform_component = EntityGetFirstComponentIncludingDisabled(child, "InheritTransformComponent")
    if inherit_transform_component then
      EntitySetComponentIsEnabled(child, inherit_transform_component, true)
    end
  elseif EntityGetName(child) == "kick_me_indicator" and is_in_world then
    for i, comp in ipairs(EntityGetComponentIncludingDisabled(child, "InheritTransformComponent") or {}) do
      EntitySetComponentIsEnabled(child, comp, true)
    end
    for i, comp in ipairs(EntityGetComponentIncludingDisabled(child, "SpriteOffsetAnimatorComponent") or {}) do
      EntitySetComponentIsEnabled(child, comp, true)
    end
    for i, comp in ipairs(EntityGetComponentIncludingDisabled(child, "SpriteComponent") or {}) do
      EntitySetComponentIsEnabled(child, comp, true)
    end
  end
end
