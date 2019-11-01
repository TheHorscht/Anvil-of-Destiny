dofile("mods/anvil_of_destiny/files/debug/dummy_spawners.lua")
dofile("mods/anvil_of_destiny/files/spawner.lua")

RegisterSpawnFunction( 0xffffeedd, "init" )
RegisterSpawnFunction( 0xff37ec48, "spawn_tablet")
RegisterSpawnFunction( 0xff37ec1f, "spawn_coalmine_wand")
RegisterSpawnFunction( 0xff37ec31, "spawn_wand_1")
RegisterSpawnFunction( 0xff37ec32, "spawn_wand_2")
RegisterSpawnFunction( 0xff37ec33, "spawn_wand_3")
RegisterSpawnFunction( 0xff37ec34, "spawn_wand_4")
RegisterSpawnFunction( 0xff37ec35, "spawn_wand_5")
RegisterSpawnFunction( 0xff37ec36, "spawn_wand_6")
RegisterSpawnFunction( 0xff37ec21, "spawn_wand_1_no_shuffle")
RegisterSpawnFunction( 0xff37ec22, "spawn_wand_2_no_shuffle")
RegisterSpawnFunction( 0xff37ec23, "spawn_wand_3_no_shuffle")
RegisterSpawnFunction( 0xff37ec24, "spawn_wand_4_no_shuffle")
RegisterSpawnFunction( 0xff37ec25, "spawn_wand_5_no_shuffle")
RegisterSpawnFunction( 0xff37ec26, "spawn_wand_6_no_shuffle")

function init( x, y, w, h )
  LoadPixelScene("mods/anvil_of_destiny/files/debug/debug_room_neutral.png", "", x, y, "", true)
end

function spawn_tablet(x, y)
  EntityLoad("data/entities/items/books/book_01.xml", x, y)
end

function spawn_coalmine_wand(x, y)
  EntityLoad("data/entities/items/wands/level_01/wand_00"..Random(1, 9)..".xml", x, y)
end

function spawn_wand_1(x, y)
  EntityLoad("data/entities/items/wand_level_01.xml", x, y)
end

function spawn_wand_2(x, y)
  EntityLoad("data/entities/items/wand_level_02.xml", x, y)
end

function spawn_wand_3(x, y)
  EntityLoad("data/entities/items/wand_level_03.xml", x, y)
end

function spawn_wand_4(x, y)
  EntityLoad("data/entities/items/wand_level_04.xml", x, y)
end

function spawn_wand_5(x, y)
  EntityLoad("data/entities/items/wand_level_05.xml", x, y)
end

function spawn_wand_6(x, y)
  EntityLoad("data/entities/items/wand_level_06.xml", x, y)
end

function spawn_wand_1_no_shuffle(x, y)
  EntityLoad("data/entities/items/wand_unshuffle_01.xml", x, y)
end

function spawn_wand_2_no_shuffle(x, y)
  EntityLoad("data/entities/items/wand_unshuffle_02.xml", x, y)
end

function spawn_wand_3_no_shuffle(x, y)
  EntityLoad("data/entities/items/wand_unshuffle_03.xml", x, y)
end

function spawn_wand_4_no_shuffle(x, y)
  EntityLoad("data/entities/items/wand_unshuffle_04.xml", x, y)
end

function spawn_wand_5_no_shuffle(x, y)
  EntityLoad("data/entities/items/wand_unshuffle_05.xml", x, y)
end

function spawn_wand_6_no_shuffle(x, y)
  EntityLoad("data/entities/items/wand_unshuffle_06.xml", x, y)
end

