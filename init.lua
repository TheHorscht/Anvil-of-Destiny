-- all functions below are optional and can be left out

--[[

function OnModPreInit()
	print("Mod - OnModPreInit()") -- First this is called for all mods
end

function OnModInit()
	print("Mod - OnModInit()") -- After that this is called for all mods
end

function OnModPostInit()
	print("Mod - OnModPostInit()") -- Then this is called for all mods
end

function OnPlayerSpawned( player_entity ) -- This runs when player entity has been created
	GamePrint( "OnPlayerSpawned() - Player entity id: " .. tostring(player_entity) )
end

function OnWorldInitialized() -- This is called once the game world is initialized. Doesn't ensure any world chunks actually exist. Use OnPlayerSpawned to ensure the chunks around player have been loaded or created.
	GamePrint( "OnWorldInitialized() " .. tostring(GameGetFrameNum()) )
end

function OnWorldPreUpdate() -- This is called every time the game is about to start updating the world
	GamePrint( "Pre-update hook " .. tostring(GameGetFrameNum()) )
end

function OnWorldPostUpdate() -- This is called every time the game has finished updating the world
	GamePrint( "Post-update hook " .. tostring(GameGetFrameNum()) )
end

]]--

-- This code runs when all mods' filesystems are registered

-- function OnWorldPostUpdate() -- This is called every time the game has finished updating the world
	-- GamePrint( BiomeMapGetName() )
-- end

--[[

ModLuaFileAppend( "data/scripts/gun/gun_actions.lua", "mods/example/files/actions.lua" ) -- Basically dofile("mods/example/files/actions.lua") will appear at the end of gun_actions.lua
ModMagicNumbersFileAdd( "mods/example/files/magic_numbers.xml" ) -- Will override some magic numbers using the specified file
ModRegisterAudioEventMappings( "mods/example/files/audio_events.txt" ) -- Use this to register custom fmod events. Event mapping files can be generated via File -> Export GUIDs in FMOD Studio.
ModMaterialsFileAdd( "mods/example/files/materials_rainbow.xml" ) -- Adds a new 'rainbow' material to materials

]]

-- ModMagicNumbersFileAdd( "mods/anvil_of_destiny/files/magic_numbers.xml" ) -- Will override some magic numbers using the specified file

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

function OnPlayerSpawned(player_entity)
	local inventory_id = EntityGetWithName("inventory_quick")
	local inventory_contents = EntityGetAllChildren(inventory_id)
	if inventory_contents ~= nil then

		local function is_wand(entity_id)
			local comp = EntityGetComponent(entity_id, "ManaReloaderComponent")
			return comp ~= nil
		end

		for i,id in ipairs(inventory_contents) do
			if not EntityHasTag(id, "wand_level_0") and is_wand(id) then
				if not EntityHasTag(id, "wand") then
					EntityAddTag(id, "wand")
				end
				EntityAddTag(id, "wand_level_0")
			end
		end
	end
end
