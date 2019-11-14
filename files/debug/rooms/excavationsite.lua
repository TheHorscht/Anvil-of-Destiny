dofile("mods/anvil_of_destiny/files/debug/dummy_spawners.lua")
dofile("mods/anvil_of_destiny/files/spawner.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )

function init( x, y, w, h )
  local biome_chunk_size = 512
  local wang_w = 400
  local wang_h = wang_w / 2
  LoadPixelScene("mods/anvil_of_destiny/files/altar_loader_excavationsite.png", "", x + (biome_chunk_size / 2) - (wang_w / 2), y + (biome_chunk_size / 2) - (wang_h / 2), "", true)
end