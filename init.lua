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

ModMagicNumbersFileAdd( "mods/anvil_of_destiny/files/magic_numbers.xml" ) -- Will override some magic numbers using the specified file

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
			if not EntityHasTag(id, "wand_level_1") and is_wand(id) then
				if not EntityHasTag(id, "wand") then
					EntityAddTag(id, "wand")
				end
				EntityAddTag(id, "wand_level_1")
			end
		end
	end
end







--[[ 



27 tiles @ 512 x 512

27 * 3

Sind 81 tiles placed

1 in 24 chance für ein anvil pro placed tile

chunk_size = 512
chunk_area = chunk_size * chunk_size
chunk_count = 27
wang_tile_short_side = 200
wang_tile_area = wang_tile_short_side * wang_tile_short_side * 2
wang_tile_count_h = 32
wang_tile_count_v = 16
wang_tile_count_total = wang_tile_count_h + wang_tile_count_v

wang_tiles_placed_per_chunk = chunk_area / wang_tile_area
wang_tiles_placed_per_chunk = 3,2768
wang_tiles_placed_count_total = wang_tiles_placed_per_chunk * chunk_count
wang_tiles_placed_count_total = 81

custom_pixel_scene_count = 2
chance_to_pick_custom_pixel_scene = 1 / (wang_tile_count_total / custom_pixel_scene_count)

custom_pixel_scenes_spawned_at_100_percent_spawn_chance = chance_to_pick_custom_pixel_scene * wang_tiles_placed_count_total
custom_pixel_scenes_spawned_at_100_percent_spawn_chance = (1/24) * 81
custom_pixel_scenes_spawned_at_100_percent_spawn_chance = (1/24) * WHAT * 81
WHAT = 1
custom_pixel_scenes_spawned = (1/24) * 81 * x

custom_pixel_scenes_to_spawn / (1/24) * 81 = chance_to_use_in_insert_function

=============
RETURN THIS
chance_to_use_in_insert_function = 
custom_pixel_scenes_to_spawn / (chance_to_pick_custom_pixel_scene * wang_tiles_placed_count_total)
=============

2 = 3,375 * x
2 / 3,375 = x
x = 0,59259259259259259259259259259259
x = spawn chance die ich eintragen muss damit genau 2 spawnen


 ]]




















 --[[ 



27 tiles @ 512 x 512

27 * 3

Sind 81 tiles placed

1 in 24 chance für ein anvil pro placed tile

chunk_size = 512
chunk_area = chunk_size * chunk_size
chunk_count = 27
wang_tile_short_side = 200
wang_tile_area = wang_tile_short_side * wang_tile_short_side * 2
wang_tile_count_h = 32
wang_tile_count_v = 16
wang_tile_count_total = wang_tile_count_h + wang_tile_count_v

wang_tiles_placed_per_chunk = chunk_area / wang_tile_area
wang_tiles_placed_per_chunk = 3,2768
wang_tiles_placed_count_total = wang_tiles_placed_per_chunk * chunk_count
wang_tiles_placed_count_total = 81


custom_pixel_scene_count_h = 1
custom_pixel_scene_count_v = 1
chance_to_pick_custom_pixel_scene_h = 1 / (wang_tile_count_h / custom_pixel_scene_count_h)
chance_to_pick_custom_pixel_scene_v = 1 / (wang_tile_count_v / custom_pixel_scene_count_v)
chance_to_pick_custom_pixel_scene_total = chance_to_pick_custom_pixel_scene_h / 2 + chance_to_pick_custom_pixel_scene_v / 2

pixel_scene_loader_rooms_h = 2
pixel_scene_loader_rooms_v = 1
chance_to_pick_custom_pixel_scene_h_if_inserted_all = 1 / (wang_tile_count_h / pixel_scene_loader_rooms_h)
chance_to_pick_custom_pixel_scene_v_if_inserted_all = 1 / (wang_tile_count_v / pixel_scene_loader_rooms_v)
chance_to_pick_custom_pixel_scene_max = chance_to_pick_custom_pixel_scene_h_if_inserted_all / 2 + chance_to_pick_custom_pixel_scene_v_if_inserted_all / 2

custom_pixel_scenes_spawn_chance_max = chance_to_pick_custom_pixel_scene_max * wang_tiles_placed_count_total
custom_pixel_scenes_spawn_chance_max = (1/24) * 81
custom_pixel_scenes_spawn_chance_max = (1/24) * WHAT * 81
WHAT = 1
custom_pixel_scenes_spawned = (1/24) * 81 * x

custom_pixel_scenes_to_spawn / (1/24) * 81 = chance_to_use_in_insert_function

=============
RETURN THIS
chance_to_use_in_insert_function = 
custom_pixel_scenes_to_spawn / (chance_to_pick_custom_pixel_scene * wang_tiles_placed_count_total)
=============

2 = 3,375 * x
2 / 3,375 = x
x = 0,59259259259259259259259259259259
x = spawn chance die ich eintragen muss damit genau 2 spawnen


 ]]

function get_wang_tile_place_count(chunk_count, wang_tile_short_side, wang_tile_count_h, wang_tile_count_v)
	local chunk_size = 512
	local chunk_area = chunk_size * chunk_size
	local wang_tile_area = wang_tile_short_side * wang_tile_short_side * 2
	local wang_tile_count_total = wang_tile_count_h + wang_tile_count_v
	
	local wang_tiles_placed_per_chunk = chunk_area / wang_tile_area
	local wang_tiles_placed_count_total = wang_tiles_placed_per_chunk * chunk_count

	return wang_tiles_placed_count_total
end

print("wang_places: " .. get_wang_tile_place_count(1, 200, 32, 16))
