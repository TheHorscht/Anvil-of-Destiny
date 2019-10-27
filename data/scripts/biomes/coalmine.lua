-- default biome functions that get called if we can't find a a specific biome that works for us
-- The level of action ids that are spawned from the chests
CHEST_LEVEL = 1
dofile("data/scripts/director_helpers.lua")
dofile("data/scripts/director_helpers_design.lua")
dofile("data/scripts/biome_scripts.lua")
dofile( "data/scripts/items/generate_shop_item.lua" )
dofile( "mods/mymod/files/spawner.lua" )

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xff0000ff, "spawn_nest" )
RegisterSpawnFunction( 0xffB40000, "spawn_fungi" )
RegisterSpawnFunction( 0xff969678, "load_structures" )
RegisterSpawnFunction( 0xff967878, "load_large_structures" )
RegisterSpawnFunction( 0xff967896, "load_i_structures" )
RegisterSpawnFunction( 0xff80FF5A, "spawn_vines" )
RegisterSpawnFunction( 0xffC35700, "load_oiltank" )
RegisterSpawnFunction( 0xff55AF4B, "load_altar" )
RegisterSpawnFunction( 0xff23B9C3, "spawn_altar_torch" )
RegisterSpawnFunction( 0xff55AF8C, "spawn_skulls" )
RegisterSpawnFunction( 0xff55FF8C, "spawn_chest" )
RegisterSpawnFunction( 0xff4e175e, "load_oiltank_alt" )
RegisterSpawnFunction( 0xff33934c, "spawn_shopitem" )
RegisterSpawnFunction( 0xff50fafa, "spawn_trapwand" )

------------ small enemies -------------------------------

function init( x, y, w, h )
	-- LoadPixelScene( "mods/mymod/files/metroid2.png", "mods/mymod/files/metroid.png", x, y - 32, "data/biome_impl/pyramid_hallway_background.png", true )
end

g_small_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.1,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/zombie_weak.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/slimeshooter_weak.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 3,    
		entity 	= "data/entities/animals/longleg.xml"
	},
	{
		prob   		= 0.25,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/miner_weak.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/shotgunner_weak.xml"
	},
	-- Demo case for Arvi
	--[[
	{
		prob 		= 10,
		min_count	= 1,
		max_count 	= 1,
		entities = {
			{
				min_count	= 1,
				max_count 	= 5,
				entity = "data/entities/animals/shotgunner.xml",
			},
			{
				min_count = 10,
				max_count= 12,
				entity = "data/entities/animals/roboguard.xml",
			},
			"data/entities/items/chest_stash.xml",
		}
	},
	]]--
}

g_big_enemies =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.7,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/firemage_weak.xml"
	},
	{
		prob   		= 0.01,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/worm.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 5,
		max_count	= 10,    
		entity 	= "data/entities/animals/longleg.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entities 	= {
			"data/entities/animals/miner_weak.xml",
			"data/entities/animals/miner_weak.xml",
			"data/entities/animals/shotgunner_weak.xml",
		}
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/miner_santa.xml",
		spawn_check = function() return false end
	},
	{
		prob   		= 0.12,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/shotgunner_weak.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/acidshooter_weak.xml"
	},
	{
		prob   		= 0.08,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/giantshooter_weak.xml"
	},
	{
		prob   		= 0.09,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/fireskull.xml"
	},	
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/miner_santa.xml",
		spawn_check = function() 
			if false then -- if( os.date("%d%m") == "2412" ) then
				return true 
			else 
				return false 
			end 
		end
	},
}

g_lamp =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 0.7,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/props/physics_lantern_small.xml"
	},
}

---------- UNIQUE ENCOUNTERS ---------------

g_unique_enemy =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.0,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 3,    
		entity 	= "data/entities/animals/slimeshooter_weak.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/acidshooter_weak.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/giantshooter_weak.xml"
	},
}

g_unique_enemy2 =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 1.5,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/miner_santa.xml",
		spawn_check = function() 
			if false then --if( os.date("%d%m") == "2412" ) then
				return true 
			else 
				return false 
			end 
		end

	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/shotgunner_weak.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 2,
		max_count	= 2,    
		entity 	= "data/entities/animals/miner_weak.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/slimeshooter_weak.xml"
	},
}

g_unique_enemy3 =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.0,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.7,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/firemage_weak.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/alchemist.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/thundermage.xml"
	},
}

g_fungi =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.5,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/fungus.xml"
	},
	{
		prob   		= 0.05,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/fungus_big.xml"
	},
}

------------ items -------------------------------

g_items =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wands/level_01/wand_001.xml"
	},
	{
		prob   		= 1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wands/level_01/wand_002.xml"
	},
	{
		prob   		= 1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wands/level_01/wand_003.xml"
	},
	{
		prob   		= 1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wands/level_01/wand_004.xml"
	},
	{
		prob   		= 1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wands/level_01/wand_005.xml"
	},
	{
		prob   		= 1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wands/level_01/wand_006.xml"
	},
	{
		prob   		= 1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wands/level_01/wand_007.xml"
	},
	{
		prob   		= 1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wands/level_01/wand_008.xml"
	},
	{
		prob   		= 1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wands/level_01/wand_009.xml"
	},
	{
		prob   		= 1,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/items/wand_level_01.xml"
	},
}

--- barrels ---

g_props =
{
	total_prob = 0,
	{
		prob   		= 0.2,
		min_count	= 0,
		max_count	= 0,
		offset_y 	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= 0,
		entity 	= "data/entities/props/physics_box_explosive.xml"
	},
	{
		prob   		= 0.25,
		min_count	= 1,
		max_count	= 1,
		offset_y 	= -5,    
		entity 	= "data/entities/props/physics_minecart.xml"
	},
	{
		prob   		= 0.25,
		min_count	= 1,
		max_count	= 1,
		offset_y 	= -5,    
		entity 	= "data/entities/props/physics_cart.xml"
	},
	{
		prob   		= 0.1,
		min_count	= 1,
		max_count	= 1,
		offset_y 	= 0,    
		entity 	= "data/entities/props/physics_barrel_radioactive.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,
		offset_y 	= 0,    
		entity 	= "data/entities/props/physics_barrel_oil.xml"
	},
}

g_props2 =
{
	total_prob = 0,
	{
		prob   		= 0.5,
		min_count	= 0,
		max_count	= 0,
		offset_y 	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/physics_minecart.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/physics_brewing_stand.xml"
	},
}

g_props3 =
{
	total_prob = 0,
	{
		prob   		= 0.1,
		min_count	= 0,
		max_count	= 0,
		offset_y 	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/items/pickup/potion.xml"
	},
	--[[
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/physics_bottle_green.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/physics_bottle_red.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/physics_bottle_blue.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/physics_bottle_yellow.xml"
	},
	]]--
}

--- pixelscenes ---

g_pixel_scene_01 =
{
	total_prob = 0,
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine_coalpit01.png",
		visual_file		= "data/biome_impl/coalmine_coalpit01_visual.png",
		background_file	= "",
		is_unique		= 0,
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine_coalpit02.png",
		visual_file		= "data/biome_impl/coalmine_coalpit02_visual.png",
		background_file	= "",
		is_unique		= 0,
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine_carthill.png",
		visual_file		= "data/biome_impl/coalmine_carthill_visual.png",
		background_file	= "",
		is_unique		= 0,
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine_coalpit03.png",
		visual_file		= "data/biome_impl/coalmine_coalpit03_visual.png",
		background_file	= "",
		is_unique		= 0,
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine_coalpit04.png",
		visual_file		= "data/biome_impl/coalmine_coalpit04_visual.png",
		background_file	= "",
		is_unique		= 0,
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine_coalpit05.png",
		visual_file		= "data/biome_impl/coalmine_coalpit05_visual.png",
		background_file	= "",
		is_unique		= 0,
	},
}

g_pixel_scene_02 =
{
	total_prob = 0,
	--[[ This is a scene which loads the altar pixel scene which loads the anvil ]]
	-- TODO: Tweak the probability and maybe refactor this into a function that adds this less intrusively
	{
		prob   			= 4000.0,
		material_file 	= "mods/mymod/files/altar_loader_coalmine.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine_shrine01.png",
		visual_file		= "data/biome_impl/coalmine_shrine01_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine_shrine02.png",
		visual_file		= "data/biome_impl/coalmine_shrine02_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine_slimepit.png",
		visual_file		= "data/biome_impl/coalmine_slimepit_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine_laboratory.png",
		visual_file		= "data/biome_impl/coalmine_laboratory_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine_swarm.png",
		visual_file		= "data/biome_impl/coalmine_swarm_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.5,
		material_file 	= "data/biome_impl/coalmine_symbolroom.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.2,
		material_file 	= "data/biome_impl/coalmine_physics_01.png",
		visual_file		= "data/biome_impl/coalmine_physics_01_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.2,
		material_file 	= "data/biome_impl/coalmine_physics_02.png",
		visual_file		= "data/biome_impl/coalmine_physics_02_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.2,
		material_file 	= "data/biome_impl/coalmine_physics_03.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.75,
		material_file 	= "data/biome_impl/coalmine_shop.png",
		visual_file		= "data/biome_impl/coalmine_shop_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 0.1,
		material_file 	= "data/biome_impl/coalmine_radioactivecave.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.5,
		material_file 	= "data/biome_impl/coalmine_wandtrap_h_02.png",
		visual_file		= "data/biome_impl/coalmine_wandtrap_h_02_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.5,
		material_file 	= "data/biome_impl/coalmine_wandtrap_h_04.png",
		visual_file		= "data/biome_impl/coalmine_wandtrap_h_04_visual.png",
		background_file	= "",
		is_unique		= 0,
		color_material = { ["fff0bbee"] = { "oil", "alcohol", "gunpowder_explosive", "oil", "alcohol", "oil", "alcohol" } }
	},
	{
		prob   			= 1.5,
		material_file 	= "data/biome_impl/coalmine_wandtrap_h_06.png",
		visual_file		= "data/biome_impl/coalmine_wandtrap_h_06_visual.png",
		background_file	= "",
		is_unique		= 0,
		color_material = { ["fff0bbee"] = { "magic_liquid_teleportation", "magic_liquid_polymorph", "magic_liquid_random_polymorph", "radioactive_liquid" } }
	},
	{
		prob   			= 1.5,
		material_file 	= "data/biome_impl/coalmine_wandtrap_h_07.png",
		visual_file		= "data/biome_impl/coalmine_wandtrap_h_06_visual.png",
		background_file	= "",
		is_unique		= 0,
		color_material = { ["fff0bbee"] = { "water", "oil", "alcohol", "radioactive_liquid" } }
	},
	--[[
	-- TODO( Petri ): Disabled the other wand traps for now, to test if this box2d electricty based wand trap is even a good idea
	{
		prob   			= 1.5,
		material_file 	= "data/biome_impl/coalmine_wandtrap_h_01.png",
		visual_file		= "data/biome_impl/coalmine_wandtrap_h_01_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	{
		prob   			= 1.5,
		material_file 	= "data/biome_impl/coalmine_wandtrap_h_03.png",
		visual_file		= "data/biome_impl/coalmine_wandtrap_h_03_visual.png",
		background_file	= "",
		is_unique		= 0
	},
	]]--
}

g_oiltank =
{
	total_prob = 0,
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/coalmine_oiltank_1.png",
		visual_file		= "data/biome_impl/coalmine_oiltank_1_visual.png",
		background_file	= "",
		is_unique		= 0,
		color_material = { ["fff0bbee"] = { "water", "oil", "water", "oil", "alcohol", "sand", "coal", "radioactive_liquid" } }
	},
	-- secret / magic materials tanker
	{
		prob   			= 0.0004,
		material_file 	= "data/biome_impl/coalmine_oiltank_1.png",
		visual_file		= "data/biome_impl/coalmine_oiltank_1_visual.png",
		background_file	= "",
		is_unique		= 0,
		color_material = { ["fff0bbee"] = { "magic_liquid_teleportation", "magic_liquid_polymorph", "magic_liquid_random_polymorph", "magic_liquid_berserk", "magic_liquid_charm", "magic_liquid_invisibility", "magic_liquid_hp_regeneration", "salt", "blood", "gold", "honey" } }
	},
	-- more common, but weirder
	{
		prob   			= 0.01,
		material_file 	= "data/biome_impl/coalmine_oiltank_2.png",
		visual_file		= "data/biome_impl/coalmine_oiltank_2_visual.png",
		background_file	= "",
		is_unique		= 0,
		color_material = { ["fff0bbee"] = { "blood_fungi", "blood_cold", "lava", "poison", "slime", "gunpowder_explosive", "soil", "salt", "blood", "cement" } }
	},

	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/coalmine_oiltank_2.png",
		visual_file		= "data/biome_impl/coalmine_oiltank_2_visual.png",
		background_file	= "",
		is_unique		= 0,
		color_material = { ["fff0bbee"] = { "water", "oil", "water", "oil", "alcohol", "oil", "coal", "radioactive_liquid" } }
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/coalmine_oiltank_3.png",
		visual_file		= "data/biome_impl/coalmine_oiltank_3_visual.png",
		background_file	= "",
		is_unique		= 0,
		color_material = { ["fff0bbee"] = { "water", "oil", "water", "oil", "alcohol", "water", "coal", "radioactive_liquid", "magic_liquid_teleportation" } }
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/coalmine_oiltank_4.png",
		visual_file		= "data/biome_impl/coalmine_oiltank_4_visual.png",
		background_file	= "",
		is_unique		= 0,
		color_material = { ["fff0bbee"] = { "water", "oil", "water", "oil", "alcohol", "sand", "coal", "radioactive_liquid", "magic_liquid_polymorph" } }
	},
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/coalmine_oiltank_5.png",
		visual_file		= "",
		background_file	= "",
		is_unique		= 0,
		color_material = { ["fff0bbee"] = { "water", "oil", "water", "oil", "alcohol", "radioactive_liquid", "coal", "radioactive_liquid" } }
	},
}

g_oiltank_alt =
{
	total_prob = 0,
	{
		prob   			= 1.0,
		material_file 	= "data/biome_impl/coalmine_oiltank_alt.png",
		visual_file		= "data/biome_impl/coalmine_oiltank_alt_visual.png",
		background_file	= "",
		color_material = { ["fff0bbee"] = { "water", "oil", "water", "oil", "alcohol", "sand", "radioactive_liquid", "radioactive_liquid", "magic_liquid_berserk" } }
	},
}

g_i_structures =
{
	total_prob = 0,
	{
		prob   		= 0.1,
		min_count	= 0,
		max_count	= 0,
		offset_y 	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/coalmine_i_structure_01.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/coalmine_i_structure_02.xml"
	},
}

g_structures =
{
	total_prob = 0,
	{
		prob   		= 0.1,
		min_count	= 0,
		max_count	= 0,
		offset_y 	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/coalmine_structure_01.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/coalmine_structure_01.xml"
	},
}

g_large_structures =
{
	total_prob = 0,
	{
		prob   		= 0.1,
		min_count	= 0,
		max_count	= 0,
		offset_y 	= 0,    
		entity 	= ""
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/coalmine_large_structure_01.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= -5,
		entity 	= "data/entities/props/coalmine_large_structure_02.xml"
	},
}

g_ghostlamp =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 1.0,
		min_count	= 1,
		max_count	= 1,  
		offset_y	= 10,
		entity 	= "data/entities/props/physics_chain_torch_ghostly.xml"
	},
}

g_candles =
{
	total_prob = 0,
	{
		prob   		= 0.33,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/physics_candle_1.xml"
	},
	{
		prob   		= 0.33,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/physics_candle_2.xml"
	},
	{
		prob   		= 0.33,
		min_count	= 1,
		max_count	= 1, 
		entity 	= "data/entities/props/physics_candle_3.xml"
	},
}

g_nest =
{
	total_prob = 0,
	-- add skullflys after this step
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/buildings/flynest.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
}

g_vines =
{
	total_prob = 0,
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/vines/verlet_vine.xml"
	},
	{
		prob   		= 0.3,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/vines/verlet_vine_long.xml"
	},
	{
		prob   		= 1.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= ""
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/vines/verlet_vine_short.xml"
	},
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/verlet_chains/vines/verlet_vine_shorter.xml"
	},
}


--------------

-- this is a special function tweaked for spawning things in coalmine
function spawn_items( pos_x, pos_y )

	local x_offset,y_offset = 5,5

	local r = ProceduralRandom( pos_x, pos_y )
	-- 20% is air, nothing happens
	if( r < 0.47 ) then return end
	r = ProceduralRandom( pos_x-11.431, pos_y+10.5257 )
	
	if( r < 0.755 ) then
	else
		LoadPixelScene( "data/biome_impl/wand_altar.png", "data/biome_impl/wand_altar_visual.png", pos_x-10+x_offset, pos_y-17+x_offset, "", true )
	end

	-- LoadPixelScene( "data/biome_impl/wand_altar.png", "data/biome_impl/wand_altar_visual.png", pos_x-10, pos_y-17, "", true )
end

-- actual functions that get called from the wang generator

function spawn_small_enemies(x, y, w, h, is_open_path)
	if( is_open_path ) then
		local r = ProceduralRandom( x, y )
		local spawn_percent = BiomeMapGetVerticalPositionInsideBiome( x, y )
		spawn_percent = ( 2.1 * spawn_percent ) + 0.2
		if( r > spawn_percent ) then return end
		spawn(g_small_enemies,x,y,0,0)
		--spawn_hp(g_small_enemies,x,y,0,0,0.4,"coalmines")
	else
		spawn(g_small_enemies,x,y,0,0)
		--spawn_hp(g_small_enemies,x,y,0,0,0.4,"coalmines")
	end
end

function spawn_big_enemies(x, y, w, h, is_open_path)
	if( is_open_path ) then
		local r = ProceduralRandom( x, y )
		local spawn_percent = BiomeMapGetVerticalPositionInsideBiome( x, y )
		spawn_percent = ( 1.75 * spawn_percent ) - 0.1
		if( r > spawn_percent ) then return end
		spawn(g_big_enemies,x,y,0,0)
		--spawn_hp(g_big_enemies,x,y,0,0,0.4,"coalmines")
	else
		spawn(g_big_enemies,x,y,0,0)
		--spawn_hp(g_big_enemies,x,y,0,0,0.4,"coalmines")
	end
end

function spawn_lamp(x, y)
	spawn(g_lamp,x,y+2,0,0)
end

function spawn_props(x, y)
	spawn(g_props,x,y-3,0,0)
end

function spawn_props2(x, y)
	spawn(g_props2,x,y-3,0,0)
end

function spawn_props3(x, y)
	spawn(g_props3,x,y,0,0)
end

function spawn_unique_enemy(x, y)
	spawn(g_unique_enemy,x,y)
end

function spawn_unique_enemy2(x, y)
	spawn(g_unique_enemy2,x,y)
end

function spawn_unique_enemy3(x, y)
	spawn(g_unique_enemy3,x,y)
end

function spawn_fungi(x, y)
	spawn(g_fungi,x,y)
end

function load_pixel_scene( x, y )
	load_random_pixel_scene( g_pixel_scene_01, x, y )
end

function load_pixel_scene2( x, y )
	load_random_pixel_scene( g_pixel_scene_02, x, y )
end

function load_oiltank( x, y )
	load_random_pixel_scene( g_oiltank, x, y )
end

function load_oiltank_alt( x, y )
	load_random_pixel_scene( g_oiltank_alt, x, y )
end

function load_altar( x, y )
	LoadPixelScene( "data/biome_impl/altar.png", "data/biome_impl/altar_visual.png", x-92, y-96, "", true )
	EntityLoad( "data/entities/buildings/altar.xml", x, y-32 )
end

function load_structures( x, y )
	spawn( g_structures, x, y-30, 0, 0 )
end

function load_large_structures( x, y )
	spawn( g_large_structures, x, y-30, 0, 0 )
end

function load_i_structures( x, y )
	spawn( g_i_structures, x, y-30, 0, 0 )
end

function spawn_stash(x,y)
end

function spawn_nest(x, y)
	spawn(g_nest,x+4,y)
end

function spawn_vines(x, y)
	spawn(g_vines,x+5,y+5)
end

function spawn_altar_torch(x, y)
	EntityLoad( "data/entities/props/altar_torch.xml", x-7, y-38 )
end

function spawn_chest(x, y)
	SetRandomSeed( x, y )
	local rnd = Random(1,100)
	
	if (rnd >= 70) then
		EntityLoad( "data/entities/items/pickup/chest_random.xml", x, y)
	elseif (rnd >= 85) then
		EntityLoad( "data/entities/items/pickup/chest_random.xml", x, y)
	end
end

function spawn_skulls(x, y) end

function spawn_shopitem( x, y )
	generate_shop_item( x, y, false, 1 )
end

function spawn_trapwand(x, y)
	local options = { "wands/level_01/wand_001", "wands/level_01/wand_002", "wands/level_01/wand_003", "wands/level_01/wand_004", "wands/level_01/wand_005", "wands/level_01/wand_006", "wands/level_01/wand_007", "wands/level_01/wand_008", "wands/level_01/wand_009", "wand_level_01" }
	SetRandomSeed( x, y )
	
	local rnd = Random( 1, #options )
	local wand_to_spawn = "data/entities/items/" .. options[rnd] .. ".xml"
	
	local wand_id = EntityLoad( wand_to_spawn, x, y)
	EntityAddTag( wand_id, "trap_wand" )
end