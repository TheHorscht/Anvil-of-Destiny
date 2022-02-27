dofile_once("data/scripts/lib/coroutines.lua")

local entity_id = GetUpdatedEntityID()
local player = EntityGetWithTag("player_unit")[1]
if not player then return end
local controls_comp = EntityGetComponentIncludingDisabled(player, "ControlsComponent")[1]
-- Disable the controls component so we can set the state ourself instead of it getting it from the input device
ComponentSetValue2(controls_comp, "enabled", false)
-- Just to make sure this gets re-enabled even it a bug occurs in the code after this
async(function()
  -- Wait one frame then enable it again
  wait(1)
  ComponentSetValue2(controls_comp, "enabled", true)
  EntityKill(entity_id)
end)
-- This allows us to simulate inventory scrolling
-- Thanks to Lobzyr on the Noita discord for figuring this out
ComponentSetValue2(controls_comp, "mButtonDownChangeItemR", true)
ComponentSetValue2(controls_comp, "mButtonFrameChangeItemR", GameGetFrameNum() + 1)
ComponentSetValue2(controls_comp, "mButtonCountChangeItemR", 1)
