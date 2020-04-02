local wand_id = GetUpdatedEntityID()
local inventory_id = EntityGetParent(wand_id)
local player_id = EntityGetParent(inventory_id)
local game_effect_comp = GetGameEffectLoadTo(player_id, "MOVEMENT_FASTER_2X", false)
if game_effect_comp ~= nil then
  ComponentSetValue(game_effect_comp, "frames", "30")
end

print("player_id: " .. tostring(player_id))
print("game_effect_comp: " .. tostring(game_effect_comp))