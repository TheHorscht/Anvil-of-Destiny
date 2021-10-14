dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/lib/mod_settings.lua")

local mod_id = "anvil_of_destiny"
mod_settings_version = 1

local function get_setting_id(name)
	return mod_id .. "." .. name
end

local function format_fn_occurence(val)
	return string.format("%.f%%", val * 100)
end

local function format_fn_buffamount(val)
	return string.format("%.1f", val)
end

local settings = {
	{
		type = "group",
		label = "Occurance chances per 512x512 area (on average, not guaranteed)",
		description = [[Why such a small upper limit?
Because for higher values I would have to
overwrite the biome files and make my mod
incompatible with world altering mods.
This is the highest it can get without
breaking compatibility.]],
		items = {
			{
				id = "room_occurences_coalmine",
				label = "Mines", --"$biome_coalmine",
				description = "",
				value_default = 0.0875, -- 0.0875
				value_min = 0.0,
				value_max = 0.215,
				value_display_multiplier = 100.0,
				value_display_formatting = "",
				format_fn = format_fn_occurence,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "room_occurences_excavationsite",
				label = "$biome_excavationsite",
				description = "",
				value_default = 0.065, -- 0.08125
				value_min = 0.0,
				value_max = 0.10,
				value_display_multiplier = 1.0,
				value_display_formatting = "",
				format_fn = format_fn_occurence,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "room_occurences_snowcave",
				label = "$biome_snowcave",
				description = "",
				value_default = 0.065, -- 0.04
				value_min = 0.0,
				value_max = 0.09,
				value_display_multiplier = 1.0,
				value_display_formatting = "",
				format_fn = format_fn_occurence,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "room_occurences_snowcastle",
				label = "$biome_snowcastle",
				description = "",
				value_default = 0.065, -- 0.08571428571428571428571428571429
				value_min = 0.0,
				value_max = 0.16,
				value_display_multiplier = 1.0,
				value_display_formatting = "",
				format_fn = format_fn_occurence,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "room_occurences_rainforest",
				label = "$biome_rainforest",
				description = "",
				value_default = 0.05, -- 0.4615384615384615384615384615385
				value_min = 0.0,
				value_max = 0.15,
				value_display_multiplier = 1.0,
				value_display_formatting = "",
				format_fn = format_fn_occurence,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "room_occurences_vault",
				label = "$biome_vault",
				description = "",
				value_default = 0.06, -- 0.0625
				value_min = 0.0,
				value_max = 0.15,
				value_display_multiplier = 1.0,
				value_display_formatting = "",
				format_fn = format_fn_occurence,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "room_occurences_crypt",
				label = "$biome_crypt",
				description = "",
				value_default = 0.06, -- 0,05952380952380952380952380952381
				value_min = 0.0,
				value_max = 0.11,
				value_display_multiplier = 1.0,
				value_display_formatting = "",
				format_fn = format_fn_occurence,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "room_occurences_pyramid",
				label = "$biome_pyramid",
				description = "",
				value_default = 0.1, -- 0.125
				value_min = 0.0,
				value_max = 0.11,
				value_display_multiplier = 1.0,
				value_display_formatting = "",
				format_fn = format_fn_occurence,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "room_occurences_volcanobiome",
				label = "VolcanoBiome (Mod)",
				description = "",
				value_default = 0.065, -- 0,08333333333333333333333333333333
				value_min = 0.0,
				value_max = 0.11,
				value_display_multiplier = 1.0,
				value_display_formatting = "",
				format_fn = format_fn_occurence,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
		},
	},
	{
		type = "group",
		label = "Buff amount",
		description = "These values don't have any particular scale",
		offset = 44,
		items = {
			{
				id = "buff_amount",
				label = "2 wands",
				description = "",
				value_default = 0.5,
				value_min = 0.0,
				value_max = 5.0,
				value_display_multiplier = 100.0,
				value_display_formatting = "",
				format_fn = format_fn_buffamount,
				scope = MOD_SETTING_SCOPE_RUNTIME,
			},
			{
				id = "buff_amount_special",
				label = "2 tablets",
				description = "",
				value_default = 0.8,
				value_min = 0.0,
				value_max = 5.0,
				value_display_multiplier = 100.0,
				value_display_formatting = "",
				format_fn = format_fn_buffamount,
				scope = MOD_SETTING_SCOPE_RUNTIME,
			},
		},
	},
	{
		id = "reduce_one_stat",
		label = "Reduce one stat",
		description = "This is for balance and more interesting random results. When merging two wands, will reduce one of the stats at random, otherwise the buff might be too good.",
		value_default = true,
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "reusable",
		label = "Anvil reusable",
		description = "Makes the anvil reusable by resetting it after picking up the reward",
		value_default = false,
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "fog_of_war_hole",
		label = "Shine through fog of war",
		description = "The light of the anvil will shine lightly through unexplored areas, making it easier to find.",
		value_default = false,
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "allow_wand_editing",
		label = "Enable wand editing",
		description = "Let's you tinker with your wands while being near the anvil.",
		value_default = false,
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
}

function ModSettingsGuiCount()
	return 1
end

function ModSettingsUpdate(init_scope)
	local function set_defaults(setting)
		if setting.type == "group" then
			for i, item in ipairs(setting.items) do
				set_defaults(item)
			end
		else
			if setting.value_default ~= nil then
				ModSettingSetNextValue(get_setting_id(setting.id), setting.value_default, true)
			end
		end
	end
	local function save_setting(setting)
		if setting.type == "group" then
			for i, item in ipairs(setting.items) do
				save_setting(item)
			end
		elseif setting.id ~= nil and setting.scope ~= nil and setting.scope >= init_scope then
			local next_value = ModSettingGetNextValue(get_setting_id(setting.id))
			if next_value ~= nil then
				ModSettingSet(get_setting_id(setting.id), next_value)
			end
		end
	end
	for i, setting in ipairs(settings) do
		set_defaults(setting)
		save_setting(setting)
	end
	ModSettingSet(get_setting_id("_version"), mod_settings_version)
end

function ModSettingsGui( gui, in_main_menu )
	local id = 0
	local function get_id()
		id = id + 1
		return id
	end

	for i, setting in ipairs(settings) do
		if setting.type == "group" then
			GuiOptionsAddForNextWidget(gui, GUI_OPTION.DrawSemiTransparent)
			-- GuiText(gui, 0, 0, "--- " .. setting.label .. " " .. ("-"):rep(50))
			GuiText(gui, 0, 0, setting.label)
			if setting.description then
				GuiTooltip(gui, setting.description, "")
			end
			GuiLayoutBeginHorizontal(gui, 0, 0)
			local offset = setting.offset or 0

			-- Render labels
			GuiLayoutBeginVertical(gui, 0, 0)
			for i, setting in ipairs(setting.items) do
				GuiText(gui, 0, 0, setting.label)
			end
			GuiLayoutEnd(gui)

			-- Render sliders
			GuiLayoutBeginVertical(gui, 0, 0)
			for i, setting in ipairs(setting.items) do
				local next_value = ModSettingGetNextValue(get_setting_id(setting.id))
				local new_value = GuiSlider(gui, get_id(), 10 + offset, 2, "", next_value, setting.value_min, setting.value_max, setting.value_default, setting.value_display_multiplier, " " or setting.value_display_formatting, 80)
				GuiLayoutAddVerticalSpacing(gui, 1)
				if new_value ~= next_value then
					ModSettingSetNextValue(get_setting_id(setting.id), new_value, false)
				end
			end
			GuiLayoutEnd(gui)

			-- Render values
			GuiLayoutBeginVertical(gui, 0, 0)
			for i, setting in ipairs(setting.items) do
				local next_value = ModSettingGetNextValue(get_setting_id(setting.id))
				GuiText(gui, offset + 30, 0, setting.format_fn and setting.format_fn(next_value) or tostring(next_value))
			end
			GuiLayoutEnd(gui)

			GuiLayoutEnd(gui)
			-- Need to do this because the game doesn't count how many items are in the vertical group
			for i=2, #setting.items do
				GuiText(gui, 0, 0, " ")
			end
			-- A little margin at the bottom before the next group or items
			GuiLayoutAddVerticalSpacing(gui, 5)
		else
			if type(setting.value_default) == "boolean" then
				local next_value = ModSettingGetNextValue(get_setting_id(setting.id))
				local text = setting.label .. ": " .. GameTextGet(next_value and "$option_on" or "$option_off")
				local clicked, right_clicked = GuiButton(gui, 0, 0, text, get_id())
				if setting.description then
					GuiTooltip(gui, setting.description, "")
				end
				if clicked then
					ModSettingSetNextValue(get_setting_id(setting.id), not next_value, false)
				end
				if right_clicked then
					ModSettingSetNextValue(get_setting_id(setting.id), setting.value_default, false)
				end
			elseif type(setting.value_default) == "number" then
				local next_value = ModSettingGetNextValue(get_setting_id(setting.id))
				local new_value = GuiSlider(gui, get_id(), 0, 0, setting.label, next_value, setting.value_min, setting.value_max, setting.value_default, setting.value_display_multiplier, setting.value_display_formatting, 80)
				if new_value ~= next_value then
					ModSettingSetNextValue(get_setting_id(setting.id), new_value, false)
				end
			end
		end
	end
end
