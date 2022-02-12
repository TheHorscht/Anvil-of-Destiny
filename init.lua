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
    for spell_level in (v.spawn_level and v.spawn_level or "10"):gmatch("([^,]+)") do
      s = s .. spell_level .. ","
    end
    s = s .. "},\n"
  end
  s = s .. "}"
  return s
end

-- A creates a table with key being the action_id preceded by a _ (to account for action_ids that start with a number,
-- can't have table keys that start with a number)
-- and the value being 
function build_spells_evolution_lookup_table()
  dofile_once("data/scripts/gun/gun_enums.lua")
  dofile("data/scripts/gun/gun_actions.lua")
  local s = "return {\n"
  local cache = {}
  for i, v in ipairs(actions) do
    if v.id:sub(1, 4) == "EVO_" then
      local action_id = v.id:sub(5, -6)
      if not cache[action_id] then
        cache[action_id] = true
        s = s .. ("  ['_%s'] = %d,\n"):format(action_id, v.type)
      end
    end
  end
  s = s .. "}"
  return s
end

function OnMagicNumbersAndWorldSeedInitialized()
  ModTextFileSetContent("mods/anvil_of_destiny/files/scripts/spell_level_lookup.lua", build_spell_level_lookup_table())
  ModTextFileSetContent("mods/anvil_of_destiny/files/scripts/spells_evolution_lookup.lua", build_spells_evolution_lookup_table())
  if ModTextFileGetContent("mods/anvil_of_destiny/files/_virtual/potion_bonuses_append.lua") then
    ModLuaFileAppend("mods/anvil_of_destiny/files/entities/anvil/potion_bonuses.lua", "mods/anvil_of_destiny/files/_virtual/potion_bonuses_append.lua")
  end
end
