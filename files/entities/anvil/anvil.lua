dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/gun_actions.lua")
dofile_once("mods/anvil_of_destiny/lib/StringStore/stringstore.lua")
dofile_once("mods/anvil_of_destiny/lib/StringStore/noitavariablestore.lua")
dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/gun_enums.lua")
dofile_once("mods/anvil_of_destiny/config.lua")
dofile_once("mods/anvil_of_destiny/files/scripts/utils.lua")
dofile_once("mods/anvil_of_destiny/files/scripts/spawn_hammer_animation.lua")
local EZWand = dofile_once("mods/anvil_of_destiny/lib/EZWand/EZWand.lua")

-- This gets called by path_one
function anvil_buff1(wand_id1, wand_id2, buff_amount, attach_spells_count, seed_x, seed_y)
	local wand1 = EZWand(wand_id1)
	local wand2 = EZWand(wand_id2)
	local new_wand = wand_merge(wand1, wand2)
	SetRandomSeed(seed_x, seed_y)
	local spell_stats = get_wand_average_spell_count_and_spell_level(wand1, wand2)
	
	local wand1_spell_count = #wand1:GetSpells()
	local wand2_spell_count = #wand2:GetSpells()
	-- 100% of the highest spellcount wand and 50% of the lower
	local spell_count_to_add = math.max(wand1_spell_count, wand2_spell_count) + math.floor(math.min(wand1_spell_count, wand2_spell_count) / 2)
	spell_count_to_add = spell_count_to_add + Random(-1, 2)
	if spell_count_to_add <= 0 then
		spell_count_to_add = 1
	end
	wand_fill_with_semi_random_spells(new_wand,
		spell_count_to_add,
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
	local recharge_time = wand.rechargeTime
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
  local guaranteed_projectile_index = Random(1, spells_count)
  for i=1, spells_count do
		-- Give the wand at least one projectile it has enough mana to cast
		if i == guaranteed_projectile_index then
			action = GetRandomActionWithType(seed_x, seed_y, randomly_alter_level(spells_level), ACTION_TYPE_PROJECTILE, Random()*100)
			-- Check if wand has enough max mana to cast it
			local action_info = action_get_by_id(action)
			-- Try a maximum of 5 times to get a projectile that the wand has enough mana for
			for i=1,10 do
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
	wand.manaChargeSpeed = wand.manaChargeSpeed + Random(45, 60)
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
	end
	-- Limit capacity to 26 but not if the old capacity is higher, we don't want to reduce it
	wand.capacity = math.max(old_capacity, math.min(26, wand.capacity))
end

function get_state(anvil_id)
	local entity_id = anvil_id
	local state = stringstore.open_store(stringstore.noita.variable_storage_components(entity_id))
	
	if state.wands == nil then
		state.wands = 0
		state.tablets = 0
		state.potions = 0
	end

	return state
end

function set_runes_enabled(entity_id, which, enabled)
  local emitter1, emitter2
  local emitter1_powered, emitter2_powered
  local emitter_base_powered_up

  -- Find the emitters and save them into variables
  local all_components = EntityGetAllComponents(entity_id)
  local particle_emitter_components --, "ParticleEmitterComponent"
	for _, component in ipairs(all_components) do
		for k, v in pairs(ComponentGetMembers(component)) do
			if(k == "image_animation_file") then
        if v == "mods/anvil_of_destiny/files/entities/anvil/runes1.png" then
          local emitted_material_name = ComponentGetValue(component, "emitted_material_name")
          if emitted_material_name == "spark" then
            emitter1 = component
          elseif emitted_material_name == "spark_white_bright" then
            emitter1_powered = component
          end
        elseif v == "mods/anvil_of_destiny/files/entities/anvil/runes2.png" then
          local emitted_material_name = ComponentGetValue(component, "emitted_material_name")
          if emitted_material_name == "spark" then
            emitter2 = component
          elseif emitted_material_name == "spark_white_bright" then
            emitter2_powered = component
          end
        elseif v == "mods/anvil_of_destiny/files/entities/anvil/emitter.png" then
          emitter_base = component
        end
			end
		end
  end
  
  if which == "base" then
    EntitySetComponentIsEnabled(entity_id, emitter_base, enabled)
  elseif which == "emitter1" then
    EntitySetComponentIsEnabled(entity_id, emitter1, enabled)
    if enabled then
      EntitySetComponentIsEnabled(entity_id, emitter1_powered, false)
    end
  elseif which == "emitter1_powered" then
    EntitySetComponentIsEnabled(entity_id, emitter1_powered, enabled)
    if enabled then
      EntitySetComponentIsEnabled(entity_id, emitter1, false)
    end
  elseif which == "emitter2" then
    EntitySetComponentIsEnabled(entity_id, emitter2, enabled)
    if enabled then
      EntitySetComponentIsEnabled(entity_id, emitter2_powered, false)
    end
  elseif which == "emitter2_powered" then
    EntitySetComponentIsEnabled(entity_id, emitter2_powered, enabled)
    if enabled then
      EntitySetComponentIsEnabled(entity_id, emitter2, false)
    end
  else
    error("Argument 'which' is invalid.")
  end
end

function set_outline_emitter(anvil_id, enabled, values)
  local all_components = EntityGetAllComponents(anvil_id)
	for _, component in ipairs(all_components) do
		local component_members = ComponentGetMembers(component)
		for k, v in pairs(component_members) do
			if k == "image_animation_file" and
				(v == "mods/anvil_of_destiny/files/entities/anvil/outline_emitter_top.png" or
				 v == "mods/anvil_of_destiny/files/entities/anvil/outline_emitter_bottom.png") then
				EntitySetComponentIsEnabled(anvil_id, component, enabled)
				if enabled then
					for value_name, value in pairs(values) do
						ComponentSetValue(component, value_name, value)
					end
				end
			end
		end
  end
end

local spell_level_lookup = {
	BOMB={0,1,2,3,4,5,6},
	LIGHT_BULLET={0,1},
	LIGHT_BULLET_TRIGGER={0,1,2,3},
	LIGHT_BULLET_TRIGGER_2={2,3,5,6},
	LIGHT_BULLET_TIMER={1,2,3},
	BULLET={1,2,3,4,5},
	BULLET_TRIGGER={1,2,3,4,5},
	BULLET_TIMER={2,3,4,5,6},
	HEAVY_BULLET={1,2,3,4,5,6},
	HEAVY_BULLET_TRIGGER={2,3,4,5,6},
	HEAVY_BULLET_TIMER={2,3,4,5,6},
	AIR_BULLET={1,2},
	SLOW_BULLET={1,2,3,4},
	SLOW_BULLET_TRIGGER={1,2,3,4,5},
	SLOW_BULLET_TIMER={1,2,3,4,5,6},
	BLACK_HOLE={0,2,4,5},
	BLACK_HOLE_BIG={1,3,5,6},
	TENTACLE_PORTAL={1,2,3,4},
	SPITTER={0,1,2},
	SPITTER_TIMER={0,1,2,3},
	SPITTER_TIER_2={2,3,4},
	SPITTER_TIER_2_TIMER={2,3,4,5},
	SPITTER_TIER_3={3,4,5,6},
	SPITTER_TIER_3_TIMER={4,5,6},
	BUBBLESHOT={0,1,2},
	BUBBLESHOT_TRIGGER={1,2,3},
	DISC_BULLET={0,2,4},
	DISC_BULLET_BIG={0,2,4},
	BOUNCY_ORB={0,2,4},
	BOUNCY_ORB_TIMER={0,2,4},
	RUBBER_BALL={0,1,6},
	ARROW={1,2,4,5},
	LANCE={1,2,5,6},
	ROCKET={1,2,3,4,5},
	ROCKET_TIER_2={2,3,4,5,6},
	ROCKET_TIER_3={2,3,4,5,6},
	GRENADE={0,1,2,3,4},
	GRENADE_TRIGGER={0,1,2,3,4,5},
	GRENADE_TIER_2={1,2,3,4,5},
	GRENADE_TIER_3={1,2,3,4,5},
	GRENADE_ANTI={0,1,2,3,4,5},
	GRENADE_LARGE={0,1,2,3,4,5},
	MINE={1,3,4,6},
	MINE_DEATH_TRIGGER={2,6},
	PIPE_BOMB={2,3,4},
	PIPE_BOMB_DEATH_TRIGGER={2,3,4,5},
	EXPLODING_DEER={3,4,5},
	PIPE_BOMB_DETONATOR={2,3,4,5,6},
	LASER={1,2,4},
	LIGHTNING={1,2,5,6},
	DIGGER={1,2},
	POWERDIGGER={2,3,4},
	CHAINSAW={0,2},
	LUMINOUS_DRILL={0,2},
	LASER_LUMINOUS_DRILL={0,2},
	TENTACLE={3,4,5,6},
	TENTACLE_TIMER={3,4,5,6},
	HEAL_BULLET={2,3,4},
	SPIRAL_SHOT={4,5,6},
	CHAIN_BOLT={0,4,5,6},
	FIREBALL={0,3,4,6},
	METEOR={4,5,6},
	FLAMETHROWER={2,3,6},
	SLIMEBALL={0,3,4},
	DARKFLAME={3,5,6},
	PEBBLE={1,2,4,6},
	DYNAMITE={0,1,2,3,4},
	GLITTER_BOMB={0,1,2,3,4},
	BUCKSHOT={0,1,2,3,4},
	BOMB_HOLY={2,3,4,5,6},
	CRUMBLING_EARTH={2,3,4,5,6},
	SUMMON_ROCK={0,1,2,3,4,5,6},
	SUMMON_EGG={0,1,2,3,4,5,6},
	SUMMON_HOLLOW_EGG={0,1,2,3,4,5,6},
	ACIDSHOT={1,2,3,4},
	THUNDERBALL={2,4,6},
	FIREBOMB={1,2,3},
	SOILBALL={1,2,3,5},
	DEATH_CROSS={1,2,3,4,5,6},
	DEATH_CROSS_BIG={2,3,4,5,6},
	WALL_HORIZONTAL={0,1,2,4,5,6},
	WALL_VERTICAL={0,1,2,4,5,6},
	WALL_SQUARE={0,1,2,4,5,6},
	PURPLE_EXPLOSION_FIELD={0,1,2,4,5,6},
	DELAYED_SPELL={0,1,2,4,5,6},
	LONG_DISTANCE_CAST={0,1,2,4,5,6},
	TELEPORT_CAST={0,1,2,4,5,6},
	MIST_RADIOACTIVE={1,2,3,4},
	MIST_ALCOHOL={1,2,3,4},
	MIST_SLIME={1,2,3,4},
	MIST_BLOOD={1,2,3,4},
	CIRCLE_FIRE={1,2,3,4},
	CIRCLE_ACID={1,2,3,4},
	CIRCLE_OIL={1,2,3,4},
	CIRCLE_WATER={1,2,3,4},
	MATERIAL_WATER={1,2,3,4,5},
	MATERIAL_OIL={1,2,3,4,5},
	MATERIAL_BLOOD={1,2,3,4,5},
	MATERIAL_ACID={2,3,4,5,6},
	MATERIAL_CEMENT={2,3,4,5,6},
	TELEPORT_PROJECTILE={0,1,2,4,5,6},
	TELEPORT_PROJECTILE_STATIC={0,1,2,4,5,6},
	NUKE={1,5,6},
	FIREWORK={1,2,3,4,5,6},
	SUMMON_WANDGHOST={1,2,4,5,6},
	TOUCH_GOLD={1,2,3,4,5,6,7},
	TOUCH_WATER={1,2,3,4,5,6,7},
	TOUCH_OIL={1,2,3,4,5,6,7},
	TOUCH_ALCOHOL={1,2,3,4,5,6,7},
	TOUCH_BLOOD={1,2,3,4,5,6,7},
	TOUCH_SMOKE={1,2,3,4,5,6,7},
	DESTRUCTION={10},
	BURST_2={0,1,2,3,4,5,6},
	BURST_3={1,2,3,4,5,6},
	BURST_4={2,3,4,5,6},
	SCATTER_2={0,1,2},
	SCATTER_3={0,1,2,3},
	SCATTER_4={1,2,3,4,5,6},
	I_SHAPE={1,2,3,4},
	Y_SHAPE={0,1,2,3,4},
	T_SHAPE={1,2,3,4,5},
	W_SHAPE={2,3,4,5,6},
	CIRCLE_SHAPE={1,2,3,4,5,6},
	PENTAGRAM_SHAPE={1,2,3,4,5},
	SPREAD_REDUCE={1,2,3,4,5,6},
	HEAVY_SPREAD={0,1,2,4,5,6},
	RECHARGE={1,2,3,4,5,6},
	LIFETIME={1,2,3,4,5,6},
	LIFETIME_DOWN={1,2,3,4,5,6},
	MANA_REDUCE={1,2,3,4,5,6},
	GRAVITY={2,3,4,5,6},
	GRAVITY_ANTI={2,3,4,5,6},
	SINEWAVE={1,2,3,4},
	CHAOTIC_ARC={1,2,3,4},
	PINGPONG_PATH={1,2,3,4},
	AVOIDING_ARC={1,2,3,4},
	FLOATING_ARC={1,2,3,4},
	FLY_DOWNWARDS={1,3,5},
	FLY_UPWARDS={1,3,5},
	HORIZONTAL_ARC={1,3,5},
	BOUNCE={2,3,4},
	HOMING={2,3,4,5,6},
	HOMING_SHOOTER={2,3,4,5,6},
	PIERCING_SHOT={2,3,4,5,6},
	CLIPPING_SHOT={2,3,4,5,6},
	DAMAGE={1,2,3,4,5},
	CRITICAL_HIT={1,2,3,4,5},
	AREA_DAMAGE={2,3,4,5,6},
	HEAVY_SHOT={2,3,4},
	LIGHT_SHOT={2,3,4},
	KNOCKBACK={3,5},
	RECOIL={2,4},
	RECOIL_DAMPER={3,6},
	SPEED={1,2,3},
	ACCELERATING_SHOT={2,3,4},
	EXPLOSIVE_PROJECTILE={2,3,4},
	WATER_TO_POISON={2,3,4},
	BLOOD_TO_ACID={2,3,4},
	LAVA_TO_BLOOD={2,3,4},
	TOXIC_TO_ACID={2,3,4},
	STATIC_TO_SAND={2,3,4},
	TRANSMUTATION={2,3,4,5,6},
	NECROMANCY={2,3,4,5},
	LIGHT={0,1,2,3,4},
	EXPLOSION={0,2,4,5},
	FIRE_BLAST={0,1,3,5},
	POISON_BLAST={1,2,4,6},
	ALCOHOL_BLAST={1,2,4,6},
	THUNDER_BLAST={1,3,5,6},
	BERSERK_FIELD={2,3,4},
	POLYMORPH_FIELD={0,1,2,3,4,5,6},
	CHAOS_POLYMORPH_FIELD={1,2,3,4,5,6},
	ELECTROCUTION_FIELD={1,3,5,6},
	FREEZE_FIELD={0,2,4,5},
	REGENERATION_FIELD={1,2,3,4},
	TELEPORTATION_FIELD={0,1,2,3,4,5},
	LEVITATION_FIELD={3,4},
	SHIELD_FIELD={2,3,4,5,6},
	PROJECTILE_TRANSMUTATION_FIELD={2,3,4,5,6},
	PROJECTILE_THUNDER_FIELD={3,4,5,6},
	PROJECTILE_GRAVITY_FIELD={2,5,6},
	SEA_LAVA={0,4,5,6},
	SEA_ALCOHOL={0,4,5,6},
	SEA_OIL={0,4,5,6},
	SEA_WATER={0,4,5,6},
	SEA_ACID={0,4,5,6},
	SEA_ACID_GAS={0,4,5,6},
	CLOUD_WATER={0,1,2,3,4,5},
	CLOUD_BLOOD={0,1,2,3,4,5},
	CLOUD_ACID={0,1,2,3,4,5},
	CLOUD_THUNDER={0,1,2,3,4,5},
	ELECTRIC_CHARGE={1,2,4,5},
	MATTER_EATER={1,2,4,5},
	FREEZE={1,3,4,5},
	HITFX_BURNING_CRITICAL_HIT={1,3,4,5},
	HITFX_CRITICAL_WATER={1,3,4,5},
	HITFX_CRITICAL_OIL={1,3,4,5},
	HITFX_CRITICAL_BLOOD={1,3,4,5},
	HITFX_TOXIC_CHARM={1,3,4,5},
	HITFX_EXPLOSION_SLIME={1,3,4,5},
	HITFX_EXPLOSION_SLIME_GIGA={1,3,4,5},
	HITFX_EXPLOSION_ALCOHOL={1,3,4,5},
	HITFX_EXPLOSION_ALCOHOL_GIGA={1,3,4,5},
	ROCKET_DOWNWARDS={1,2,3,4},
	BOUNCE_EXPLOSION={1,2,3,4},
	FIREBALL_RAY={1,2,4,5},
	LIGHTNING_RAY={1,2,3,4,5},
	TENTACLE_RAY={1,2,3,4,5},
	FIREBALL_RAY_LINE={2,3,4,5,6},
	FIREBALL_RAY_ENEMY={1,2,4,5},
	LIGHTNING_RAY_ENEMY={1,2,3,4,5},
	TENTACLE_RAY_ENEMY={1,2,3,4,5},
	GRAVITY_FIELD_ENEMY={1,2,4,5},
	ARC_ELECTRIC={2,3,4,5,6},
	ARC_FIRE={1,2,3,4,5},
	ARC_GUNPOWDER={1,2,3,4,5},
	ARC_POISON={1,2,3,4,5},
	X_RAY={0,1,2,3,4,5,6},
	UNSTABLE_GUNPOWDER={2,3,4},
	ACID_TRAIL={1,2,3,4,5},
	POISON_TRAIL={2,3,4},
	OIL_TRAIL={2,3,4},
	WATER_TRAIL={1,2,3,4},
	GUNPOWDER_TRAIL={2,3,4},
	FIRE_TRAIL={0,1,2,3,4},
	BURN_TRAIL={0,1,2},
	TORCH={0,1,2},
	TORCH_ELECTRIC={0,1,2},
	ENERGY_SHIELD={2,3,4,5,6},
	ENERGY_SHIELD_SECTOR={1,2,3,4,5},
	OCARINA_A={10},
	OCARINA_B={10},
	OCARINA_C={10},
	OCARINA_D={10},
	OCARINA_E={10},
	OCARINA_F={10},
	OCARINA_GSHARP={10},
	OCARINA_A2={10},
}
-- Takes as input a table of spell IDs and filters out every spell whose level is not in the range specified
function filter_spells(spells, level_min, level_max)
	local filtered_list = {}
	for i, spell_name in ipairs(spells) do
		for i, level in ipairs(spell_level_lookup[spell_name]) do
			if level >= level_min and level <= level_max then
				table.insert(filtered_list, spell_name)
				break
			end
		end
	end
	return filtered_list
end

function add_spells_to_wand(wand, spells, num_spells_to_add)
	local wand_level = wand_compute_level(wand.entity_id)
	spells = filter_spells(spells, wand_level, wand_level)
	local spells_count = wand:GetSpellsCount()
	local num_spells_added = 0
	while wand.capacity > spells_count and num_spells_added < num_spells_to_add do
		wand:AddSpells(spells[Random(1, #spells)])
		spells_count = spells_count + 1
		num_spells_added = num_spells_added + 1
	end
end

-- p_t_w
local state_funcs = {
	["1_0_1"] = function() return "pw" end,
	["0_3_0"] = function() return "ttt" end,
	["0_0_2"] = function() return "ww" end,
	["0_1_2"] = function() return "tww" end,
	["1_1_1"] = function() return "ptw" end,
	["0_2_1"] = function() return "ttw" end,
}

-- Reduces or buffs a value only in one "direction"
-- Like when we want to reduce rechargeTime by 50%, if value is positive, then we would need to reduce
function change_value(value, percent, min_amount)
	local amount_to_change = math.abs(value) * percent
	value = value 
	return value
end

function feed_anvil(anvil_id, what, entity_id, material_name)
	-- TODO: Put the logic that gets the material name from a potion inside here
	local state = get_state(anvil_id)
	print("Inputting [ " .. what .. (material_name ~= nil and ": " .. material_name or "") .. " ]")

	if what == "wand" then
		hide_wand(anvil_id, entity_id)
	end

	if what == "tablet" then
		EntityKill(entity_id)
	end

	if what == "potion" then
		remove_potion_input_place(anvil_id)
		--[[ if state.potions == 1 then return end ]]
		local accepted = false
		local potion_bonuses = dofile_once("mods/anvil_of_destiny/files/entities/anvil/potion_bonuses.lua")
		for k, v in pairs(potion_bonuses) do
			if material_name == k then
				accepted = true
				break
			end
		end
		if not accepted then return end
		state.potion_material = material_name

		set_outline_emitter(anvil_id, true, { emitted_material_name=material_name })

		-- Empty the container
		local material_inventory_component = EntityGetFirstComponent(entity_id, "MaterialInventoryComponent")
		EntityRemoveComponent(entity_id, material_inventory_component)
		EntityAddComponent(entity_id, "MaterialInventoryComponent", {
			_tags="enabled_in_world,enabled_in_hand"
		})
	end

	state[what.."s"] = state[what.."s"] + 1	
	update_emitters(anvil_id, what)

  local state_string = state.potions
  state_string = state_string .. "_" .. state.tablets
  state_string = state_string .. "_" .. state.wands
	if state_funcs[state_string] ~= nil then
		local result = state_funcs[state_string]()
		print("--- DONE --- " , result)
		local x, y = EntityGetTransform(anvil_id)
		if result == "ww" or result == "tww" then



			local stored_wand_id1 = retrieve_wand(anvil_id, 1)
			local stored_wand_id2 = retrieve_wand(anvil_id, 2)
			local always_cast_spell_count = state.tablets
			local success, new_wand_id = pcall(function()
				set_random_seed_with_player_position()
				local seed_x = Random() * 1000
				local seed_y = Random() * 1000
				return anvil_buff1(stored_wand_id1, stored_wand_id2, config_regular_wand_buff, always_cast_spell_count, seed_x, seed_y)
			end)
			if not success then
				error("Anvil of Destiny error: " .. new_wand_id)
			end
			EntityKill(stored_wand_id1)
			EntityKill(stored_wand_id2)
			EntityAddChild(get_output_storage(anvil_id), new_wand_id)
			spawn_result_spawner(anvil_id, x, y)
			disable_interactivity(anvil_id)




		elseif result == "ttw" then


			local wand_id = buff_stored_wand(anvil_id, x, y)
			-- Move wand from wand_storage to output_storage
			EZWand(wand_id).shuffle = false
			EntityRemoveFromParent(wand_id)
			EntityAddChild(get_output_storage(anvil_id), wand_id)
			spawn_result_spawner(anvil_id, x, y)
			disable_interactivity(anvil_id)




		elseif result == "ttt" then
			spawn_result_spawner2(anvil_id, x, y)
			disable_interactivity(anvil_id)
		elseif result == "pw" or result == "ptw" then


			local stored_wand_id = retrieve_wand(anvil_id, 1)
			local always_cast_spell_count = state.tablets
			local success, new_wand_id = pcall(function()
				set_random_seed_with_player_position()
				local seed_x = Random() * 1000
				local seed_y = Random() * 1000
				return anvil_buff1(stored_wand_id1, stored_wand_id2, config_regular_wand_buff, always_cast_spell_count, seed_x, seed_y)
			end)
			if not success then
				error("Anvil of Destiny error: " .. new_wand_id)
			end

			local wand = EZWand(stored_wand_id)
			-- TODO: Seed RNG
			-- Call function to apply bonus based on material
			local potion_bonuses = dofile_once("mods/anvil_of_destiny/files/entities/anvil/potion_bonuses.lua")
			potion_bonuses[state.potion_material](wand)

			EntityRemoveFromParent(stored_wand_id)
			EntityAddChild(get_output_storage(anvil_id), stored_wand_id)
			spawn_result_spawner(anvil_id, x, y)
			disable_interactivity(anvil_id)

		end
  end
end

function EntityLoadDelayed(file_path, x, y, delay)
  local entity_id = EntityCreateNew()
  EntitySetTransform(entity_id, x, y)
  local comp = EntityAddComponent(entity_id, "LoadEntitiesComponent", {
    entity_file=file_path,
    timeout_frames=tostring(delay),
    kill_entity="1",
  })
  ComponentSetValueValueRangeInt(comp, "count", "1", "1")
end
-- Will spit out whatever is inside the <Entity name="output_storage"> after some time
function spawn_result_spawner(entity_id, x, y)
  local offset_x = x + 4
  local offset_y = y
  spawn_hammer_animation(offset_x, offset_y, 1, 0)
  spawn_hammer_animation(offset_x, offset_y, -1, 55)
  EntityAddComponent(entity_id, "LuaComponent", {
    script_source_file="mods/anvil_of_destiny/files/entities/anvil/result_spawner.lua",
    execute_on_added="0",
    execute_every_n_frame="125",
    remove_after_executed="1",
  })
end
-- This is for the easter egg path, it's hammer time!
function spawn_result_spawner2(entity_id, x, y)
  local offset_x = x + 4
  local offset_y = y
  local delays = { 0, 55, 50, 45, 40, 35, 30, 25, 18, 12, 8, 8 }
  local total_delay = 0
  for i, v in ipairs(delays) do
    total_delay = total_delay + v
    local direction = i % 2 == 0 and -1 or 1
    spawn_hammer_animation(offset_x, offset_y, direction, total_delay)
    if i > 3 then
      EntityAddComponent(entity_id, "LuaComponent", {
        script_source_file="mods/anvil_of_destiny/files/entities/anvil/loosen_random_chunk.lua",
        execute_on_added="0",
        execute_every_n_frame=tostring(total_delay + 40),
        remove_after_executed="1",
      })
    end
  end
  EntityAddComponent(entity_id, "LuaComponent", {
    script_source_file="mods/anvil_of_destiny/files/entities/anvil/deactivate_emitters.lua",
    execute_on_added="0",
    execute_every_n_frame=tostring(120),
    remove_after_executed="1",
  })
  EntityAddComponent(entity_id, "LuaComponent", {
    script_source_file="mods/anvil_of_destiny/files/entities/anvil/result_spawner.lua",
    execute_on_added="0",
    execute_every_n_frame=tostring(total_delay + 110),
    remove_after_executed="1",
  })
end

-- Buff a wand by a lot
function buff_stored_wand(anvil_id)
  local stored_wand_id = retrieve_wand(anvil_id, 1)
  local stored_wand = EZWand(stored_wand_id)
  local success, new_wand_id = pcall(function()
    set_random_seed_with_player_position()
    local variation = 0.1 - Random() * 0.2
    return buff_wand(stored_wand, config_improved_wand_buff + variation, false)
  end)
  if not success then
    -- If the call was not successful, new_wand_id contains the error message
    print("Anvil of Destiny error: " .. new_wand_id)
  end
  return stored_wand.entity_id
end

function disable_interactivity(entity_id)
  -- TODO: Dont remove collision trigger but instead luacomp?
  edit_component(entity_id, "AudioLoopComponent", function(comp, vars)
    EntityRemoveComponent(entity_id, comp)
  end)
  edit_all_components(entity_id, "CollisionTriggerComponent", function(comp, vars)
    EntityRemoveComponent(entity_id, comp)
  end)
	-- Remove damage checker component
  local lua_components = EntityGetComponent(entity_id, "LuaComponent")
  if lua_components ~= nil then
    for i, v in ipairs(lua_components) do
      if ComponentGetValue(v, "script_source_file") == "mods/anvil_of_destiny/files/entities/anvil/damage_checker.lua" then
        EntityRemoveComponent(entity_id, v)
        break
      end
    end
	end
	remove_potion_input_place(anvil_id)
end

function remove_potion_input_place(anvil_id)
	local x, y = EntityGetTransform(anvil_id)
	local entities_in_radius = EntityGetInRadius(x, y, 20)
	for i, entity in ipairs(entities_in_radius) do
		if EntityGetName(entity) == "anvil_of_destiny_potion_input" then
			EntityKill(entity)
			break
		end
	end
end

function get_wand_storage(anvil_id)
  local children = EntityGetAllChildren(anvil_id)
  for i, child in ipairs(children) do
    if EntityGetName(child) == "wand_storage" then
      return child
    end
  end
end

function get_output_storage(anvil_id)
  local children = EntityGetAllChildren(anvil_id)
  for i, child in ipairs(children) do
    if EntityGetName(child) == "output_storage" then
      return child
    end
  end
end

-- "Hides" a wand by removing it's visible components and adds it to the wand storage as a child entity so we can later retrieve it
function hide_wand(anvil_id, wand_id)
  -- Put the wand in the storage and disable all components that make it visible 
  EntityAddChild(get_wand_storage(anvil_id), wand_id)
  -- Disable physics to keep it floating
  edit_component(wand_id, "SimplePhysicsComponent", function(comp, vars)
    EntitySetComponentIsEnabled(wand_id, comp, false)
  end)
  edit_component(wand_id, "ItemComponent", function(comp, vars)
    EntitySetComponentIsEnabled(wand_id, comp, false)
  end)
  edit_component(wand_id, "SpriteComponent", function(comp, vars)
    EntitySetComponentIsEnabled(wand_id, comp, false)
  end)
  edit_component(wand_id, "LightComponent", function(comp, vars)
    EntitySetComponentIsEnabled(wand_id, comp, false)
  end)
end

function retrieve_wand(anvil_id, index)
  local wand_storage = get_wand_storage(anvil_id)
  local stored_wands = EntityGetAllChildren(wand_storage)

  return stored_wands[index]
end

function update_emitters(anvil_id, what)
	local state = get_state(anvil_id)
	local emitter_color = ""
  if state.tablets >= 2 then
    emitter_color = "_powered"
	end
	local total_inputs = math.max(state.tablets - 1, 0) + state.wands + state.potions
	for i=1, total_inputs do
		set_runes_enabled(anvil_id, "emitter" .. i .. emitter_color, true)
	end
	if what == "tablet" and state.tablets == 1 then
		set_runes_enabled(anvil_id, "base", true)
	end
end
