dofile("data/scripts/gun/procedural/gun_action_utils.lua")
-- dofile("data/scripts/lib/utilities.lua")

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
