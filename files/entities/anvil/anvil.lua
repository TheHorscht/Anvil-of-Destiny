dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/gun_actions.lua")
dofile_once("data/scripts/gun/gun_enums.lua")
dofile_once("mods/anvil_of_destiny/lib/StringStore/stringstore.lua")
dofile_once("mods/anvil_of_destiny/lib/StringStore/noitavariablestore.lua")
dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/anvil_of_destiny/config.lua")
dofile_once("mods/anvil_of_destiny/files/scripts/utils.lua")
dofile_once("mods/anvil_of_destiny/files/entities/anvil/item_detector.lua")
dofile_once("mods/anvil_of_destiny/files/scripts/spawn_hammer_animation.lua")
dofile_once("mods/anvil_of_destiny/files/entities/anvil/wand_utils.lua")
local EZWand = dofile_once("mods/anvil_of_destiny/lib/EZWand/EZWand.lua")
local spells_evolutions = dofile_once("mods/anvil_of_destiny/files/scripts/spells_evolutions.lua")

-- Diminishes the bonus by scale if it's above threshold
local function limit_buff(value, threshold, scale)
	if value > threshold then
		value = threshold + (value - threshold) * scale
	end
	return value
end

function buff_wand(wand, buff_amount, mana_charge_speed_bonus_scale, reduce_one_stat)
	local rng = create_normalized_random_distribution(3, 0.1)
	-- one of castDelay rechargeTime or spread should get nerfed, the other 2 buffed
	local randIndex = Random(1, #rng)
	if reduce_one_stat then
		rng[randIndex] = rng[randIndex] * -1
	end
	wand.manaChargeSpeed = wand.manaChargeSpeed + Random(45, 60) * mana_charge_speed_bonus_scale --  * limit_buff(2 * buff_amount, 1, 0.2)
	local bonus_mana = wand.manaMax * (1.05 + Random() * 0.1) * buff_amount
	wand.manaMax = wand.manaMax + limit_buff(bonus_mana, 50, 0.2)
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
    error("Argument 'which' is invalid. Given: " ..tostring(which))
  end
end

function set_outline_emitter(anvil_id, enabled, values)
  local all_components = EntityGetAllComponents(anvil_id)
	for _, component in ipairs(all_components) do
		local component_members = ComponentGetMembers(component)
		for k, v in pairs(component_members) do
			if k == "image_animation_file" and v == "mods/anvil_of_destiny/files/entities/anvil/outline_emitter_top.png" then
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

-- p_t_w
local state_strings = {
	["0_0_2"] = "ww",
	["1_0_1"] = "pw",
	["1_1_1"] = "ptw",
	["0_1_2"] = "tww",
	["0_2_1"] = "ttw",
	["0_3_0"] = "ttt",
}

function combine_two_wands(x, y, wand1, wand2, attach_spells_count)
	SetRandomSeed(GameGetFrameNum() + x + wand1.entity_id, GameGetFrameNum() + y + wand2.entity_id)
	local new_wand = wand_merge(wand1, wand2)
	-- Need to do this again because in wand_merge a new wand is being loaded which causes the vanilla wand script to set it's own seed
	-- based on the position of the newly loaded wand
	SetRandomSeed(GameGetFrameNum() + x + wand1.entity_id, GameGetFrameNum() + y + wand2.entity_id)
	local spell_stats = get_wand_average_spell_count_and_spell_level(wand1, wand2)
	local wand1_spell_count = #wand1:GetSpells()
	local wand2_spell_count = #wand2:GetSpells()

	local evo_spell_level_counts, evo_ac_spell_level_counts
	if ModIsEnabled("spells_evolutions") then
		local se_counts1 = spells_evolutions.get_spell_level_counts(wand1)
		local se_counts2 = spells_evolutions.get_spell_level_counts(wand2)
		evo_spell_level_counts = se_counts1.spells
		for spell_level, count in ipairs(se_counts2.spells) do
			evo_spell_level_counts[spell_level] = evo_spell_level_counts[spell_level] + count
		end
		evo_ac_spell_level_counts = se_counts1.always_casts
		for spell_level, count in ipairs(se_counts2.always_casts) do
			evo_ac_spell_level_counts[spell_level] = evo_ac_spell_level_counts[spell_level] + count
		end
	end
	-- 100% of the highest spellcount wand and 50% of the lower, so if wand1 has 20 spells and wand2 has 20, result should have 30
	local spell_count_to_add = math.max(wand1_spell_count, wand2_spell_count) + math.floor(math.min(wand1_spell_count, wand2_spell_count) / 2)
	spell_count_to_add = spell_count_to_add + Random(-1, 3)
	if spell_count_to_add <= 0 then
		spell_count_to_add = 1
	end
	wand_fill_with_semi_random_spells(new_wand,
		spell_count_to_add,
		spell_stats.average_attached_spell_count,
		spell_stats.average_spell_level,
		spell_stats.average_attached_spell_level,
		evo_spell_level_counts,
		evo_ac_spell_level_counts,
		Randomf()*1000, Randomf()*1000)
	local buff = ModSettingGet("anvil_of_destiny.buff_amount")
	buff_wand(new_wand, buff, buff * 2, ModSettingGet("anvil_of_destiny.reduce_one_stat"))
	local wand_level = wand_compute_level(new_wand.entity_id)
	for i=1, attach_spells_count do
		local action_type = ACTION_TYPE_MODIFIER
		local only_modifiers = ModSettingGet("anvil_of_destiny.only_modifiers")
		if not only_modifiers then
			action_type = get_random_action_type(8, 1, 2, Random()*100, Random()*100, Random()*100)
		end
		local action = GetRandomActionWithType(Random()*100, Random()*100, wand_level, action_type, Random()*100)
		new_wand:AttachSpells(action)
	end
	new_wand:UpdateSprite()
	return new_wand.entity_id
end

function feed_anvil(anvil_id, what, context_data)
	-- context_data contains the entity_id in case of wand and tablet or the material name in case of potion
	local state = get_state(anvil_id)
	local x, y = EntityGetTransform(anvil_id)
	state[what.."s"] = state[what.."s"] + 1
	if what == "wand" then
		store_wand(anvil_id, context_data)
	end

	if what == "tablet" then
		EntityKill(context_data)
		if state.tablets == 2 then
			remove_potion_input_place(anvil_id)
		end
	end

	if what == "potion" then
		local material_name = context_data
		local potion_bonuses = dofile_once("mods/anvil_of_destiny/files/entities/anvil/potion_bonuses.lua")
		if not potion_bonuses[material_name] then return end
		state.potion_material = material_name
		remove_potion_input_place(anvil_id)
		local emitter_material = material_emitter_lookup[material_name] or material_name
		if CellFactory_GetType(emitter_material) ~= -1 then
			set_outline_emitter(anvil_id, true, { emitted_material_name = emitter_material })
		end
	end

	update_emitters(anvil_id, what)
	GamePlaySound("mods/anvil_of_destiny/audio/anvil_of_destiny.bank", "jingle", x, y)
	-- TODO: Spit out wands and show sorry message when something goes wrong
  local current_state = state.potions
  current_state = current_state .. "_" .. state.tablets
	current_state = current_state .. "_" .. state.wands
	local result = state_strings[current_state]
	if result == "ww" or result == "tww" then
		-- Combine wands and buff the result slightly
		local stored_wand_id1 = retrieve_wand(anvil_id, 1)
		local stored_wand_id2 = retrieve_wand(anvil_id, 2)
		local success, new_wand_id = pcall(function()
			return combine_two_wands(x, y, EZWand(stored_wand_id1), EZWand(stored_wand_id2), state.tablets)
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
		set_random_seed_with_player_position()
		local wand = EZWand(stored_wand_id)
		-- Call function to apply bonus based on material
		local potion_bonuses = dofile_once("mods/anvil_of_destiny/files/entities/anvil/potion_bonuses.lua")
		potion_bonuses[state.potion_material](wand)
		local wand_level = wand_compute_level(wand.entity_id)
		for i=1, state.tablets do
			local action_type = ACTION_TYPE_MODIFIER
			local only_modifiers = ModSettingGet("anvil_of_destiny.only_modifiers")
			if not only_modifiers then
				action_type = get_random_action_type(8, 1, 2, Random()*100, Random()*100, Random()*100)
			end
			local action = GetRandomActionWithType(Random()*100, Random()*100, wand_level, action_type, Random()*100)
			wand:AttachSpells(action)
		end
		EntityRemoveFromParent(stored_wand_id)
		EntityAddChild(get_output_storage(anvil_id), stored_wand_id)
		spawn_result_spawner(anvil_id, x, y)
		disable_interactivity(anvil_id)
	end
end

function is_valid_anvil_input(anvil_id, what, material)
	local state = get_state(anvil_id)

	if what == "potion" then
		local potion_bonuses = dofile_once("mods/anvil_of_destiny/files/entities/anvil/potion_bonuses.lua")
		return state.tablets < 2 and state.potions == 0 and (not material or material and potion_bonuses[material])
	elseif what == "tablet" then
		if state.potions > 0 then
			return state.tablets < 1
		else
			return true
		end
	elseif what == "wand" then
		return true
	end

	error(string.format("Invalid anvil input: '%s'", what))
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
	if not is_debug() then
  	spawn_hammer_animation(offset_x, offset_y, 1, 0)
		spawn_hammer_animation(offset_x, offset_y, -1, 55)
	end
  EntityAddComponent(entity_id, "LuaComponent", {
    script_source_file="mods/anvil_of_destiny/files/entities/anvil/result_spawner.lua",
    execute_on_added="0",
    execute_every_n_frame=is_debug() and "1" or "125",
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
		if not is_debug() then
			spawn_hammer_animation(offset_x, offset_y, direction, total_delay)
		end
	end
	if not is_debug() then
		EntityAddComponent2(entity_id, "LuaComponent", {
			script_source_file="mods/anvil_of_destiny/files/entities/anvil/loosen_chunks.lua",
			execute_every_n_frame=150,
			remove_after_executed=true,
		})
	end
  -- EntityAddComponent(entity_id, "LuaComponent", {
  --   script_source_file="mods/anvil_of_destiny/files/entities/anvil/deactivate_emitters.lua",
  --   execute_on_added="0",
  --   execute_every_n_frame=tostring(total_delay + 200),
  --   remove_after_executed="1",
  -- })
  EntityAddComponent(entity_id, "LuaComponent", {
    script_source_file="mods/anvil_of_destiny/files/entities/anvil/result_spawner.lua",
    execute_on_added="0",
    execute_every_n_frame=is_debug() and "1" or tostring(total_delay + 110),
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
		local buff = ModSettingGet("anvil_of_destiny.buff_amount_special")
    return buff_wand(stored_wand, buff + variation, buff * 1.25, false)
  end)
  if not success then
    -- If the call was not successful, new_wand_id contains the error message
    print("Anvil of Destiny error: " .. new_wand_id)
  end
  return stored_wand.entity_id
end

function disable_interactivity(entity_id)
	-- TODO: Don't remove collision trigger but instead luacomp?
	local audio_loop_component = EntityGetFirstComponent(entity_id, "AudioLoopComponent")
	if audio_loop_component then
		EntitySetComponentIsEnabled(entity_id, audio_loop_component, false)
	end
	local collision_trigger_components = EntityGetComponentIncludingDisabled(entity_id, "CollisionTriggerComponent") or {}
	for i, comp in ipairs(collision_trigger_components) do
		local state = get_state(entity_id)
		state.is_disabled = true
		EntitySetComponentIsEnabled(entity_id, comp, false)
	end
	-- Remove damage checker component
  local lua_components = EntityGetComponent(entity_id, "LuaComponent") or {}
	for i, v in ipairs(lua_components) do
		if ComponentGetValue(v, "script_source_file") == "mods/anvil_of_destiny/files/entities/anvil/damage_checker.lua" then
			EntitySetComponentIsEnabled(entity_id, v, false)
			break
		end
	end
	remove_potion_input_place(entity_id)
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
function store_wand(anvil_id, wand_id)
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
