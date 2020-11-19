dofile("mods/anvil_of_destiny/files/scripts/spawner.lua")
dofile("mods/anvil_of_destiny/files/scripts/probability_util.lua")
dofile("mods/anvil_of_destiny/files/scripts/wang_utils.lua")
dofile("mods/anvil_of_destiny/config.lua")
--[[ This is a scene which loads the altar pixel scene which loads the anvil ]]

local wang_tile_short_side = 220
local wang_tile_count_h = 18
local wang_tile_count_v = 12
local custom_pixel_scene_count_h = 0 -- out of how many h tiles, how many load our pixel scene?
local custom_pixel_scene_count_v = 1
local probability_to_replace_pixelscene = occurence_rate_to_probability(wang_tile_short_side, wang_tile_count_h, wang_tile_count_v,
  custom_pixel_scene_count_h, custom_pixel_scene_count_v, config_altar_room_occurences_pyramid)

if probability_to_replace_pixelscene > 1 then
  print("AOD: We need more pixel scenes for pyramid!")
  local max_prob = 1 / occurence_rate_to_probability(wang_tile_short_side, wang_tile_count_h, wang_tile_count_v,
    custom_pixel_scene_count_h, custom_pixel_scene_count_v, 1)
  print("max_prob for pyramid: " .. max_prob)
end

local probability = ANVIL_OF_DESTINY_PROB or get_probability_value_for_inserting(g_pixel_scene_03, probability_to_replace_pixelscene)

table.insert(g_pixel_scene_03, {
  prob   		    	= probability,
  material_file 	= "mods/anvil_of_destiny/files/loader_scenes/pyramid.png",
  visual_file		  = "",
  background_file	= "",
  is_unique		    = 0
})
