-- An idea for showing wand levels in the inventory next to "WAND"
-- Would be placed in init.lua

local gui

function OnPlayerSpawned(player_entity)
  if not gui then
		gui = GuiCreate()
	end	
end

function OnWorldPostUpdate() 
	-- if _cheat_gui_main then _cheat_gui_main() end
	-- Player::SpriteComponent with tag aiming_reticle
	local player_id = EntityGetWithTag("player_unit")[1]
	local aiming_reticle = EntityGetFirstComponent(player_id, "SpriteComponent", "aiming_reticle")
	local alpha = ComponentGetValue(aiming_reticle, "alpha")
	local is_inventory_open = alpha == "0"
	local wand_positions = {
		55,
		55 + 73.5,
		55 + 73.5 * 2,
		55 + 73.5 * 3 + 1
	}
	-- loop through children to find wands
	-- EntityGetAllChildren
	if is_inventory_open then
		GuiStartFrame(gui)
		--GuiLayoutBeginHorizontal(gui, 0, 0)
		GuiText(gui, 57, wand_positions[1], "LEVEL 1")
		GuiText(gui, 57, wand_positions[2], "LEVEL 2")
		GuiText(gui, 57, wand_positions[3], "LEVEL 3")
		GuiText(gui, 57, wand_positions[4], "LEVEL 4")
		--GuiLayoutEnd(gui)
	end
end
