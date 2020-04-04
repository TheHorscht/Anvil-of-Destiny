local wand_id = GetUpdatedEntityID()
local inventory_id = EntityGetParent(wand_id)
local player_id = EntityGetParent(inventory_id)
if player_id > 0 then
  local game_effect_comp = GetGameEffectLoadTo(player_id, "MOVEMENT_FASTER_2X", false)
  if game_effect_comp > 0 then
    local duration = Random(60 * 3, 60 * 10) -- 3 to 10 seconds
    ComponentSetValue(game_effect_comp, "frames", tostring(duration))
    local component_id = GetUpdatedComponentID()
    ComponentSetValue(component_id, "execute_every_n_frame", tostring(duration + Random(60 * 10, 60 * 30))) -- 10 to 30 seconds
  end
end
