dofile("mods/anvil_of_destiny/files/scripts/utils.lua")
dofile("data/scripts/gun/procedural/gun_action_utils.lua")
dofile("data/scripts/lib/utilities.lua")
dofile("data/scripts/gun/gun_actions.lua")
dofile("data/scripts/gun/gun_enums.lua")

-- Returns true if entity is a wand
function wand_entity_is_wand(entity_id)
	local comp = EntityGetComponent(entity_id, "ManaReloaderComponent")
	return comp ~= nil
end
-- Returns an averga of both wands stats. WARNING! Only averages handpicked values (see function body)
function wand_get_average_stats(wand_id1, wand_id2)
	local props1 = wand_get_properties(wand_id1)
	local props2 = wand_get_properties(wand_id2)
	local props_avg = {
		ability_component_members = {},
		gun_config = {},
		gunaction_config = {},
	}
	props_avg.ability_component_members.mana_charge_speed =
		math.ceil(
		(tonumber(props1.ability_component_members.mana_charge_speed) +
		tonumber(props2.ability_component_members.mana_charge_speed)) / 2)
	props_avg.ability_component_members.mana_max =
		math.ceil(
		(tonumber(props1.ability_component_members.mana_max) +
		tonumber(props2.ability_component_members.mana_max)) / 2)
	props_avg.gun_config.actions_per_round =
		math.ceil(
		(tonumber(props1.gun_config.actions_per_round) +
		tonumber(props2.gun_config.actions_per_round)) / 2)
	props_avg.gun_config.shuffle_deck_when_empty =
		math.min(
		tonumber(props1.gun_config.shuffle_deck_when_empty),
		tonumber(props2.gun_config.shuffle_deck_when_empty))
	props_avg.gun_config.reload_time =
		math.floor(
		(tonumber(props1.gun_config.reload_time) +
		tonumber(props2.gun_config.reload_time)) / 2)
	props_avg.gun_config.deck_capacity =
		math.ceil(
		(tonumber(props1.gun_config.deck_capacity) +
		tonumber(props2.gun_config.deck_capacity)) / 2)
	props_avg.gunaction_config.fire_rate_wait =
		math.floor(
		(tonumber(props1.gunaction_config.fire_rate_wait) +
		tonumber(props2.gunaction_config.fire_rate_wait)) / 2)
	props_avg.gunaction_config.spread_degrees =
		math.floor(
		(tonumber(props1.gunaction_config.spread_degrees) +
		tonumber(props2.gunaction_config.spread_degrees)) / 2)

	return props_avg
end
-- Returns a rough estimate of the wand "level" by looking at the stats
function wand_compute_level(wand_id)
	local props = wand_get_properties(wand_id)
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
		if props.ability_component_members.sprite_file == v[1]
			 and props.ability_component_members.ui_name == v[2] then
			return 0
		end
	end

	-- Mana recharge goes in steps of 55
	local mana_charge_speed_thresholds = { 55, 110, 165, 220, 275, 330 }

--[[ 
	 	gun["mana_charge_speed"] = 50*level + Random(-5,5*level)
	 	gun["mana_max"] = 50 + (150 * level) + (Random(-5,5)*10)

	 	if( p < 20 ) then
		 	gun["mana_charge_speed"] = ( 50*level + Random(-5,5*level) ) / 5
			 gun["mana_max"] = ( 50 + (150 * level) + (Random(-5,5)*10) ) * 3
			 

		gun["mana_charge_speed"] = 50*level + Random(-5,5*level)
		level 1		 45 -  55
		level 2    95 - 110
		level 3   145 - 165
		level 4   195 - 220
		level 5   245 - 275
		level 6   295 - 330

		gun["mana_max"] = 50 + (150 * level) + (Random(-5,5)*10)
		level 1  150 - 250
		level 2  300 - 400
		level 3  450 - 550
		level 4  600 - 700
		level 5  750 - 850
		level 6  900 - 1000

 ]]
-- if mana max is 20x higher than charge speed, it's a "slow loader"
	local wand_level = nil
	local mana_charge_speed = tonumber(props.ability_component_members.mana_charge_speed)
	local mana_max = tonumber(props.ability_component_members.mana_max)

	if mana_max > mana_charge_speed * 20 then
		-- it's a "slow loader" wand, convert it back to a normal wand
		mana_charge_speed = mana_charge_speed * 5
		mana_max = mana_max / 3
	end

--[[ 	for i, v in ipairs(mana_charge_speed_thresholds) do
		if mana_charge_speed <= v then
			wand_level = i
			break
		end
	end ]]
	-- Clamp the max level to 6 for now
	return math.min(6, math.ceil(mana_charge_speed / 55))
end
-- UNUSED -- Should return a rough score of how good a wand is
function wand_calculate_score(wand_id)
	local score = 0
	local props = wand_get_properties(wand_id)
	local mana_charge_speed = tonumber(props.ability_component_members.mana_charge_speed)
	local mana_max = tonumber(props.ability_component_members.mana_max)
	local actions_per_round = tonumber(props.gun_config.actions_per_round)
	local shuffle = tonumber(props.gun_config.shuffle_deck_when_empty)
	local reload_time = tonumber(props.gun_config.reload_time)
	local deck_capacity = tonumber(props.gun_config.deck_capacity)
	local fire_rate_wait = tonumber(props.gunaction_config.fire_rate_wait)
	
--[[ 
Spells/Cast        4							 7%
Cast Delay         0.17s					16%
Recharge Time      1.18s					16%
Mana max           1000					   7%
Mana charge speed   295						24%
Capacity             11						21%
Spread              0.0deg				 7%
9 Spells, some high level
 ]]
 	-- worst should be 0, best 100
	score = actions_per_round * 25					-- 1 is worth 25
	score = score + (1 - fire_rate_wait)    -- 2 sec should be 0, 
	score = score + mana_charge_speed / 50
	score = score + mana_charge_speed / 50
	score = score * (1 - shuffle * 0.2)  -- Reduce overall score by 20% if it's shuffle
	score = score * (1 - shuffle * 0.2)  -- Reduce overall score by 20% if it's shuffle

	return score
end
-- Just for convenience so we can use a similarly named function
function wand_add_spell(wand_id, spell)
	AddGunAction(wand_id, spell)
end
-- Add an always cast spell without sacrificing a slot
function wand_add_always_cast_spell(wand_id, spell)
	-- Extend slots
	local ability_comp = wand_get_ability_component(wand_id)
	if ability_comp then
		local capacity = ComponentObjectGetValue(ability_comp, "gun_config", "deck_capacity")
		ComponentObjectSetValue(ability_comp, "gun_config", "deck_capacity", capacity + 1)
		AddGunActionPermanent(wand_id, spell)
	else
		local error_msg = "Error: wand_add_always_cast_spell() - AbilityComponent not found!"
		-- GamePrint(error_msg)
		print(error_msg)
	end
end
-- Remove all spells from a wand. All, only slotted, or only always cast spells.
function wand_remove_all_spells(wand_id, remove_slotted_spells, remove_always_cast_spells)
	local children = EntityGetAllChildren(wand_id)
	if children ~= nil then
		for _, v in ipairs(children) do
			local all_comps = EntityGetAllComponents(v)
			-- TODO: Refactor this when EntityGetComponent() returns disabled components...
			for _, c in ipairs(all_comps) do
				local val = ComponentGetValue(c, "permanently_attached")
				if val ~= "" and ((val == "0" and remove_slotted_spells) or (val == "1" and remove_always_cast_spells)) then
					EntityRemoveFromParent(v)
					break
				end
			end
		end
	end
end

function wand_get_ability_component(wand_id)
	local components = EntityGetAllComponents(wand_id)
	for i, component_id in ipairs(components) do
		for k, v2 in pairs(ComponentGetMembers(component_id)) do
			if(k == "mItemRecoil") then
				return component_id
			end
		end
	end
end
-- Returns the number of permanently attached spells
function wand_get_attached_spells_count(wand_id)
	local children = EntityGetAllChildren(wand_id)
	local count = 0
	if children == nil then
		return 0
	end
	for i,v in ipairs(children) do
		local all_comps = EntityGetAllComponents(v)
		for i, c in ipairs(all_comps) do
			if ComponentGetValue(c, "permanently_attached") == "1" then
				count = count + 1
			end
		end
	end
	return count
end
-- Returns the number of spells on the wand (without permanently attached ones)
function wand_get_spells_count(wand_id)
	local children = EntityGetAllChildren(wand_id)
	local num_children = children and #children or 0
	return num_children - wand_get_attached_spells_count(wand_id)
end
-- Returns how many slots the wand has (not counting permanently attached spells)
function wand_get_slot_count(wand_id)
	local ability_comp = wand_get_ability_component(wand_id)
	if ability_comp then
		local capacity = ComponentObjectGetValue(ability_comp, "gun_config", "deck_capacity")
		return capacity - wand_get_attached_spells_count(wand_id)
	end
end
-- Returns the number of free slots
function wand_get_free_slot_count(wand_id)
	return wand_get_slot_count(wand_id) - wand_get_spells_count(wand_id)
end
-- Returns a table { ability_component_members, gun_config, gunaction_config }
function wand_get_properties(wand_id)
	local ability_comp = wand_get_ability_component(wand_id)
	local ability_component_members = ComponentGetMembers(ability_comp)

	-- ComponentObjectGetMembers doesn't work properly i think?
	-- doesn't return values so we "fix" it for now
	local function ComponentObjectGetMembersWithValues(component, object_name)
		local members = ComponentObjectGetMembers(component, object_name)
		for k, _ in pairs(members) do
			members[k] = ComponentObjectGetValue(component, object_name, k)
		end
		return members
	end

	local gun_config = ComponentObjectGetMembersWithValues(ability_comp, "gun_config")
	local gunaction_config = ComponentObjectGetMembersWithValues(ability_comp, "gunaction_config")

	return {
		ability_component_members = ability_component_members,
		gun_config = gun_config,
		gunaction_config = gunaction_config
	}
end

function wand_set_properties(wand_id, props)
	props = props or {}
	local ability_comp = wand_get_ability_component(wand_id)
	ability_component_set_members(ability_comp, props.ability_component_members or {})
	ability_component_set_gun_config(ability_comp, props.gun_config or {})
	ability_component_set_gunaction_config(ability_comp, props.gunaction_config or {})
end
-- Just an example on how to buff a wand
function _buff_wand(wand_id)
	local props = wand_get_properties(wand_id)
	props.ability_component_members.mana_charge_speed = props.ability_component_members.mana_charge_speed * 1.2
	props.ability_component_members.mana_max = props.ability_component_members.mana_max * 1.2
	props.ability_component_members.mana = props.ability_component_members.mana_max
	props.gun_config.deck_capacity = props.gun_config.deck_capacity + 1
	props.gun_config.reload_time = props.gun_config.reload_time * 0.8
	props.gunaction_config.fire_rate_wait = props.gunaction_config.fire_rate_wait * 0.8
	props.gunaction_config.spread_degrees = props.gunaction_config.spread_degrees * 0.8

	wand_set_properties(wand_id, props)
	wand_add_always_cast_spell(wand_id, "BLACK_HOLE")
	wand_add_spell(wand_id, "CHAOS_POLYMORPH_FIELD")
end

function wand_restore_to_unpicked_state(wand_id, x, y)
	local ability_comp = wand_get_ability_component(wand_id)
	EntitySetComponentIsEnabled(wand_id, ability_comp, true)
	print("ability_comp: " .. ability_comp)

	local hotspot_comp = get_component_with_member(wand_id, "sprite_hotspot_name")
	EntitySetComponentIsEnabled(wand_id, hotspot_comp, true)
	print("hotspot_comp: " .. hotspot_comp)

  local item_component = get_component_with_member(wand_id, "collect_nondefault_actions")
	EntitySetComponentIsEnabled(wand_id, item_component, true)
	
	local sprite_component = get_component_with_member(wand_id, "rect_animation")
	EntitySetComponentIsEnabled(wand_id, sprite_component, true)

	local light_component = get_component_with_member(wand_id, "blinking_freq")
	EntitySetComponentIsEnabled(wand_id, light_component, true)

	edit_component(wand_id, "ItemComponent", function(comp, vars)
		ComponentSetValue(comp, "has_been_picked_by_player", "0")
		ComponentSetValue(comp, "play_hover_animation", "1")
		ComponentSetValueVector2(comp, "spawn_pos", x + 4, y - 25)
	end)

	local lua_comp = get_component_with_member(wand_id, "script_item_picked_up")
	EntitySetComponentIsEnabled(wand_id, lua_comp, true)
	print("lua_comp: " .. lua_comp)

	edit_component(wand_id, "SimplePhysicsComponent", function(comp, vars)
		EntitySetComponentIsEnabled(wand_id, comp, false)
		print("SimplePhysicsComponent: " .. comp)
	end)

	-- Does this wand have a ray particle effect? Most do, except the starter wands
	local sprite_particle_emitter_comp = get_component_with_member(wand_id, "velocity_always_away_from_center")
	if sprite_particle_emitter_comp ~= nil then
		EntitySetComponentIsEnabled(wand_id, sprite_particle_emitter_comp, true)
	else
		-- TODO: As soon as there's some way to clone Components or Transplant/Remove+Add to another Entity, copy
		-- the SpriteParticleEmitterComponent of entities/base_wand.xml
	end
	-- TODO(?): Set ItemComponent::play_hover_animation="1"
end

function ability_component_set_members(ability_component_id, ability_component_members)
	for k, v in pairs(ability_component_members) do
		ComponentSetValue(ability_component_id, k, v)
	end
end

function ability_component_set_gun_config(ability_component_id, gun_config)
	for k, v in pairs(gun_config) do
		ComponentObjectSetValue(ability_component_id, "gun_config", k, v)
	end
end

function ability_component_set_gunaction_config(ability_component_id, gunaction_config)
	for k, v in pairs(gunaction_config) do
		ComponentObjectSetValue(ability_component_id, "gunaction_config", k, v)
	end
end

-- Returns two values:
-- 1: table of spells with each entry having the format { action_id = "BLACK_HOLE", inventory_x = 1 }
-- 2: table of attached spells with the same format { action_id = "BLACK_HOLE", inventory_x = 1 }
-- inventory_x should give the position in the wand slots, 1 = first up to num_slots
-- inventory_x is not working yet
function wand_get_spells(wand_id)
	local spells = {}
	local always_cast_spells = {}
	local children = EntityGetAllChildren(wand_id)
  if children == nil then
    return spells, always_cast_spells
  end
	for _, v in ipairs(children) do
		local all_comps = EntityGetAllComponents(v)
		local action_id = nil
		local permanent = false
		local inventory_x = -1
		-- TODO: Refactor this when EntityGetComponent() returns disabled components...
		for _, c in ipairs(all_comps) do
			-- ItemActionComponent::action_id
			local val = ComponentGetValue(c, "action_id")
			if val ~= "" then
				-- It's the ItemActionComponent
				action_id = val
			end
			-- ItemComponent::permanently_attached
			val = ComponentGetValue(c, "permanently_attached")
			if val ~= "" then
				-- It's the ItemComponent
				if val == "1" then
					permanent = true
				end
				local inventory_y
				-- ItemComponent::inventory_slot.x [0, count] gives the slot it's in
				-- Does not work yet, always returns 0, 0...
				inventory_x, inventory_y = ComponentGetValueVector2(c, "inventory_slot")
			end
		end
		if action_id ~= nil then
			if permanent == true then
				table.insert(always_cast_spells, { action_id = action_id, inventory_x = inventory_x })
			else
				table.insert(spells, { action_id = action_id, inventory_x = inventory_x })
			end
		end
	end
	return spells, always_cast_spells
end

function wand_print_debug_info(wand_id)
	local spells_count = wand_get_spells_count(wand_id)
	local attached_spells_count = wand_get_attached_spells_count(wand_id)
	local slot_count = wand_get_slot_count(wand_id)
	local free_slots = wand_get_free_slot_count(wand_id)
	local props = wand_get_properties(wand_id)
	local spells, always_cast_spells = wand_get_spells(wand_id)

	print("spells_count: " .. spells_count)
	print("attached_spells_count: " .. attached_spells_count)
	print("slot_count: " .. slot_count)
	print("free_slots: " .. free_slots)
	print("-- abilities --")
	debug_print_table(props.ability_component_members)
	print("-- gun_config --")
	debug_print_table(props.gun_config)
	print("-- gunaction_config --")
	debug_print_table(props.gunaction_config)
	print("-- spells --")
	debug_print_table(spells)
	print("-- always_cast_spells --")
	debug_print_table(always_cast_spells)
end
-- Returns an entry of data/scripts/gun/gun_actions.lua
function action_get_by_id(action_id)
	for i, action in ipairs(actions) do
		if (action.id == action_id) then
			return action
		end
	end
end

function wand_merge(wand_id1, wand_id2, x, y)
  local generated_wand = EntityLoad("data/entities/items/wand_level_04.xml", x, y)
  local props = wand_get_average_stats(wand_id1, wand_id2)

  wand_set_properties(generated_wand, props)
  wand_remove_all_spells(generated_wand, true, true)
  -- Get spells of both wands, and check their level and count, then fill the generated wand with similar spells/count
	local spells1, always_attached_spells1 = wand_get_spells(wand_id1)
  local spells2, always_attached_spells2 = wand_get_spells(wand_id2)
  local average_spell_count = math.ceil((#spells1 + #spells2) / 2)
  local level_of_wand1 = wand_compute_level(wand_id1)
  local level_of_wand2 = wand_compute_level(wand_id2)
  local average_level = math.ceil((level_of_wand1 + level_of_wand2) / 2)
  
  local capped_level = math.min(average_level + 1, 6)
  for i,v in ipairs(always_attached_spells1) do
    wand_add_always_cast_spell(generated_wand, v.action_id)
  end
  for i,v in ipairs(always_attached_spells2) do
    wand_add_always_cast_spell(generated_wand, v.action_id)
  end

  average_spell_count = math.min(average_spell_count, tonumber(props.gun_config.deck_capacity))

	for i,v in ipairs(spells1) do
    table.insert(spells2, v)
  end

  table_shuffle(spells2)

	for i=1, average_spell_count do
    wand_add_spell(generated_wand, spells2[i].action_id)
  end

  return generated_wand
end

function wand_buff(wand_id, buff_amount, flat_buff_amounts, seed_x, seed_y)
	flat_buff_amounts = flat_buff_amounts or {}
	flat_buff_amounts.mana_charge_speed = flat_buff_amounts.mana_charge_speed or Random(40, 60)
	flat_buff_amounts.mana_max = flat_buff_amounts.mana_max or Random(25, 40)
	flat_buff_amounts.reload_time = flat_buff_amounts.reload_time or Random(1, 2)
	flat_buff_amounts.fire_rate_wait = flat_buff_amounts.fire_rate_wait or Random(1, 2)
	flat_buff_amounts.spread_degrees = flat_buff_amounts.spread_degrees or Random(4, 8)
	SetRandomSeed(seed_x, seed_y)
  local rng = create_normalized_random_distribution(5, 0.4)
  local props = wand_get_properties(wand_id)
--[[   for i,v in ipairs(rng) do
    rng[i] = rng[i] - 0.1 -- Remove 10% of each stat
  end
	buff_amount = buff_amount + 0.5 -- Add the removed 5x10% back ]]
	props.ability_component_members.mana_charge_speed = props.ability_component_members.mana_charge_speed * (1 + rng[1] * buff_amount) 
	props.ability_component_members.mana_charge_speed = props.ability_component_members.mana_charge_speed + flat_buff_amounts.mana_charge_speed
	props.ability_component_members.mana_max = props.ability_component_members.mana_max * (1 + rng[2] * buff_amount)
	props.ability_component_members.mana_max = props.ability_component_members.mana_max + flat_buff_amounts.mana_max
  props.ability_component_members.mana = props.ability_component_members.mana_max
	local sign = get_sign(props.gun_config.reload_time)
	if sign == 1 then
		props.gun_config.reload_time = props.gun_config.reload_time / (1 + rng[3] * buff_amount) --  0.50s + 100% buff = 0.25s
	else
		props.gun_config.reload_time = props.gun_config.reload_time * (1 + rng[3] * buff_amount) -- -0.50s + 100% buff = -1.00s
	end
	props.gun_config.reload_time = props.gun_config.reload_time - flat_buff_amounts.reload_time
	sign = get_sign(props.gunaction_config.fire_rate_wait)
	if sign == 1 then
		props.gunaction_config.fire_rate_wait = props.gunaction_config.fire_rate_wait / (1 + rng[4] * buff_amount)
	else
		props.gunaction_config.fire_rate_wait = props.gunaction_config.fire_rate_wait * (1 + rng[4] * buff_amount)
	end
	props.gunaction_config.fire_rate_wait = props.gunaction_config.fire_rate_wait - flat_buff_amounts.fire_rate_wait
	sign = get_sign(props.gunaction_config.spread_degrees)
	if sign == 1 then
		props.gunaction_config.spread_degrees = props.gunaction_config.spread_degrees / (1 + rng[5] * buff_amount)
	else
		props.gunaction_config.spread_degrees = props.gunaction_config.spread_degrees * (1 + rng[5] * buff_amount)
	end
	props.gunaction_config.spread_degrees = props.gunaction_config.spread_degrees - flat_buff_amounts.spread_degrees
	wand_set_properties(wand_id, props)
  -- props.gun_config.deck_capacity = props.gun_config.deck_capacity + math.ceil(props.gun_config.deck_capacity / 4)
	
  return generated_wand
end
-- Returns a spells average "level" based on spawn_level, which is the level of wands it can spawn in, for instance "3,4,5"
function action_get_level(action)
	local levels = string_split(action.spawn_level, ",")
	local avg = math.ceil(math_average(levels))
	return math.min(6, math.max(1, avg))
end

function wand_fill_with_semi_random_spells(wand_id, spells_count, always_attached_spells_count, level)
	local props = wand_get_properties(wand_id)
	level = math.min(6, level)
  -- Attach always cast spells maybe
  for i=1, always_attached_spells_count do
    local action = get_random_action(level, 1, 1, 1, i)
    wand_add_always_cast_spell(wand_id, action)
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

  local seed = 0
  local guaranteed_projectile_index = Random(1, spells_count)
  for i=1, spells_count do
    -- 50% chance to increase the seed which will generate a different action
    -- This is so that we neither get a chaotic array of spells nor the same ones over and over
    seed = seed + Random(0, 1)
    local action = nil
    if i == guaranteed_projectile_index then
      action = GetRandomActionWithType(x, y, randomly_alter_level(level), ACTION_TYPE_PROJECTILE, seed)
      -- Check if wand has enough max mana to cast it
      local action_info = action_get_by_id(action)
      -- Try a maximum of 5 times to get a projectile that the wand has enough mana for
      for i=1,5 do
        if action_info.mana < tonumber(props.ability_component_members.mana_max) then
          -- Has enough mana, we're done
          break
        end
        -- If not then reroll with lower level
        action = GetRandomActionWithType(x, y, randomly_alter_level(level-(i-1)), ACTION_TYPE_PROJECTILE, seed)
      end
    else
      action = get_random_action(randomly_alter_level(level), 8, 1, 2, seed)
    end
    wand_add_spell(wand_id, action)
  end
end

function get_random_action(level, chance_projectile, chance_modifier, chance_draw_many, seed)
  local rand_spell_roll = Random()
  local chances = { chance_projectile, chance_modifier, chance_draw_many }
  normalize_table(chances)
  local spell = nil
  if rand_spell_roll < chances[1] then
    spell = GetRandomActionWithType(x, y, level, ACTION_TYPE_PROJECTILE, seed)
  elseif rand_spell_roll < chances[1] + chances[2] then
    spell = GetRandomActionWithType(x, y, level, ACTION_TYPE_MODIFIER, seed)
  else
    spell = GetRandomActionWithType(x, y, level, ACTION_TYPE_DRAW_MANY, seed)
  end
  return spell
end
