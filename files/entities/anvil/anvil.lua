
function anvil_buff1(wand_id1, wand_id2, buff_amount, permaspell_count, flat_buff_amounts, shuffle, x, y)

	--[[ config_flat_buff_amounts = {
		mana_charge_speed = { min = 40, max = 60 },
		mana_max = { min = 25, max = 40 },
		reload_time = { min = 1, max = 2 }, -- Recharge time in frames
		fire_rate_wait = { min = 1, max = 2 }, -- Cast delay in frames
		spread_degrees = { min = 4, max = 8 },
	} ]]
	local new_wand_id = combine_two_wands(wand_id1, wand_id2, buff_amount, flat_buff_amounts, shuffle, x, y)
	local always_attached_spells_count = wand_get_attached_spells_count(new_wand_id)
	if permaspell_count == 1 and always_attached_spells_count == 0 then
		local level = wand_compute_level(new_wand_id)
		local random_action = get_random_action(level, 1, 1, 1, x + y)
		wand_add_spell(new_wand_id, random_action, true)
	else
		wand_remove_all_spells(new_wand_id, false, true)
	end
  return new_wand_id
end
-- Combines two wands using wand_merge, then buffs the resulting wand,
-- increases the capacity and fills it with new spells based on the input wands spell count and levels
-- Returns the entity ID of the new wand, does not EntityKill the inputs
function combine_two_wands(wand_id1, wand_id2, buff_amount, flat_buff_amounts, shuffle, x, y)
	local spells1, always_attached_spells1 = wand_get_spells(wand_id1)
	local spells2, always_attached_spells2 = wand_get_spells(wand_id2)
	local wand_id = wand_merge(wand_id1, wand_id2)
	wand_buff(wand_id, buff_amount, flat_buff_amounts, x, y) -- TODO: Seed this with something different?
	local props = wand_get_properties(wand_id)
	-- Increase slots by 1 for each 4 slots
	local capacity_old = props.gun_config.deck_capacity
	props.gun_config.deck_capacity = props.gun_config.deck_capacity + math.ceil(props.gun_config.deck_capacity / 4)
	-- Limit capacity to 26 or the old capacity, we don't want to reduce the capacity in case the wand already had more slots to begin with
	props.gun_config.deck_capacity = math.min(math.max(26, capacity_old), props.gun_config.deck_capacity)
  if not shuffle then
		props.gun_config.shuffle_deck_when_empty = "0"
	end
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

-- For testing, not done yet
function _new_anvil()
	local o = {
		wands_sacrificed = 0,
		tablets_sacrificed = 0,
		first_wand_tag = nil,
		second_wand_tag = nil
	}
	local function hide_wand() print("hiding wand") return 5 end
	o.input = function(input_type)
		if input_type == "wand" then
			print("wand detected, sacrifice + 1")
			o.wands_sacrificed = o.wands_sacrificed + 1
			local tag = hide_wand(v)
			if o.wands_sacrificed == 1 then
				o.first_wand_tag = tag
			else
				o.second_wand_tag = tag
			end
			
			if o.tablets_sacrificed <= 1 and o.wands_sacrificed == 1 then
				--EntitySetComponentsWithTagEnabled(entity_id, "emitter1", true)
				print("Powering emitter 1")
				--GamePlaySound("mods/anvil_of_destiny/audio/anvil_of_destiny.snd", "jingle", x, y)
				print("Playing jingle")
			elseif o.tablets_sacrificed == 2 and o.wands_sacrificed == 1 then
				--EntitySetComponentsWithTagEnabled(entity_id, "emitter2_powered", true)
				print("Powering emitter 2")
				--path_two(entity_id, x, y)
				print("======== path_two() ========")
			elseif o.wands_sacrificed == 2 then
				--path_one(entity_id, x, y)
				print("======== path_one() ========")
			end
		elseif input_type == "tablet" then
			if o.tablets_sacrificed < 2 then
				-- EntityKill(v)
				print("Killing tablet")
				o.tablets_sacrificed = o.tablets_sacrificed + 1
				--GamePlaySound("mods/anvil_of_destiny/audio/anvil_of_destiny.snd", "jingle", x, y)
				print("playing jingle")
			end
			if o.tablets_sacrificed == 1 then
				--EntitySetComponentsWithTagEnabled(entity_id, "emitter_base_powered_up", true)
				print("setting emitter base on")
			elseif o.tablets_sacrificed == 2 then
				if o.wands_sacrificed == 0 then
					--EntitySetComponentsWithTagEnabled(entity_id, "emitter1_powered", true)
					print("setting emitter1 powered on")
				else
					--EntitySetComponentsWithTagEnabled(entity_id, "emitter1", false)
					print("setting emitter1 off")
					--EntitySetComponentsWithTagEnabled(entity_id, "emitter1_powered", true)
					print("setting emitter1 powered on")
					--EntitySetComponentsWithTagEnabled(entity_id, "emitter2_powered", true)
					print("setting emitter2 powered on")
					--path_two(entity_id, x, y)
					print("======== path_two() ========")
				end
			elseif o.tablets_sacrificed == 3 then
				-- TODO: Explode!?
			end
		else
			error("Unknown input_type: " .. tostring(input_type))
		end
	end
	return o
end
