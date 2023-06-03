function spawn_anvil_altar(x, y, no_spawner_pixels)
	local w = 184
	local h = 96
	local s = ""
	if no_spawner_pixels == true then
		s = "_no_spawner_pixels"
	end
	LoadPixelScene("mods/anvil_of_destiny/files/entities/altar/altar" .. s .. ".png", "mods/anvil_of_destiny/files/entities/altar/altar_visual.png", x - (w / 2), y - h + 1, "", true )
end

function spawn_anvil(x, y)
	local w = 78
	local h = 37
	local mimic = false
	if ModSettingGet("anvil_of_destiny.mimic") then
		SetRandomSeed(x, y)
		if Randomf() <= ModSettingGet("anvil_of_destiny.mimic_chance") then
			mimic = true
		end
	end
	if mimic then
		EntityLoad("mods/anvil_of_destiny/files/entities/anvil/mimic/anvil.xml", x, y - h + 1)
	else
		EntityLoad("mods/anvil_of_destiny/files/entities/anvil/anvil.xml", x, y - h + 1)
		EntityLoad("mods/anvil_of_destiny/files/entities/anvil/potion_place.xml", x + 5, y - h + 1 - 10)
	end
end

function spawn_statue_facing_right(x, y)
	local w = 36
	local h = 52
	EntityLoad("mods/anvil_of_destiny/files/entities/statue/statue_facing_right.xml", x - 1, y - 21)
end

function spawn_statue_facing_left(x, y)
	local w = 36
	local h = 52
	EntityLoad("mods/anvil_of_destiny/files/entities/statue/statue_facing_left.xml", x + 2, y - 21)
end
