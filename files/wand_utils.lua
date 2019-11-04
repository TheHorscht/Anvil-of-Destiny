dofile("data/scripts/gun/procedural/gun_action_utils.lua")
dofile("data/scripts/lib/utilities.lua")

-- Returns true if entity is a wand
function wand_entity_is_wand(entity_id)
	local comp = EntityGetComponent(entity_id, "ManaReloaderComponent")
	return comp ~= nil
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
	local num_children = #EntityGetAllChildren(wand_id)
	return num_children - wand_get_attached_spells_count(wand_id)
end
-- Returns the number of free slots
function wand_get_free_slots(wand_id)
	local ability_comp = wand_get_ability_component(wand_id)
	if ability_comp then
		local capacity = ComponentObjectGetValue(ability_comp, "gun_config", "deck_capacity")
		return (capacity - (wand_get_spells_count(wand_id) + wand_get_attached_spells_count(wand_id)))
	end
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
	local ability_comp = wand_get_ability_component(wand_id)
	ability_component_set_members(ability_comp, props.ability_component_members)
	ability_component_set_gun_config(ability_comp, props.gun_config)
	ability_component_set_gunaction_config(ability_comp, props.gunaction_config)
end
-- Just an example on how to buff a wand
function buff_wand(wand_id)
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

-- Returns two values: 1: table of spells 2: table of attached spells
function wand_get_spells(wand_id)
	local spells = {}
	local always_cast_spells = {}
	local children = EntityGetAllChildren(wand_id)
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
	local free_slots = wand_get_free_slots(wand_id)
	local props = wand_get_properties(wand_id)
	local spells, always_cast_spells = wand_get_spells(wand_id)

	print("spells_count: " .. spells_count)
	print("attached_spells_count: " .. attached_spells_count)
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
