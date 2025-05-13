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

local languages = {
	["English"] = "en",
	["русский"] = "ru",
	["Português (Brasil)"] = "ptbr",
	["Español"] = "eses",
	["Deutsch"] = "de",
	["Français"] = "frfr",
	["Italiano"] = "it",
	["Polska"] = "pl",
	["简体中文"] = "zhcn",
	["日本語"] = "jp",
	["한국어"] = "ko",
}

local current_language = languages[GameTextGetTranslatedOrNot("$current_language")]


--To add translations, add them below the same way English (en) languages have been added.
--Translation Keys can be seen in the languages table above
local translation_strings = {
	biome = {
		en = "Occurance chances per 512x512 area (on average, not guaranteed)",
		en_desc = [[Why such a small upper limit?
Because for higher values I would have to
overwrite the biome files and make my mod
incompatible with world altering mods.
This is the highest it can get without
breaking compatibility.]],
        ru = "Шансы появления на область 512x512 (в среднем, не гарантируется)",
        ru_desc = [[Почему такой маленький лимит?
Потому что для более высоких значений
мне пришлось бы переписать файлы биомов
и сделать мой мод несовместимым с модами,
изменяющими мир.
Это самый крайний лимит,
который может быть достигнут
без нарушения совместимости.]],
		room_occurences_coalmine = {
			en = "Mines", --you can consider this an example of translations, or us getting around the fact $biome_coalmine translation is lowercase for no reason, your pick
			ru = "Шахты",
			ptbr = "Minas",
			eses = "Minas",
			de = "Minen",
			frfr = "Mines",
			it = "Miniere",
			pl = "Kopalnie",
			zhcn = "矿场", --i dont think the concept of capital letters really applies to the following languages...
			jp = "鉱山",
			ko = "광산",
		},
		room_occurences_volcanobiome = {
			en = "VolcanoBiome (Mod)",
			en_desc = "From Volcano Biome or Noitavania mods",
		},
		room_occurences_blast_pit = {
			en = "Blast Pit (Mod)",
			en_desc = "From Alternate Biomes mod",
		},
		room_occurences_floodcave = {
			en = "Aquifer (Mod)",
			en_desc = "From Alternate Biomes mod",
		},
		room_occurences_frozen_passages = {
			en = "Frozen Passages (Mod)",
			en_desc = "From Alternate Biomes mod",
		},
		room_occurences_holy_temple = {
			en = "Holy Temple (Mod)",
			en_desc = "From Alternate Biomes mod",
		},
		room_occurences_rainforest_wormy = {
			en = "Worm Tunnels (Mod)",
			en_desc = "From Alternate Biomes mod",
		},
		room_occurences_robofactory = {
			en = "The Forge (Mod)",
			en_desc = "From Alternate Biomes mod",
		},
		room_occurences_snowvillage = {
			en = "Hiisi Village (Mod)",
			en_desc = "From Alternate Biomes mod",
		},
		room_occurences_swamp = {
			en = "Underground Swamp (Mod)",
			en_desc = "From Alternate Biomes mod",
		},
	},
	buff = {
		en = "Buff amount",
		en_desc = "These values don't have any particular scale",
		ru = "Количество баффов",
		ru_desc = "Эти значения не имеют определенной шкалы",
		buff_amount = {
			en = "2 wands",
			ru = "2 жезла",
		},
		buff_amount_special = {
			ru = "2 таблички"
		},
	},

	reduce_one_stat = {
		en = "Reduce one stat",
		en_desc = "This is for balance and more interesting random results.\nWhen merging two wands, will reduce one of the stats at random, otherwise the buff might be too good.",
		ru = "Уменьшить одну стату",
		ru_desc = "Это сделано для баланса и более интересных случайных результатов.\nПри объединении двух жезлов будет случайным образом уменьшаться один из статов,\nиначе бафф может оказаться слишком хорошим.",
	},
	only_modifiers = {
		en = "Modifier-type always casts only",
		en_desc = "When using a tablet to add an always cast, will only choose from modifier type spells.",
        ru = "Всегда кастуемые заклинания - Модификаторы",
		ru_desc = "При использовании таблички\nдля добавления всегда кастуемого заклинания,\nможно выбрать только заклинания - модификаторы.",
	},
	mimic = {
		en = "Mimic",
		en_desc = "Anvil can be a mimic",
        ru = "Мимик",
		ru_desc = "Наковальня может быть мимиком",
	},
	mimic_chance = {
		en = "Mimic chance",
		en_desc = "Chance for the anvil to be a mimic.",
        ru = "Шанс на мимика",
		ru_desc = "Шанс того, что наковальня будет мимиком.",
	},
	reusable = {
		en = "Anvil reusable",
		en_desc = "Makes the anvil reusable by resetting it after picking up the reward",
		ru = "Реюз наковальни",
		ru_desc = "Делает наковальню многоразовой,\nсбросив ее после получения награды",
	},
	reusable_chance = {
		en = "Reusable chance",
		en_desc = "Chance for the anvil to be able to be used again.",
		ru = "Шанс на реюз",
		ru_desc = "Шанс на то, что наковальню можно будет использовать снова.",
	},
	destroy_potion_on_insert = {
		en = "Remove potion after use",
		en_desc = "Can be used to balance out reusable anvil,\ndoesn't leave you with an empty flask but instead\ndestroys it after pouring it's contents on the anvil.",
		ru = "Удалить зелье после использования",
		ru_desc = "Может использоваться для баланса многоразовой наковальни,\nне оставляет пустую колбу,\nа уничтожает ее после выливания содержимого на наковальню.",
	},
	destroy_potion_on_insert_chance = {
		en = "Potion removal chance",
		en_desc = "Can be used to balance out reusable anvil, doesn't leave you with an empty flask but instead destroys it after pouring it's contents on the anvil.",
		ru = "Шанс удаления зелья",
		ru_desc = "Шанс на то, что зелье будет уничтожено.",
	},
	fog_of_war_hole = {
		en = "Shine through fog of war",
		en_desc = "The light of the anvil will shine lightly through unexplored areas, making it easier to find.",
		ru = "Сияние сквозь туман войны",
		ru_desc = "Свет наковальни будет слегка освещать неизведанные места, облегчая ее поиск.",
	},
	allow_wand_editing = {
		en = "Enable wand editing",
		en_desc = "Let's you tinker with your wands while being near the anvil.",
		ru = "Включить изменение жезлов",
		ru_desc = "Позволяет изменять жезлы, находясь рядом с наковальней.",
	},
	promote_spell_to_always_cast = {
		en = "2 Tablets AC",
		en_desc = "When buffing a wand with 2 tablets (1W + 2T):\nWill promote one randomly picked spell on the wand to an always cast.",
		ru = "2 Таблички AC",
		ru_desc = "При баффе жезла 2 табличками (1Ж + 2Т),\nпревращает одно случайно выбранное заклинание на палочке в всегда кастуемое.",
	},
	portable_anvil_spawn_chance = {
		en = "Portable anvil spawn chance",
		en_desc = "The number is not a specific unit, but dependent on the total amount of items already registered.\nI recommend a value of 1, at 100 it has roughly 50% chance of spawning on a pedestal.",
		ru = "Шанс спавна переносной наковальни",
		ru_desc = "Число не является конкретной единицей,\nа зависит от общего количества уже зарегистрированных предметов.\nЯ рекомендую значение 1.",
	},
	start_with_portable_anvil = {
		en = "Start with portable anvil",
		en_desc = "You start each game with an item that lets you spawn a room with an Anvil of Destiny in it.",
		ru = "Старт с переносной наковальней",
		ru_desc = "В начале каждой игры вы получаете предмет,\nкоторый спавнит Наковальню Судьбы.",
	},
	add_anvil_to_lavalake = {
		en = "Anvil Room at Lava Lake",
		en_desc = "Adds an anvil room to the left of the lava lake.",
		ru = "Наковальня у лавового озера",
		ru_desc = "Добавляет наковальню слева от лавового озера.",
	},
	never_spawn_naturally = {
		en = "Never spawn naturally",
		en_desc = "Will never spawn anvils in the biomes,\nonly through portable anvil or at the lava lake, if the option is enabled.",
		ru = "Никогда не спаунится естественным образом",
		ru_desc = "Наковальня никогда не будет появляться в биомах,\nтолько через переносную наковальню или у лавового озера,\nесли опция включена.",
	},
}


local settings = {
	{
		type = "group",
		id = "biome",
		items = {
			{
				id = "room_occurences_coalmine", --vanilla translation for the mines is lowercase while others have proper capitalisation
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
				value_default = 0.065, -- 0,08333333333333333333333333333333
				value_min = 0.0,
				value_max = 0.11,
				value_display_multiplier = 1.0,
				value_display_formatting = "",
				format_fn = format_fn_occurence,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "room_occurences_blast_pit",
				value_default = 0.065,
				value_min = 0.0,
				value_max = 0.10, -- 0.1024
				value_display_multiplier = 1.0,
				value_display_formatting = "",
				format_fn = format_fn_occurence,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "room_occurences_floodcave",
				value_default = 0.06,
				value_min = 0.0,
				value_max = 0.64, -- 0.64631163708087
				value_display_multiplier = 1.0,
				value_display_formatting = "",
				format_fn = format_fn_occurence,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "room_occurences_frozen_passages",
				value_default = 0.065,
				value_min = 0.0,
				value_max = 0.13, -- 0.131072
				value_display_multiplier = 1.0,
				value_display_formatting = "",
				format_fn = format_fn_occurence,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "room_occurences_holy_temple",
				value_default = 0.065,
				value_min = 0.0,
				value_max = 0.26, -- 0.26328741965106
				value_display_multiplier = 1.0,
				value_display_formatting = "",
				format_fn = format_fn_occurence,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "room_occurences_rainforest_wormy",
				value_default = 0.065,
				value_min = 0.0,
				value_max = 0.15, -- 0.1536
				value_display_multiplier = 1.0,
				value_display_formatting = "",
				format_fn = format_fn_occurence,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "room_occurences_robofactory",
				value_default = 0.065,
				value_min = 0.0,
				value_max = 1.84, -- 1.8432
				value_display_multiplier = 1.0,
				value_display_formatting = "",
				format_fn = format_fn_occurence,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "room_occurences_snowvillage",
				value_default = 0.065,
				value_min = 0.0,
				value_max = 0.13, -- 0.13653333333333
				value_display_multiplier = 1.0,
				value_display_formatting = "",
				format_fn = format_fn_occurence,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
			{
				id = "room_occurences_swamp",
				value_default = 0.065,
				value_min = 0.0,
				value_max = 0.15, -- 0.1536
				value_display_multiplier = 1.0,
				value_display_formatting = "",
				format_fn = format_fn_occurence,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
		},
	},
	{
		type = "group",
		id = "buff",
		offset = 44,
		items = {
			{
				id = "buff_amount",
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
		value_default = true,
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "only_modifiers",
		value_default = false,
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "mimic",
		value_default = false,
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "mimic_chance",
		requires = { id = "mimic", value = true },
		value_default = 0.05,
		value_min = 0.0,
		value_max = 1.0,
		value_display_multiplier = 100.0,
		value_display_formatting = " $0%",
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "reusable",
		value_default = false,
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "reusable_chance",
		requires = { id = "reusable", value = true },
		value_default = 1.0,
		value_min = 0.0,
		value_max = 1.0,
		value_display_multiplier = 100.0,
		value_display_formatting = " $0%",
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "destroy_potion_on_insert",
		value_default = false,
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "destroy_potion_on_insert_chance",
		requires = { id = "destroy_potion_on_insert", value = true },
		value_default = 1.0,
		value_min = 0.0,
		value_max = 1.0,
		value_display_multiplier = 100.0,
		value_display_formatting = " $0%",
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "fog_of_war_hole",
		value_default = false,
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "allow_wand_editing",
		value_default = false,
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "promote_spell_to_always_cast",
		value_default = false,
		scope = MOD_SETTING_SCOPE_RUNTIME,
	},
	{
		id = "portable_anvil_spawn_chance",
		value_default = 0,
		value_min = 0,
		value_max = 100,
		type = "fine_tuner",
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
	{
		id = "start_with_portable_anvil",
		value_default = false,
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
	{
		id = "add_anvil_to_lavalake",
		value_default = false,
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
	{
		id = "never_spawn_naturally",
		value_default = false,
		scope = MOD_SETTING_SCOPE_NEW_GAME,
	},
}

function ModSettingsGuiCount()
	return 1
end

local function update_translations(input_settings, input_translations)
	input_settings = input_settings or settings
	input_translations = input_translations or translation_strings
	for key, setting in pairs(input_settings) do
		if input_translations[setting.id] then
			setting.label = input_translations[setting.id][current_language] or input_translations[setting.id].en or ""
			if input_translations[setting.id].en_desc and not input_translations[setting.id][current_language] then --if there is english translation but no other translation
				setting.description = input_translations[setting.id].en_desc .. string.format("\n(Missing %s translation)", GameTextGetTranslatedOrNot("$current_language"))
			else
				setting.description = input_translations[setting.id][current_language .. "_desc"] or ""
			end
		end

		if setting.items then
			update_translations(setting.items, input_translations[setting.id])
		end
	end
end

function ModSettingsUpdate(init_scope)
	current_language = languages[GameTextGetTranslatedOrNot("$current_language")]
	update_translations()

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
		if not setting.requires or (setting.requires and (ModSettingGetNextValue(get_setting_id(setting.requires.id)) == setting.requires.value)) then
			if setting.type == "group" then
				GuiOptionsAddForNextWidget(gui, GUI_OPTION.DrawSemiTransparent)
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
					local text = ("(%s) %s"):format(next_value and "*" or "  ", setting.label)
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
				elseif setting.type == "fine_tuner" then
					local next_value = ModSettingGetNextValue(get_setting_id(setting.id))
					local new_value = next_value
					GuiLayoutBeginHorizontal(gui, 0, 0)
					GuiText(gui, 0, 0, setting.label .. " ")
					if setting.description then
						GuiTooltip(gui, setting.description, "")
					end
					local function revert_to_default()
						new_value = setting.value_default or 0
					end
					local left_clicked, right_clicked = GuiButton(gui, get_id(), 0, 0, "[--]")
					if left_clicked then
						new_value = new_value - 10
					elseif right_clicked then
						revert_to_default()
					end
					local left_clicked, right_clicked = GuiButton(gui, get_id(), 0, 0, "[-]")
					if left_clicked then
						new_value = new_value - 1
					elseif right_clicked then
						revert_to_default()
					end
					new_value = math.max(setting.value_min or -999999, new_value)
					GuiText(gui, 0, 0, (" %s "):format(new_value))
					local left_clicked, right_clicked = GuiButton(gui, get_id(), 0, 0, "[+]")
					if left_clicked then
						new_value = new_value + 1
					elseif right_clicked then
						revert_to_default()
					end
					local left_clicked, right_clicked = GuiButton(gui, get_id(), 0, 0, "[++]")
					if left_clicked then
						new_value = new_value + 10
					elseif right_clicked then
						revert_to_default()
					end
					GuiLayoutEnd(gui)
					new_value = math.min(setting.value_max or 999999, new_value)
					if new_value ~= next_value then
						ModSettingSetNextValue(get_setting_id(setting.id), new_value, false)
					end
				elseif type(setting.value_default) == "number" then
					local next_value = ModSettingGetNextValue(get_setting_id(setting.id))
					local new_value = GuiSlider(gui, get_id(), 0, 0, setting.label .. " ", next_value, setting.value_min, setting.value_max, setting.value_default, setting.value_display_multiplier or 1, setting.value_display_formatting or " $0", 80)
					if new_value ~= next_value then
						ModSettingSetNextValue(get_setting_id(setting.id), new_value, false)
					end
				end
			end
		end
	end
end
