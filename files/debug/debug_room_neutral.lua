dofile("mods/anvil_of_destiny/files/debug/dummy_spawners.lua")
dofile("mods/anvil_of_destiny/files/spawner.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )

function init( x, y, w, h )
  LoadPixelScene("mods/anvil_of_destiny/files/debug/debug_room_neutral.png", "", x, y, "", true)
end