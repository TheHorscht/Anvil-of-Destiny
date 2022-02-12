-- For spells evolution, gets the base spell it, e.g.:
-- EVO_LIGHT_BULLET_LVL4 -> LIGHT_BULLET
local function get_spell_base_id(action_id)
  if action_id:sub(1, 4) == "EVO_" and action_id:sub(-4, -2) == "LVL" then
    return action_id:sub(5, -6)
  end
  return action_id
end

local function upgrade_to_spells_evolution_level(action_id, level)
  return "EVO_" .. action_id .. "_LVL" ..level
end

local function spell_has_evolution(action)
  local spells = dofile_once("mods/anvil_of_destiny/files/scripts/spells_evolution_lookup.lua")
  if spells["_" .. action] then
    return true
  end
  return false
end

-- Returns a table where the indexes are the spell levels and the value the amount of spells of such level were found
local function get_spell_level_counts(wand)
  local spell_counts = { [1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0 }
  local always_cast_counts = { [1] = 0, [2] = 0, [3] = 0, [4] = 0, [5] = 0 }
  local spells, always_cast_spells = wand:GetSpells()
  for i, spell in ipairs(spells) do
    local spell_id = spell.action_id
    if spell_id:sub(1, 4) == "EVO_" and spell_id:sub(-4, -2) == "LVL" then
      local spell_level = tonumber(spell_id:sub(-1, -1))
      if spell_level then
        spell_counts[spell_level] = spell_counts[spell_level] + 1
      end
    end
  end
  for i, spell in ipairs(always_cast_spells) do
    local spell_id = spell.action_id
    if spell_id:sub(1, 4) == "EVO_" and spell_id:sub(-4, -2) == "LVL" then
      local spell_level = tonumber(spell_id:sub(-1, -1))
      if spell_level then
        always_cast_counts[spell_level] = always_cast_counts[spell_level] + 1
      end
    end
  end
  return {
    spells = spell_counts,
    always_casts = always_cast_counts
  }
end

-- Takes input from get_spells_evolution_spell_level_counts(wand), returns the highest level and decrements it in the table
local function get_next_spells_evolution_level(level_table)
  for i=5, 2, -1 do
    if level_table[i] > 0 then
      level_table[i] = level_table[i] - 1
      return i
    end
  end
end

return {
  get_spell_base_id = get_spell_base_id,
  upgrade_to_spells_evolution_level = upgrade_to_spells_evolution_level,
  spell_has_evolution = spell_has_evolution,
  get_spell_level_counts = get_spell_level_counts,
  get_next_spells_evolution_level = get_next_spells_evolution_level,
}
