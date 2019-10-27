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

ModRegisterAudioEventMappings( "mods/mymod/fmod/Build/GUIDs.txt" )
ModMagicNumbersFileAdd("mods/mymod/files/magic_numbers.xml")
ModLuaFileAppend("data/scripts/biomes/coalmine.lua", "mods/mymod/files/biomes/coalmine.lua" )
ModLuaFileAppend("data/scripts/biomes/excavationsite.lua", "mods/mymod/files/biomes/excavationsite.lua" )
ModLuaFileAppend("data/scripts/biomes/crypt.lua", "mods/mymod/files/biomes/crypt.lua" )
ModLuaFileAppend("data/scripts/biomes/pyramid.lua", "mods/mymod/files/biomes/pyramid.lua" )
ModLuaFileAppend("data/scripts/biomes/rainforest.lua", "mods/mymod/files/biomes/rainforest.lua" )
ModLuaFileAppend("data/scripts/biomes/snowcastle.lua", "mods/mymod/files/biomes/snowcastle.lua" )
ModLuaFileAppend("data/scripts/biomes/snowcave.lua", "mods/mymod/files/biomes/snowcave.lua" )
ModLuaFileAppend("data/scripts/biomes/vault.lua", "mods/mymod/files/biomes/vault.lua" )
