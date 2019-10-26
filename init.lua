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

--print("Example mod init done")



function OnPlayerSpawned( player_entity )
	-- Add two wands for debug testing to players inventory
	local inventory = nil
	local player_child_entities = EntityGetAllChildren( player_entity )
	if ( player_child_entities ~= nil ) then
		for i,child_entity in ipairs( player_child_entities ) do
			local child_entity_name = EntityGetName( child_entity )
			
			if ( child_entity_name == "inventory_quick" ) then
				inventory = child_entity
			end
		end
	end

	if ( inventory ~= nil ) then
		local inventory_items = EntityGetAllChildren( inventory )

		-- local wand1 = EntityLoad("data/entities/items/wand_level_02.xml")
		--[[ local wand1 = EntityLoad("mods/starting_loadouts/files/fire/wands/wand_1.xml")
		local wand2 = EntityLoad("data/entities/items/wand_level_02.xml")
		EntityAddChild( inventory, wand1 )
		EntityAddChild( inventory, wand2 ) ]]
	end
end


