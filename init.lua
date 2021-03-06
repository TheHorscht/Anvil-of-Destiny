ModRegisterAudioEventMappings("mods/anvil_of_destiny/audio/GUIDs.txt")
ModLuaFileAppend("data/scripts/biomes/coalmine.lua", "mods/anvil_of_destiny/files/biomes/coalmine.lua")
ModLuaFileAppend("data/scripts/biomes/excavationsite.lua", "mods/anvil_of_destiny/files/biomes/excavationsite.lua")
ModLuaFileAppend("data/scripts/biomes/crypt.lua", "mods/anvil_of_destiny/files/biomes/crypt.lua")
ModLuaFileAppend("data/scripts/biomes/pyramid.lua", "mods/anvil_of_destiny/files/biomes/pyramid.lua")
ModLuaFileAppend("data/scripts/biomes/rainforest.lua", "mods/anvil_of_destiny/files/biomes/rainforest.lua")
ModLuaFileAppend("data/scripts/biomes/snowcastle.lua", "mods/anvil_of_destiny/files/biomes/snowcastle.lua")
ModLuaFileAppend("data/scripts/biomes/snowcave.lua", "mods/anvil_of_destiny/files/biomes/snowcave.lua")
ModLuaFileAppend("data/scripts/biomes/vault.lua", "mods/anvil_of_destiny/files/biomes/vault.lua")
if ModIsEnabled("VolcanoBiome") then
  ModLuaFileAppend("mods/VolcanoBiome/files/biome/inside.lua", "mods/anvil_of_destiny/files/biomes/volcanobiome.lua")
end
ModMaterialsFileAdd("mods/anvil_of_destiny/files/materials.xml")

function build_spell_level_lookup_table()
  dofile_once("data/scripts/gun/gun_actions.lua")
  local s = "return {\n"
  for i,v in ipairs(actions) do
    s = s .. "  [\"_" .. v.id .. "\"] = " .. "{"
    -- split spell levels by comma
    for spell_level in v.spawn_level:gmatch("([^,]+)") do
      s = s .. spell_level .. ","
    end
    s = s .. "},\n"
  end
  s = s .. "}"
  return s
end

function OnMagicNumbersAndWorldSeedInitialized()
  ModTextFileSetContent("mods/anvil_of_destiny/files/scripts/spell_level_lookup.lua", build_spell_level_lookup_table())
  if ModTextFileGetContent("mods/anvil_of_destiny/files/_virtual/potion_bonuses_append.lua") then
    ModLuaFileAppend("mods/anvil_of_destiny/files/entities/anvil/potion_bonuses.lua", "mods/anvil_of_destiny/files/_virtual/potion_bonuses_append.lua")
  end
end
