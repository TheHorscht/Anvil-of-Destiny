dofile("mods/mymod/files/debug/dummy_spawners.lua")
dofile("mods/mymod/files/spawner.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )

function init( x, y, w, h )
  LoadPixelScene("mods/mymod/files/debug/debug_room_neutral.png", "", x, y, "", true)
end