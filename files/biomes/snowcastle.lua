dofile("mods/anvil_of_destiny/files/spawner.lua")
dofile("mods/anvil_of_destiny/files/probability_util.lua")
dofile("mods/anvil_of_destiny/anvil_of_destiny_config.lua")
--[[ This is a scene which loads the altar pixel scene which loads the anvil ]]
table.insert(g_pixel_scene_02, {
  prob   		    	= get_probability_value_for_inserting(g_pixel_scene_02, config_altar_room_spawn_probability_snowcastle),
  material_file 	= "mods/anvil_of_destiny/files/altar_loader_snowcastle.png",
  visual_file		  = "",
  background_file	= "",
  is_unique		    = 0
})
