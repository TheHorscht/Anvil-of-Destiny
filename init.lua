ModRegisterAudioEventMappings("mods/anvil_of_destiny/audio/GUIDs.txt")
if not ModSettingGet("anvil_of_destiny.never_spawn_naturally") then
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
  if ModIsEnabled("biome-plus") then
    ModLuaFileAppend("data/scripts/biomes/mod/blast_pit.lua", "mods/anvil_of_destiny/files/biomes/biome-plus/blast_pit.lua")
    ModLuaFileAppend("data/scripts/biomes/mod/floodcave.lua", "mods/anvil_of_destiny/files/biomes/biome-plus/floodcave.lua")
    ModLuaFileAppend("data/scripts/biomes/mod/frozen_passages.lua", "mods/anvil_of_destiny/files/biomes/biome-plus/frozen_passages.lua")
    ModLuaFileAppend("data/scripts/biomes/mod/holy_temple.lua", "mods/anvil_of_destiny/files/biomes/biome-plus/holy_temple.lua")
    ModLuaFileAppend("data/scripts/biomes/mod/rainforest_wormy.lua", "mods/anvil_of_destiny/files/biomes/biome-plus/rainforest_wormy.lua")
    ModLuaFileAppend("data/scripts/biomes/mod/robofactory.lua", "mods/anvil_of_destiny/files/biomes/biome-plus/robofactory.lua")
    ModLuaFileAppend("data/scripts/biomes/mod/snowvillage.lua", "mods/anvil_of_destiny/files/biomes/biome-plus/snowvillage.lua")
    ModLuaFileAppend("data/scripts/biomes/mod/swamp.lua", "mods/anvil_of_destiny/files/biomes/biome-plus/swamp.lua")
  end
  if ModIsEnabled("noitavania") then
    ModLuaFileAppend("data/scripts/biomes/coalmine_alt.lua", "mods/anvil_of_destiny/files/biomes/coalmine_alt.lua")
  end
end  

ModMaterialsFileAdd("mods/anvil_of_destiny/files/materials.xml")

function build_spell_level_lookup_table()
  dofile_once("data/scripts/gun/gun_actions.lua")
  dofile_once("mods/anvil_of_destiny/files/scripts/utils.lua")
  local s = "return {\n"
  for i,v in ipairs(actions) do
    s = s .. "  [\"_" .. v.id .. "\"] = " .. "{"
    -- split spell levels by comma
    local spawn_levels = string_split(v.spawn_level and v.spawn_level or "6", ",")
    local spawn_probabilities = string_split(v.spawn_probability and v.spawn_probability or "1", ",")
    for i=1, #spawn_levels do
      if tonumber(spawn_probabilities[i] or 0) > 0 then
        s = s .. ("%s,"):format(spawn_levels[i])
      end
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

ModLuaFileAppend("data/scripts/item_spawnlists.lua", "mods/anvil_of_destiny/files/scripts/item_spawnlists_append.lua")

function OnMagicNumbersAndWorldSeedInitialized()
  ModTextFileSetContent("mods/anvil_of_destiny/files/scripts/spell_level_lookup.lua", build_spell_level_lookup_table())
  ModTextFileSetContent("mods/anvil_of_destiny/files/scripts/spells_evolution_lookup.lua", build_spells_evolution_lookup_table())
  if ModTextFileGetContent("mods/anvil_of_destiny/files/_virtual/potion_bonuses_append.lua") then
    ModLuaFileAppend("mods/anvil_of_destiny/files/entities/anvil/potion_bonuses.lua", "mods/anvil_of_destiny/files/_virtual/potion_bonuses_append.lua")
  end
  if ModSettingGet("anvil_of_destiny.add_anvil_to_lavalake") then
    ModLuaFileAppend("data/scripts/biomes/hills.lua", "mods/anvil_of_destiny/files/biomes/hills.lua")

    local nxml = dofile_once("mods/anvil_of_destiny/lib/nxml.lua")
    local content = ModTextFileGetContent("data/biome/_pixel_scenes.xml")
    local xml = nxml.parse(content)
    xml:first_of("mBufferedPixelScenes"):add_child(nxml.parse([[
      <PixelScene DEBUG_RELOAD_ME="0" clean_area_before="1" pos_x="2048" pos_y="924" skip_biome_checks="1" skip_edge_textures="0"
        material_filename="mods/anvil_of_destiny/files/lavalake_room.png"
        background_filename=""
        colors_filename=""
      ></PixelScene>
    ]]))
    ModTextFileSetContent("data/biome/_pixel_scenes.xml", tostring(xml))

    local content = ModTextFileGetContent("data/biome_impl/spliced/lavalake2.xml")
    local xml = nxml.parse(content)
    for element in xml:first_of("mBufferedPixelScenes"):each_of("PixelScene") do
      if element.attr.material_filename == "data/biome_impl/spliced/lavalake2/2.plz" then
        xml:first_of("mBufferedPixelScenes"):remove_child(element)
        break
      end
    end
    ModTextFileSetContent("data/biome_impl/spliced/lavalake2.xml", tostring(xml))
  end
end

-- -- For debugging purposes, shows arrow to the nearest anvil
-- local anvil_content = ModTextFileGetContent("mods/anvil_of_destiny/files/entities/anvil/anvil.xml")
-- anvil_content = anvil_content:gsub([[<Entity name="anvil_of_destiny">]], [[<Entity name="anvil_of_destiny" tags="anvil_of_destiny">]])
-- ModTextFileSetContent("mods/anvil_of_destiny/files/entities/anvil/anvil.xml", anvil_content)
-- local draw_arrow = dofile_once("mods/anvil_of_destiny/files/scripts/draw_arrow.lua")
-- local function get_distance2( x1, y1, x2, y2 )
-- 	local result = ( x2 - x1 ) ^ 2 + ( y2 - y1 ) ^ 2
-- 	return result
-- end
-- function OnWorldPreUpdate()
--   -- Draw an arrow poiting to the nearest anvil
--   local closest = { dist2 = 99999999999999 }
--   for i, anvil in ipairs(EntityGetWithTag("anvil_of_destiny")) do
--     local x, y = EntityGetTransform(anvil)
--     local cx, cy = GameGetCameraPos()
--     local dist2 = get_distance2(x, y, cx, cy)
--     if dist2 < closest.dist2 then
--       closest.dist2 = dist2
--       closest.x = x
--       closest.y = y
--     end
--   end
--   if closest.x then
--     draw_arrow(closest.x, closest.y)
--     gui = gui or GuiCreate()
--     GuiStartFrame(gui)
--     if GuiButton(gui, 2, 0, 200, "Jump to nearest anvil") then
--       GameSetCameraPos(closest.x, closest.y)
--     end
--   end
-- end

-- ModTextFileSetContent("mods/anvil_of_destiny/_virtual/magic_numbers.xml", [[
-- <MagicNumbers
--   DEBUG_COLLISION_TRIGGERS="1"
--   _DEBUG_DONT_SAVE_MAGIC_NUMBERS="1"
-- ></MagicNumbers>]])
-- ModMagicNumbersFileAdd("mods/anvil_of_destiny/_virtual/magic_numbers.xml")

function OnPlayerSpawned(player)
  if ModSettingGet("anvil_of_destiny.start_with_portable_anvil")
    and not GameHasFlagRun("anvil_of_destiny_portable_anvil_given") then
      GameAddFlagRun("anvil_of_destiny_portable_anvil_given")
    local item = EntityLoad("mods/anvil_of_destiny/files/entities/portable_anvil/item.xml")
    for i, child in ipairs(EntityGetAllChildren(player) or {}) do
      if EntityGetName(child) == "inventory_quick" then
        EntityAddChild(child, item)
      end
    end
  end
end
