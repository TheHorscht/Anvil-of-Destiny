dofile("mods/anvil_of_destiny/files/spawner.lua")
dofile("mods/anvil_of_destiny/files/probability_util.lua")
--[[ This is a scene which loads the altar pixel scene which loads the anvil ]]
table.insert(g_pixel_scene_04_alt, {
  prob   		    	= get_probability_value_for_inserting(g_pixel_scene_04_alt, 50),
  material_file 	= "mods/anvil_of_destiny/files/altar_loader_excavationsite.png",
  visual_file		  = "",
  background_file	= "",
  is_unique		    = 0
})
