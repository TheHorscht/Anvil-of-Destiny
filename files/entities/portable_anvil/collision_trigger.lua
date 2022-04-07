function collision_trigger( colliding_entity_id )
  dofile_once("mods/anvil_of_destiny/files/scripts/spawning_functions.lua")
  local entity_id = GetUpdatedEntityID()
  local pos_x, pos_y = EntityGetTransform(entity_id)
  
  local offset = -9

  -- GamePlaySound("mods/anvil_of_destiny/audio/anvil_of_destiny.bank", "building_done", pos_x, pos_y)
  GamePlaySound( "data/audio/Desktop/misc.bank", "misc/chest_dark_open", pos_x, pos_y)

  LoadPixelScene("mods/anvil_of_destiny/files/entities/portable_anvil/room.png",
    "mods/anvil_of_destiny/files/entities/portable_anvil/room_visual.png",
    pos_x - 125, pos_y - 100 + 9 + offset, "mods/anvil_of_destiny/files/entities/portable_anvil/room_background.png", true, false, {}, -50)
	
	-- props
  spawn_anvil_altar(pos_x, pos_y + 100 + offset)
  spawn_statue_facing_right(pos_x - 71, pos_y - 12 + 100 + offset)
  spawn_statue_facing_left(pos_x + 70, pos_y - 12 + 100 + offset)
  spawn_anvil(pos_x, pos_y - 30 + 3 + 100 + offset)
end
