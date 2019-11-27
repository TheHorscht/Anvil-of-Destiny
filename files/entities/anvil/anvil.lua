dofile("data/scripts/lib/utilities.lua")
dofile("data/scripts/gun/gun_actions.lua")
-- TODO: make this local again
EZWand = dofile("mods/anvil_of_destiny/lib/EZWand/EZWand.lua")
-- This gets called by path_one
function anvil_buff1(wand_id1, wand_id2, buff_amount, attach_spells_count, seed_x, seed_y)
	local wand1 = EZWand(wand_id1)
	local wand2 = EZWand(wand_id2)
	local new_wand = wand_merge(wand1, wand2)
	SetRandomSeed(seed_x, seed_y)
	local spell_stats = get_wand_average_spell_count_and_spell_level(wand1, wand2)
	
	wand_fill_with_semi_random_spells(new_wand,
		spell_stats.average_spell_count + Random(-1, 1) * math.floor(spell_stats.average_spell_count / 4),
		spell_stats.average_attached_spell_count,
		spell_stats.average_spell_level,
		spell_stats.average_attached_spell_level,
		seed_x, seed_y)

	buff_wand(new_wand, buff_amount, true)

	for i=1,attach_spells_count do
		local level = wand_compute_level(new_wand.entity_id)
		local action_type = get_random_action_type(8, 1, 2, Random()*100, Random()*100, Random()*100)
		local action = GetRandomActionWithType(Random()*100, Random()*100, level, action_type, Random()*100)
		new_wand:AttachSpells(action)
	end

	new_wand:UpdateSprite()

  return new_wand.entity_id
end
-- Merges two wands by averaging their stats
function wand_merge(wand1, wand2)
	local new_wand = EZWand{
		shuffle = randround((wand1.shuffle + wand2.shuffle) / 2),
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
-- Returns roughly the level of a wand
function wand_compute_level(wand_id)
	local wand = EZWand(wand_id)
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
	local recharge_time = wand.rechargeTime
	if mana_max > recharge_time * 20 then
		-- it's a "slow loader" wand, convert it back to a normal wand
		recharge_time = recharge_time * 5
		mana_max = mana_max / 3
	end
	-- Clamp the max level to 6 for now
	return math.min(6, math.ceil(recharge_time / 55))
end
-- Returns a spells average "level" based on spawn_level, which is the level of wands it can spawn in, for instance "3,4,5"
function action_get_level(action)
	local levels = string_split(action.spawn_level, ",")
	local avg = math.ceil(math_average(levels))
	return math.min(6, math.max(1, avg))
end
-- Fills a wand with spells that aren't too chaotic, based on level and "controlled" randomness
-- wand_fill_with_semi_random_spells(new_wand, spells_to_add_count, attached_spells_to_add_count, average_spell_level, average_attached_spells_level)
function wand_fill_with_semi_random_spells(wand, spells_count, attached_spells_count, spells_level, attached_spells_level, seed_x, seed_y)
	spells_count = math.min(wand.capacity, spells_count)
	SetRandomSeed(seed_x, seed_y)
  for i=1, attached_spells_count do
		local action_type = get_random_action_type(8, 2, 2, Random()*100, Random()*100, Random()*100)
		local action = GetRandomActionWithType(Random()*100, Random()*100, attached_spells_level, action_type, i)
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
  local guaranteed_projectile_index = 50--Random(1, spells_count)
  for i=1, spells_count do
		-- Give the wand at least one projectile it has enough mana to cast
		if i == guaranteed_projectile_index then
			action = GetRandomActionWithType(seed_x, seed_y, randomly_alter_level(spells_level), ACTION_TYPE_PROJECTILE, Random()*100)
			-- Check if wand has enough max mana to cast it
			local action_info = action_get_by_id(action)
			-- Try a maximum of 5 times to get a projectile that the wand has enough mana for
			for i=1,5 do
				if action_info.mana < wand.manaMax then
					-- Has enough mana, we're done
					break
				end
				-- If not then reroll with lower level
				action = GetRandomActionWithType(seed_x, seed_y, randomly_alter_level(spells_level-(i-1)), ACTION_TYPE_PROJECTILE, Random()*100)
			end
		elseif action == nil or action_type ~= ACTION_TYPE_PROJECTILE or Random() > 0.7 then
			-- Repeat some projectiles based on RNG so that we neither get a chaotic array of spells nor the same ones over and over
			action_type = get_random_action_type(8, 2, 2, Random()*100, Random()*100, Random()*100)
			action = GetRandomActionWithType(Random()*100, Random()*100, randomly_alter_level(spells_level), action_type, i)
		end
    wand:AddSpells(action)
  end
end

function get_random_action_type(chance_projectile, chance_modifier, chance_draw_many, seed_x, seed_y, seed_z)
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

function buff_wand(wand, buff_amount, reduce_one_stat)
	local rng = create_normalized_random_distribution(3, 0.1)
	-- one of castDelay rechargeTime or spread should get nerfed, the other 2 buffed
	local randIndex = Random(1, #rng)
	if reduce_one_stat then
		rng[randIndex] = rng[randIndex] * -1
	end
	-- Diminishes the bonus by scale if it's above threshold
	local function limit_buff(value, threshold, scale)
		if value > threshold then
			value = threshold + value * scale
		end
		return value
	end
	wand.manaChargeSpeed = wand.manaChargeSpeed + Random(40, 55) * buff_amount
	local bonus_mana = wand.manaMax * (1.05 + Random() * 0.1) * buff_amount
	wand.manaMax = wand.manaMax + limit_buff(bonus_mana, 50, 0.2)
	local function apply_buff_percent(value, max_change, direction, buff_amount)
		return value + max_change * direction * buff_amount
	end

	wand.castDelay = wand.castDelay - math.ceil(10 * rng[1] * buff_amount)
	wand.rechargeTime = wand.rechargeTime - math.ceil(10 * rng[2] * buff_amount)
	wand.spread = wand.spread - 15 * rng[3] * buff_amount

	local old_capacity = wand.capacity
	local rand = Random()
	-- Wands with higher capacity have a higher chance of getting more slots
	rand = rand - (wand.capacity * wand.capacity / 2000)
	if rand < 0.03 then
		wand.capacity = wand.capacity + 4
	elseif rand < 0.10 then
		wand.capacity = wand.capacity + 3
	elseif rand < 0.25 then
		wand.capacity = wand.capacity + 2
	elseif rand < 0.35 then
		wand.capacity = wand.capacity + 1
	elseif rand < 0.70 and wand.capacity > 1 then
		wand.capacity = wand.capacity - 1
	elseif rand < 0.90 and wand.capacity > 2 then
		wand.capacity = wand.capacity - 2
	end
	-- Limit capacity to 26 but not if the old capacity is higher, we don't want to reduce it
	wand.capacity = math.max(old_capacity, math.min(26, wand.capacity))
end
