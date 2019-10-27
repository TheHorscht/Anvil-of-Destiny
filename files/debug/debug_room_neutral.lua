dofile("data/scripts/biome_scripts.lua")
dofile( "mods/mymod/files/spawner.lua" )

RegisterSpawnFunction( 0xffffeedd, "init" )

function init( x, y, w, h )
  LoadPixelScene("mods/mymod/files/debug/debug_room_neutral.png", "", x, y, "", true)
end