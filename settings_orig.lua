dofile("data/scripts/lib/mod_settings.lua") -- see this file for documentation on some of the features.

-- This file can't access other files from this or other mods in all circumstances.
-- Settings will be automatically saved.

function mod_setting_bool_custom( mod_id, gui, in_main_menu, im_id, setting )
	local value = ModSettingGetNextValue( mod_setting_get_id(mod_id,setting) )
	local text = setting.ui_name .. " - " .. GameTextGet( value and "$option_on" or "$option_off" )

	if GuiButton( gui, 0, 0, text, im_id ) then
		ModSettingSetNextValue( mod_setting_get_id(mod_id,setting), not value, false )
	end

	mod_setting_tooltip( mod_id, gui, in_main_menu, setting )
end

function mod_setting_change_callback( mod_id, gui, in_main_menu, setting, old_value, new_value  )
	print( tostring(new_value) )
end

function make_title(s)
	return {
		not_setting = true,
		ui_fn = function(mod_id, gui, in_main_menu, im_id, setting)
			GuiLayoutAddVerticalSpacing(gui, 4)
			GuiTextCentered(gui, 150, 0, "---- " .. s .. " ----")
			GuiLayoutAddVerticalSpacing(gui, 4)
		end
	}
end

local mod_id = "example" -- This should match the name of your mod's folder.
mod_settings_version = 1 -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value. 
mod_settings = 
{
	make_title("Occurance chances"),
	{
		id = "room_occurences_coalmine",
		ui_name = "Mines", --"$biome_coalmine",
		ui_description = "",
		value_default = 0.7,
		value_min = 0.0,
		value_max = 1.3,
		value_display_multiplier = 1.0,
		value_display_formatting = "",
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
	{
		id = "room_occurences_excavationsite",
		ui_name = "$biome_excavationsite",
		ui_description = "",
		value_default = 1.3,
		value_min = 0.0,
		value_max = 1.64,
		value_display_multiplier = 1.0,
		value_display_formatting = "",
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
	{
		id = "room_occurences_snowcave",
		ui_name = "$biome_snowcave",
		ui_description = "",
		value_default = 1.2,
		value_min = 0.0,
		value_max = 2.73,
		value_display_multiplier = 1.0,
		value_display_formatting = "",
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
	{
		id = "room_occurences_snowcastle",
		ui_name = "$biome_snowcastle",
		ui_description = "",
		value_default = 1.2,
		value_min = 0.0,
		value_max = 2.26,
		value_display_multiplier = 1.0,
		value_display_formatting = "",
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
	{
		id = "room_occurences_rainforest",
		ui_name = "$biome_rainforest",
		ui_description = "",
		value_default = 1.2,
		value_min = 0.0,
		value_max = 3.99,
		value_display_multiplier = 1.0,
		value_display_formatting = "",
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
	{
		id = "room_occurences_vault",
		ui_name = "$biome_vault",
		ui_description = "",
		value_default = 2.0,
		value_min = 0.0,
		value_max = 4.91,
		value_display_multiplier = 1.0,
		value_display_formatting = "",
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
	{
		id = "room_occurences_crypt",
		ui_name = "$biome_crypt",
		ui_description = "",
		value_default = 2.5,
		value_min = 0.0,
		value_max = 4.74,
		value_display_multiplier = 1.0,
		value_display_formatting = "",
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
	{
		id = "room_occurences_volcanobiome",
		ui_name = "VolcanoBiome (Mod)",
		ui_description = "",
		value_default = 3.5,
		value_min = 0.0,
		value_max = 4.74,
		value_display_multiplier = 1.0,
		value_display_formatting = "",
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
	make_title("Misc"),
	{
		id = "buff_amount",
		ui_name = "Buff amount",
		ui_description = "How much stronger the result of 2 wand combining is",
		value_default = 0.5,
		value_min = 0.0,
		value_max = 2.0,
		value_display_multiplier = 100.0,
		value_display_formatting = "",
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "buff_amount_improved",
		ui_name = "Buff amount with 2 tablets",
		ui_description = "",
		value_default = 0.8,
		value_min = 0.0,
		value_max = 3.0,
		value_display_multiplier = 100.0,
		value_display_formatting = "",
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "reusable",
		ui_name = "Reusable",
		ui_description = "Makes the anvil reusable by resetting it after picking up the reward",
		value_default = false,
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
}

-- This function is called to ensure the correct setting values are visible to the game. your mod's settings don't work if you don't have a function like this defined in settings.lua.
function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id ) -- This can be used to migrate some settings between mod versions.
	mod_settings_update( mod_id, mod_settings, init_scope )
end

-- This function should return the number of visible setting UI elements. 
-- Your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
-- If your mod changes the displayed settings dynamically, you might need to implement custom logic for this function.
function ModSettingsGuiCount()
	if (not DebugGetIsDevBuild()) then
		return 0
	end

	return mod_settings_gui_count( mod_id, mod_settings )
end

-- This function is called to display the settings UI for this mod. your mod's settings wont be visible in the mod settings menu if this function isn't defined correctly.
function ModSettingsGui( gui, in_main_menu )
	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )
end
