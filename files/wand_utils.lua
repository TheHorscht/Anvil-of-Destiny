dofile("data/scripts/gun/procedural/gun_action_utils.lua")
dofile("data/scripts/lib/utilities.lua")

function AddGunActionPermanentSafely(wand_id, spell)
	-- Extend slots
	local ability_comp = wand_get_ability_component(wand_id)
	if ability_comp then
		local capacity = ComponentObjectGetValue(ability_comp, "gun_config", "deck_capacity")
		local capacity = ComponentObjectSetValue(ability_comp, "gun_config", "deck_capacity", capacity + 1)
		AddGunActionPermanent(wand_id, spell)
	else
		local error_msg = "Error: AddGunActionPermanentSafely() - AbilityComponent not found!"
		-- GamePrint(error_msg)
		print(error_msg)
	end
end

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

function wand_get_spells_count(wand_id)
	local num_children = #EntityGetAllChildren(wand_id)
	return num_children - wand_get_attached_spells_count(wand_id)
end

function wand_get_free_slots(wand_id)
	local ability_comp = wand_get_ability_component(wand_id)
	if ability_comp then
		local capacity = ComponentObjectGetValue(ability_comp, "gun_config", "deck_capacity")
		return (capacity - (wand_get_spells_count(wand_id) + wand_get_attached_spells_count(wand_id)))
	end
end

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

function buff_wand(wand_id)
	local stored = wand_get_properties(wand_id)
	stored.gun_config.deck_capacity = stored.gun_config.deck_capacity + 1
	stored.gun_config.reload_time = stored.gun_config.reload_time * 0.8
	stored.gunaction_config.fire_rate_wait = stored.gunaction_config.fire_rate_wait * 0.8
	stored.gunaction_config.spread_degrees = stored.gunaction_config.spread_degrees * 0.8
	stored.gunaction_config.speed_multiplier = stored.gunaction_config.speed_multiplier * 10.8
	stored.ability_component_members.mana_charge_speed = stored.ability_component_members.mana_charge_speed * 1.2
	stored.ability_component_members.mana_max = stored.ability_component_members.mana_max * 1.2
	stored.ability_component_members.mana = stored.ability_component_members.mana_max

	wand_set_properties(wand_id, stored.ability_component_members, stored.gun_config, stored.gunaction_config)
end

function wand_set_properties(wand_id, ability_component_members, gun_config, gunaction_config)
	local ability_comp = wand_get_ability_component(wand_id)
	ability_component_set_members(ability_comp, ability_component_members)
	ability_component_set_gun_config(ability_comp, gun_config)
	ability_component_set_gunaction_config(ability_comp, gunaction_config)
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

-- stolen from kermit tears >:)
function GetWandActions( wand )
	local actions = {};
	local children = EntityGetAllChildren( wand );
	for i,v in ipairs( children ) do
			local all_comps = EntityGetAllComponents( v );
			local action_id = nil;
			local permanent = false;
			for i, c in ipairs( all_comps ) do
					action_id = ComponentGetValueDefault( c, "action_id", action_id );
					permanent = ComponentGetValueDefault( c, "permanently_attached", permanent );
			end
			if action_id ~= nil then
					table.insert( actions, {action_id=action_id, permanent=permanent} );
			end
	end
	return actions;
end
