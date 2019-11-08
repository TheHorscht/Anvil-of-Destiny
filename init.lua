ModRegisterAudioEventMappings( "mods/anvil_of_destiny/fmod/Build/GUIDs.txt")
ModLuaFileAppend("data/scripts/biomes/coalmine.lua", "mods/anvil_of_destiny/files/biomes/coalmine.lua")
ModLuaFileAppend("data/scripts/biomes/excavationsite.lua", "mods/anvil_of_destiny/files/biomes/excavationsite.lua")
ModLuaFileAppend("data/scripts/biomes/crypt.lua", "mods/anvil_of_destiny/files/biomes/crypt.lua")
ModLuaFileAppend("data/scripts/biomes/pyramid.lua", "mods/anvil_of_destiny/files/biomes/pyramid.lua")
ModLuaFileAppend("data/scripts/biomes/rainforest.lua", "mods/anvil_of_destiny/files/biomes/rainforest.lua")
ModLuaFileAppend("data/scripts/biomes/snowcastle.lua", "mods/anvil_of_destiny/files/biomes/snowcastle.lua")
ModLuaFileAppend("data/scripts/biomes/snowcave.lua", "mods/anvil_of_destiny/files/biomes/snowcave.lua")
ModLuaFileAppend("data/scripts/biomes/vault.lua", "mods/anvil_of_destiny/files/biomes/vault.lua")

-- TODO: Do this non intrusively
-- ModLuaFileAppend("data/scripts/gun/procedural/level_1_wand.lua", "mods/anvil_of_destiny/files/scripts/set_wand_level_1.lua")
-- And all the other things in data/scripts/gun/procedural...

-- Set wand levels for players starting wands after he spawns

dofile("mods/anvil_of_destiny/files/wand_utils.lua")
dofile("mods/anvil_of_destiny/lib/StringStore/stringstore.lua")
dofile("mods/anvil_of_destiny/lib/StringStore/noitaglobalstore.lua")

function OnPlayerSpawned(player_entity)
	local INIT_STORE = stringstore.open_store(stringstore.noita.global("INIT"), "", "ANVIL_OF_DESTINY")
	if INIT_STORE.starting_wand_levels_set == nil then
		INIT_STORE.starting_wand_levels_set = true
		local inventory_id = EntityGetWithName("inventory_quick")
		local inventory_contents = EntityGetAllChildren(inventory_id)
		if inventory_contents ~= nil then
			for i,id in ipairs(inventory_contents) do
				if not EntityHasTag(id, "wand_level_0") and wand_entity_is_wand(id) then
					if not EntityHasTag(id, "wand") then
						EntityAddTag(id, "wand")
					end
					EntityAddTag(id, "wand_level_0")
				end
			end
		end
	end
end





