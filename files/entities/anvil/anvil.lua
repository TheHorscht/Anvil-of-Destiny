

-- Combines two wands using wand_merge, then buffs the resulting wand,
-- increases the capacity and fills it with new spells based on the input wands spell count and levels
-- Returns the entity ID of the new wand, does not EntityKill the inputs
function combine_two_wands(wand_id1, wand_id2, buff_amount, x, y)
	local spells1, always_attached_spells1 = wand_get_spells(wand_id1)
	local spells2, always_attached_spells2 = wand_get_spells(wand_id2)
	local wand_id = wand_merge(wand_id1, wand_id2)
	wand_buff(wand_id, buff_amount, nil, x, y) -- TODO: Seed this with something different?
	local props = wand_get_properties(wand_id)
	-- Increase slots by 1 for each 4 slots
	local capacity_old = props.gun_config.deck_capacity
	props.gun_config.deck_capacity = props.gun_config.deck_capacity + math.ceil(props.gun_config.deck_capacity / 4)
	-- Limit capacity to 26 or the old capacity, we don't want to reduce the capacity in case the wand already had more slots to begin with
	props.gun_config.deck_capacity = math.min(math.max(26, capacity_old), props.gun_config.deck_capacity)
  -- Always turn it into a no-shuffle wand
  props.gun_config.shuffle_deck_when_empty = "0"
	wand_set_properties(wand_id, props)
	wand_remove_all_spells(wand_id, true, true)
	-- ################################
	-- ###### Add regular spells ######
	-- ################################
	local average_spell_count = math.ceil((#spells1 + #spells2) / 2)
	for i,v in ipairs(spells1) do
		table.insert(spells2, v)
	end
	-- Calculate the average spell level, so we can fill the resulting wand with spells of a similar level
	local spell_levels = {}
	for i,v in ipairs(spells2) do
		local action = action_get_by_id(v.action_id)
		table.insert(spell_levels, action_get_level(action))
	end
	local average_spell_level = math.ceil(math_average(spell_levels))
	-- For every 4 spells add one bonus spell on the house
	local spells_to_add_count = average_spell_count + math.ceil(average_spell_count / 4)
	-- Make sure we don't add more spells than capacity
	spells_to_add_count = math.min(props.gun_config.deck_capacity, spells_to_add_count)
	-- ####################################
	-- ###### Add always cast spells ######
	-- ####################################
	local average_always_cast_spell_count = (#always_attached_spells1 + #always_attached_spells2) / 2
	for i,v in ipairs(always_attached_spells1) do
		table.insert(always_attached_spells2, v)
	end
	-- Calculate the average spell level, so we can fill the resulting wand with spells of a similar level
	local always_cast_spell_levels = {}
	for i,v in ipairs(always_attached_spells2) do
		local action = action_get_by_id(v.action_id)
		table.insert(always_cast_spell_levels, action_get_level(action))
	end
	local average_always_cast_spell_level = math.ceil(math_average(always_cast_spell_levels))
	-- Make it so at odd counts of spells, we randomly round up or down
	-- e.g.: 1 always cast spell has a 50% chance of resulting in 0 or 1
	-- e.g.: 3 always cast spells have a 50% chance of resulting in 1 or 2
	local always_cast_spells_to_add_count = Random(math.floor(average_always_cast_spell_count), math.ceil(average_always_cast_spell_count))
	wand_fill_with_semi_random_spells(wand_id, spells_to_add_count, always_cast_spells_to_add_count, average_spell_level)

	return wand_id
end