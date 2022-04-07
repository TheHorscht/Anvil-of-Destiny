function spawn_anvil_altar(x, y)
	local w = 184
	local h = 96
	LoadPixelScene("mods/anvil_of_destiny/files/entities/altar/altar.png", "mods/anvil_of_destiny/files/entities/altar/altar_visual.png", x - (w / 2), y - h + 1, "", true )
end

function spawn_anvil(x, y)
	local w = 78
	local h = 37
	EntityLoad("mods/anvil_of_destiny/files/entities/anvil/anvil.xml", x, y - h + 1)
	EntityLoad("mods/anvil_of_destiny/files/entities/anvil/potion_place.xml", x + 5, y - h + 1 - 10)
end

function spawn_statue_facing_right(x, y)
	local w = 36
	local h = 52
	EntityLoad("mods/anvil_of_destiny/files/entities/statue/statue_facing_right.xml", x - 19, y - 44)
end

function spawn_statue_facing_left(x, y)
	local w = 36
	local h = 52
	EntityLoad("mods/anvil_of_destiny/files/entities/statue/statue_facing_left.xml", x - 16, y - 44)
end
