function get_wang_tiles_placed_per_chunk(wang_tile_short_side)
	local chunk_size = 512
	local chunk_area = chunk_size * chunk_size
	local wang_tile_area = wang_tile_short_side * wang_tile_short_side * 2
	
	return chunk_area / wang_tile_area
end

-- Returns the probability that a pixel scene has to spawn at in order to occure given times
-- If return value is higher than 1 we don't have enough custom pixelscenes to support that occurence rate
function occurence_rate_to_probability(wang_tile_short_side, wang_tile_count_h, wang_tile_count_v, custom_pixel_scene_count_h, custom_pixel_scene_count_v, desired_occurences)
	local chance_to_pick_custom_pixel_scene_h = 1 / (wang_tile_count_h / custom_pixel_scene_count_h)
	local chance_to_pick_custom_pixel_scene_v = 1 / (wang_tile_count_v / custom_pixel_scene_count_v)
	local chance_to_pick_custom_pixel_scene_total = (chance_to_pick_custom_pixel_scene_h + chance_to_pick_custom_pixel_scene_v) / 2
	local wang_tiles_placed_per_chunk = get_wang_tiles_placed_per_chunk(wang_tile_short_side)

	return desired_occurences / (chance_to_pick_custom_pixel_scene_total * wang_tiles_placed_per_chunk)
end
