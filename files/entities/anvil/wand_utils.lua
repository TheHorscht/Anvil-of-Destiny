dofile_once("mods/anvil_of_destiny/files/scripts/utils.lua")
dofile_once("data/scripts/gun/gun_actions.lua")
local EZWand = dofile_once("mods/anvil_of_destiny/lib/EZWand/EZWand.lua")
local spells_evolutions = dofile_once("mods/anvil_of_destiny/files/scripts/spells_evolutions.lua")

-- Returns a spells average "level" based on spawn_level, which is the level of wands it can spawn in, for instance "3,4,5"
function action_get_level(action)
	if not action.spawn_level then
		return 3
	end
	local levels = string_split(action.spawn_level, ",")
	local avg = math.ceil(math_average(levels))
	return math.min(6, math.max(1, avg))
end

-- Returns roughly the level of a wand
function wand_compute_level(wand_id)
  local wand = EZWand(wand_id)
  local ui_name = ComponentGetValue2(wand.ability_component, "ui_name")
  if ui_name == "Bolt staff" or ui_name == "Bomb wand" then
    -- Starter wand
    return 0
  end
	local coalmine_wand_uniques = {
		{ "data/items_gfx/wands/wand_0484.png", "Good Rapid bolt wand" },
		{ "data/items_gfx/wands/wand_0654.png", "Good Rapid bolt wand" },
		{ "data/items_gfx/wands/wand_0958.png", "Neutral Rapid bolt wand" },
		{ "data/items_gfx/wands/wand_0516.png", "Antique Rapid bolt wand" },
		{ "data/items_gfx/wands/wand_0484.png", "Slim Rapid bolt wand" },
		{ "data/items_gfx/wands/wand_0058.png", "Superior Rapid bolt wand"},
		{ "data/items_gfx/wands/wand_0120.png", "Shiny Rapid bolt wand" },
		{ "data/items_gfx/wands/wand_0898.png", "Solid Rapid bolt wand"},
		{ "data/items_gfx/wands/wand_0724.png", "Turbo Rapid bolt wand"},
	}
	-- Check if the attributes match one of the coalmine wands, if so it's a coalmine wand, aka level 0
	for i, v in ipairs(coalmine_wand_uniques) do
		local sprite_file = ComponentGetValue(wand.ability_component, "sprite_file")
		local ui_name = ComponentGetValue(wand.ability_component, "ui_name")
		if sprite_file == v[1] and ui_name == v[2] then
			print("Coalmine wand")
			return 0
		end
	end
	-- Mana recharge goes in steps of 55
	local mana_charge_speed_thresholds = { 55, 110, 165, 220, 275, 330 }
  -- if mana max is 20x higher than charge speed, it's a "slow loader"
	local wand_level = nil
	local mana_max = wand.manaMax
	local mana_charge_speed = wand.manaChargeSpeed
	if mana_max > mana_charge_speed * 20 then
		-- it's a "slow loader" wand, convert it back to a normal wand
		mana_charge_speed = mana_charge_speed * 5
		mana_max = mana_max / 3
  elseif mana_max * 2.7 < mana_charge_speed then
    -- it's a super fast charger with low max mana
    mana_charge_speed = mana_charge_speed / 5
		mana_max = mana_max * 3
  end
	-- Clamp the max level to 6 for now
	return math.min(6, math.ceil(mana_charge_speed / 55))
end

-- Creates a new empty wand by merges two input wands by averaging their stats
function wand_merge(wand1, wand2)
	local new_wand = EZWand{
		shuffle = randround(((wand1.shuffle and 1 or 0) + (wand2.shuffle and 1 or 0)) / 2) == 1,
		spellsPerCast = randround((wand1.spellsPerCast + wand2.spellsPerCast) / 2),
		castDelay = (wand1.castDelay + wand2.castDelay) / 2,
		rechargeTime = (wand1.rechargeTime + wand2.rechargeTime) / 2,
		manaMax = randround((wand1.manaMax + wand2.manaMax) / 2),
		manaChargeSpeed = randround((wand1.manaChargeSpeed + wand2.manaChargeSpeed) / 2),
		capacity = randround((wand1.capacity + wand2.capacity) / 2),
		spread = (wand1.spread + wand2.spread) / 2,
		speedMultiplier = (wand1.speedMultiplier + wand2.speedMultiplier) / 2,
	}
	return new_wand
end

function get_average_spell_level(spells)
	local spell_levels = {}
	for i,v in ipairs(spells) do
		v.action_id = spells_evolutions.get_spell_base_id(v.action_id)
		local action = action_get_by_id(v.action_id)
		table.insert(spell_levels, action_get_level(action))
	end
	local average_spell_level = math.ceil(math_average(spell_levels))
	return average_spell_level
end

function get_wand_average_spell_count_and_spell_level(wand1, wand2)
  -- Get spells of both wands, and check their level and count, then fill the generated wand with similar spells/count/quality
	local spells1, attached_spells1 = wand1:GetSpells()
	local spells2, attached_spells2 = wand2:GetSpells()
	local all_spells = table.imerge(spells1, spells2)
	local all_attached_spells = table.imerge(attached_spells1, attached_spells2)
	local average_spell_count = randround(#all_spells / 2)
	local average_attached_spell_count = randround(#all_attached_spells / 2)
	-- Calculate the average spell level, so we can fill the resulting wand with spells of a similar level
	local average_spell_level = get_average_spell_level(all_spells)
	local average_attached_level = get_average_spell_level(all_attached_spells)

	return {
		average_spell_count = average_spell_count,
		average_spell_level = average_spell_level,
		average_attached_spell_count = average_attached_spell_count,
		average_attached_level = average_attached_level,
	}
end

-- Fills a wand with spells that aren't too chaotic, based on level and "controlled" randomness
-- wand_fill_with_semi_random_spells(new_wand, spells_to_add_count, attached_spells_to_add_count, average_spell_level, average_attached_spells_level)
function wand_fill_with_semi_random_spells(wand, spell_amount_to_add, attached_spells_count, spells_level, attached_spells_level, evo_spell_level_counts, evo_ac_spell_level_counts, seed_x, seed_y)
	spell_amount_to_add = math.min(wand.capacity - wand:GetSpellsCount(), spell_amount_to_add)
	SetRandomSeed(seed_x, seed_y)

	local function evolve_spell_if_possible(action_id, evo_spell_level_counts)
		if spells_evolutions.spell_has_evolution(action_id) then
			local spells_evolution_level = spells_evolutions.get_next_spells_evolution_level(evo_spell_level_counts)
			if spells_evolution_level then
				action_id = spells_evolutions.upgrade_to_spells_evolution_level(action_id, spells_evolution_level)
			end
		end
		return action_id
	end

  for i=1, attached_spells_count do
		local action_type = get_random_action_type(8, 2, 2)
		local action = GetRandomActionWithType(seed_x + i, seed_y - i, attached_spells_level, action_type, i)
		action = evolve_spell_if_possible(action, evo_ac_spell_level_counts)
    wand:AttachSpells(action)
	end
	-- This is so we get more variety, which might be interesting
	local function randomly_alter_level(level)
		if Random() < 0.1 then
			level = level - 1
		elseif Random() < 0.1 then
			level = level + 1
		end
		return math.min(6, math.max(1, level))
	end

	local action = nil
	local action_type = nil
  local guaranteed_projectile_index = Random(1, spell_amount_to_add)
  for i=1, spell_amount_to_add do
		-- Give the wand at least one projectile it has enough mana to cast
		if i == guaranteed_projectile_index then
			action = GetRandomActionWithType(seed_x + i, seed_y - i, randomly_alter_level(spells_level), ACTION_TYPE_PROJECTILE, Random(500,999))
			-- Check if wand has enough max mana to cast it
			local action_info = action_get_by_id(action)
			-- Try a maximum of 5 times to get a projectile that the wand has enough mana for
			for i=1,10 do
				if action_info.mana < wand.manaMax then
					-- Has enough mana, we're done
					break
				end
				-- If not then reroll with lower level
				action = GetRandomActionWithType(seed_x + i, seed_y - i, randomly_alter_level(spells_level-(i-1)), ACTION_TYPE_PROJECTILE, Random(500,999))
				action_info = action_get_by_id(action)
			end
		elseif action == nil or action_type ~= ACTION_TYPE_PROJECTILE or Random() > 0.7 then
			-- Repeat some projectiles based on RNG so that we neither get a chaotic array of spells nor the same ones over and over
			action_type = get_random_action_type(8, 2, 2)
			action = GetRandomActionWithType(seed_x + i, seed_y - i, randomly_alter_level(spells_level), action_type, i)
		end
		-- (Spells Evolution Mod) Upgrade the projectile if there were any evolved spells
		local evolved_action = evolve_spell_if_possible(action, evo_spell_level_counts)
    wand:AddSpells(evolved_action)
  end
end

function get_random_action_type(chance_projectile, chance_modifier, chance_draw_many)
  local rand_spell_roll = Random()
  local chances = { chance_projectile, chance_modifier, chance_draw_many }
	normalize_table(chances)
	local action_type = nil

  if rand_spell_roll < chances[1] then
		action_type = ACTION_TYPE_PROJECTILE
	elseif rand_spell_roll < chances[1] + chances[2] then
		action_type = ACTION_TYPE_MODIFIER
  else
    action_type = ACTION_TYPE_DRAW_MANY
	end

  return action_type
end

-- Returns an entry of data/scripts/gun/gun_actions.lua
function action_get_by_id(action_id)
	for i, action in ipairs(actions) do
		if (action.id == action_id) then
			return action
		end
	end
end

function action_exists(action_id)
  return action_get_by_id(action_id) ~= nil
end

-- Takes as input a table of spell IDs and filters out every spell whose level is not in the range specified
function filter_spells(spells, level_min, level_max)
	local spell_level_lookup = dofile_once("mods/anvil_of_destiny/files/scripts/spell_level_lookup.lua")
	local filtered_list = {}
	for i, spell_name in ipairs(spells) do
		if not action_exists(spell_name) then
			print("Anvil of Destiny WARNING: Spell with ID '" .. spell_name .. "' does not exist.")
		else
			for i, level in ipairs(spell_level_lookup["_" .. spell_name]) do
				if level >= level_min and level <= level_max then
					table.insert(filtered_list, spell_name)
					break
				end
			end
		end
	end
	return filtered_list
end

-- "spells" is a table of spells to potentially add, but they will get filtered by the wand level, so it will only add spells appropriate to the wand level
-- will only fill up to wand capacity
function add_spells_to_wand(wand, spells, num_spells_to_add, skip_filter)
	if not skip_filter then
		local wand_level = wand_compute_level(wand.entity_id)
		spells = filter_spells(spells, wand_level-1, wand_level+1)
	end
	local spells_count = wand:GetSpellsCount()
	local num_spells_added = 0
	while wand.capacity > spells_count and num_spells_added < num_spells_to_add do
		wand:AddSpells(spells[Random(1, #spells)])
		spells_count = spells_count + 1
		num_spells_added = num_spells_added + 1
	end
end
