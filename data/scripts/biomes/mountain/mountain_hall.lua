-- default biome functions that get called if we can't find a a specific biome that works for us
CHEST_LEVEL = 8
dofile("data/scripts/director_helpers.lua")
dofile("data/scripts/biomes/mountain/mountain.lua")
dofile("data/scripts/lib/utilities.lua")

function spawn_wands( x, y ) end
function spawn_potions( x, y ) end

RegisterSpawnFunction( 0xffffeedd, "init" )
-- RegisterSpawnFunction( 0xffFF5A00, "spawn_crate" )
RegisterSpawnFunction( 0xffFF2D00, "spawn_waterspout" )
RegisterSpawnFunction( 0xffFF5A0A, "spawn_f_trigger" )
RegisterSpawnFunction( 0xffFF5A0B, "spawn_i_trigger" )
RegisterSpawnFunction( 0xffFF5A0C, "spawn_f" )
RegisterSpawnFunction( 0xffFF5A0D, "spawn_i" )
RegisterSpawnFunction( 0xffFF5A1A, "spawn_inventory" )
RegisterSpawnFunction( 0xffFF5A1B, "spawn_inventory_trigger" )
RegisterSpawnFunction( 0xffff5a0f, "spawn_music_trigger" )

RegisterSpawnFunction( 0xfffb0d50, "spawn_anvil_altar" )
RegisterSpawnFunction( 0xffff0047, "spawn_anvil" )

function spawn_anvil_altar( x, y )
	local w = 184
	local h = 96
	-- In the context of LoadPixelScene, x, y refers to the top left of the image
	LoadPixelScene( "mods/mymod/files/altar.png", "data/biome_impl/altar_visual.png", x - (w / 2), y - h + 10, "", true )
	-- LoadPixelScene( "mods/mymod/files/altar.png", "data/biome_impl/altar_visual.png", x , y, "", true )
	-- data/biome_impl/altar_visual.png
end

function spawn_anvil( x, y )
	local w = 78
	local h = 37
	-- EntityLoad("mods/mymod/files/entities/anvil.xml", x - (w / 2), y - h)
	-- In the context of EntityLoad, x, y refers to the center of the image if PhysicsImageShapeComponent::centered is 1 otherwise top left
	EntityLoad("mods/mymod/files/entities/anvil.xml", x, y - (h / 2))
	-- EntityLoad("mods/mymod/files/rune_emitter.xml", x, y - (h / 2))
end





g_small_enemies_helpless =
{
	total_prob = 0,
	-- this is air, so nothing spawns at 0.6
	{
		prob   		= 0.4,
		min_count	= 0,
		max_count	= 0,    
		entity 	= ""
	},
	-- add skullflys after this step
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/sheep.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 2,    
		entity 	= "data/entities/animals/deer.xml"
	},
	{
		prob   		= 0.2,
		min_count	= 1,
		max_count	= 1,    
		entity 	= "data/entities/animals/elk.xml"
	},
	{
		prob   		= 0.4,
		min_count	= 1,
		max_count	= 5,    
		entity 	= "data/entities/animals/duck.xml"
	},
}

g_crate =
{
	total_prob = 0,
	--[[
	{
		prob   		= 0.5,
		min_count	= 1,
		max_count	= 1,    
		offset_y 	= 0,
		entity 	= "data/entities/props/physics_box_explosive.xml"
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
	]]--
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
		prob   		= 0.005,
		min_count	= 1,
		max_count	= 1,
		offset_y 	= -7,    
		entity 	= "data/entities/props/physics_skateboard.xml"
	},
}

function init( x, y, w, h )
	if GameGetIsGamepadConnected() then
		LoadPixelScene( "data/biome_impl/mountain_hall.png", "data/biome_impl/mountain_hall_visual.png", x, y, "data/biome_impl/mountain_hall_background_gamepad_updated.png", true )
	else
		LoadPixelScene( "data/biome_impl/mountain_hall.png", "data/biome_impl/mountain_hall_visual.png", x, y, "data/biome_impl/mountain_hall_background.png", true )
	end
	
	LoadPixelScene( "data/biome_impl/mountain_hall_instructions.png", "", x, y, "", true )
	
	LoadPixelScene( "data/biome_impl/mountain_hall_b.png", "data/biome_impl/mountain_hall_b_visual.png", x, y+512, "", true )
	LoadPixelScene( "data/biome_impl/mountain_hall_br.png", "data/biome_impl/mountain_hall_br_visual.png", x+512, y+512, "", true )
	LoadPixelScene( "data/biome_impl/mountain_hall_r.png", "data/biome_impl/mountain_hall_r_visual.png", x+512, y, "", true )
	LoadPixelScene( "data/biome_impl/mountain_hall_bottom.png", "", x-512, y+512, "", true )
	LoadPixelScene( "data/biome_impl/mountain_hall_bottom_2.png", "", x+552, y+512, "", true )
	
	load_verlet_rope_with_two_joints("data/entities/verlet_chains/vines/verlet_vine_pixelscene.xml", x+139, y+300, x+175, y+281)
	load_verlet_rope_with_two_joints("data/entities/verlet_chains/vines/verlet_vine_pixelscene.xml", x+302, y+341, x+348, y+345)
	load_verlet_rope_with_two_joints("data/entities/verlet_chains/vines/verlet_vine_pixelscene.xml", x+325, y+342, x+374, y+371)
	load_verlet_rope_with_two_joints("data/entities/verlet_chains/vines/verlet_vine_long_pixelscene.xml", x+216, y+278, x+272, y+314)
	
	load_verlet_rope_with_one_joint("data/entities/verlet_chains/vines/verlet_vine_short_pixelscene.xml", x+243, y+285)
	load_verlet_rope_with_one_joint("data/entities/verlet_chains/vines/verlet_vine_short_pixelscene.xml", x+281, y+325)
	load_verlet_rope_with_one_joint("data/entities/verlet_chains/vines/verlet_vine_short_pixelscene.xml", x+356, y+354)
	load_verlet_rope_with_one_joint("data/entities/verlet_chains/vines/verlet_vine_shorter_pixelscene.xml", x+184, y+276)
	load_verlet_rope_with_one_joint("data/entities/verlet_chains/vines/verlet_vine_shorter_pixelscene.xml", x+286, y+331)
end

function spawn_small_enemies(x, y) end

function spawn_crate(x, y)
	spawn(g_crate,x,y)
end

function spawn_waterspout(x, y)
	EntityLoad("data/entities/props/dripping_water.xml", x, y)
end

function spawn_chest(x, y)
	--EntityLoadCameraBound( "data/entities/items/building_chest_stash.xml", x, y )
	-- entity_load("data/entities/items/building_chest_stash.xml")
	-- entity_load_chest(x,y,"chest_tutorial",8)
end

function spawn_f( x, y )
	if (GameGetIsGamepadConnected() == false) then
		EntityLoad( "data/entities/particles/image_emitters/controls_f.xml", x, y )
	else
		EntityLoad( "data/entities/particles/image_emitters/controls_stickpress.xml", x+1, y )
	end
end

function spawn_i( x, y )
	if (GameGetIsGamepadConnected() == false) then
		EntityLoad( "data/entities/particles/image_emitters/controls_i.xml", x, y )
	else
		EntityLoad( "data/entities/particles/image_emitters/controls_back.xml", x-1, y+1 )
	end
end

function spawn_inventory( x, y )
	if (GameGetIsGamepadConnected() == false) then
		EntityLoad( "data/entities/particles/image_emitters/controls_inventory.xml", x, y )
	else
		EntityLoad( "data/entities/particles/image_emitters/controls_inventory_gamepad.xml", x, y )
	end
end

function spawn_f_trigger( x, y )
	EntityLoad( "data/entities/buildings/controls_f_trigger.xml", x, y )
end

function spawn_i_trigger( x, y )
	EntityLoad( "data/entities/buildings/controls_i_trigger.xml", x, y )
end

function spawn_inventory_trigger( x, y )
	EntityLoad( "data/entities/buildings/controls_inventory_trigger.xml", x, y )
end

function spawn_music_trigger( x, y )
	EntityLoad( "data/entities/buildings/music_trigger_mountain_hall.xml", x, y )
end