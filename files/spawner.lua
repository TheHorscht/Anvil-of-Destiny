RegisterSpawnFunction( 0xfffb0d50, "spawn_anvil_altar" )
RegisterSpawnFunction( 0xffff0047, "spawn_anvil" )

function spawn_anvil_altar( x, y )
	local w = 184
	local h = 96
	LoadPixelScene( "mods/mymod/files/altar.png", "mods/mymod/files/altar_visual.png", x - (w / 2), y - h + 1, "mods/mymod/files/altar_background.png", true )
end

function spawn_anvil( x, y )
	local w = 78
	local h = 37
	EntityLoad("mods/mymod/files/entities/anvil.xml", x, y - (h / 2))
end
