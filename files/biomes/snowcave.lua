dofile("mods/anvil_of_destiny/files/spawner.lua")
dofile("mods/anvil_of_destiny/files/probability_util.lua")
dofile("mods/anvil_of_destiny/files/wang_utils.lua")
dofile("mods/anvil_of_destiny/anvil_of_destiny_config.lua")
--[[ This is a scene which loads the altar pixel scene which loads the anvil ]]

local wang_tile_short_side = 260
local chunk_count = 30
local wang_tile_count_h = 32
local wang_tile_count_v = 32
local custom_pixel_scene_count_h = 1
local custom_pixel_scene_count_v = 0
local probability_to_replace_pixelscene = occurence_rate_to_probability(wang_tile_short_side, chunk_count, wang_tile_count_h, wang_tile_count_v,
  custom_pixel_scene_count_h, custom_pixel_scene_count_v, config_altar_room_occurences_snowcave)

if probability_to_replace_pixelscene > 1 then
  print("AOD: We need more pixel scenes for snowcave!")
end

table.insert(g_pixel_scene_02, {
  prob   		    	= get_probability_value_for_inserting(g_pixel_scene_02, probability_to_replace_pixelscene),
  material_file 	= "mods/anvil_of_destiny/files/altar_loader_snowcave.png",
  visual_file		  = "",
  background_file	= "",
  is_unique		    = 0
})
