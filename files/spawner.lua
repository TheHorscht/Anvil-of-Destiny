RegisterSpawnFunction( 0xfffb0d50, "spawn_anvil_altar")
RegisterSpawnFunction( 0xffff0047, "spawn_anvil")	

function spawn_anvil_altar( x, y )
	local w = 184
	local h = 96
	LoadPixelScene("mods/anvil_of_destiny/files/entities/altar/altar.png", "mods/anvil_of_destiny/files/entities/altar/altar_visual.png", x - (w / 2), y - h + 1, "mods/anvil_of_destiny/files/entities/altar/altar_background.png", true )
end

function spawn_anvil( x, y )
	local w = 78
	local h = 37
	EntityLoad("mods/anvil_of_destiny/files/entities/anvil/anvil.xml", x, y - (h / 2) + 1)
end
