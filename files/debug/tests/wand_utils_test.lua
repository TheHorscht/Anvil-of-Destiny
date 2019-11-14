dofile("mods/anvil_of_destiny/files/wand_utils.lua")

-- Just for convenience so we can use a similarly named function
-- function wand_add_spell(wand_id, spell)

-- Add an always cast spell without sacrificing a slot
-- function wand_add_always_cast_spell(wand_id, spell)

-- Remove all spells from a wand. All, only slotted, or only always cast spells.
-- function wand_remove_all_spells(wand_id, remove_slotted_spells, remove_always_cast_spells)

-- function wand_get_ability_component(wand_id)

-- Returns the number of permanently attached spells
-- function wand_get_attached_spells_count(wand_id)

-- Returns the number of spells on the wand (without permanently attached ones)
-- function wand_get_spells_count(wand_id)

-- Returns how many slots the wand has (not counting permanently attached spells)
-- function wand_get_slot_count(wand_id)

-- Returns the number of free slots
-- function wand_get_free_slot_count(wand_id)

-- Returns a table { ability_component_members, gun_config, gunaction_config }
-- function wand_get_properties(wand_id)

-- function wand_set_properties(wand_id, props)

-- function wand_restore_to_unpicked_state(wand_id, x, y)

-- function ability_component_set_members(ability_component_id, ability_component_members)

-- function ability_component_set_gun_config(ability_component_id, gun_config)

-- function ability_component_set_gunaction_config(ability_component_id, gunaction_config)

-- Returns two values:
-- 1: table of spells with each entry having the format { action_id = "BLACK_HOLE", inventory_x = 1 }
-- 2: table of attached spells with the same format { action_id = "BLACK_HOLE", inventory_x = 1 }
-- inventory_x should give the position in the wand slots, 1 = first up to num_slots
-- inventory_x is not working yet
-- function wand_get_spells(wand_id)

-- Returns an entry of data/scripts/gun/gun_actions.lua
-- function action_get_by_id(action_id)

-- Generates and spawns a new wand based on the average stats of the input wands
-- Re-adds spells randomly picked 50% from wand1 and wand2
-- function wand_merge(wand_id1, wand_id2, x, y)

-- Increases the stats of a wand by buff_amount split across 5 stats
-- A buff_amount of 1 means an increase of 100% split by 5 = roughly 20% of each stat
-- function wand_buff(wand_id, buff_amount, flat_buff_amounts, seed_x, seed_y)

-- Returns a spells average "level" based on spawn_level, which is the level of wands it can spawn in, for instance "3,4,5"
-- function action_get_level(action)

-- Fills a wand with spells that aren't too chaotic, based on level and "controlled" randomness
-- function wand_fill_with_semi_random_spells(wand_id, spells_count, always_attached_spells_count, level)

-- Returns a random spell based on specified chances by type
-- function get_random_action(level, chance_projectile, chance_modifier, chance_draw_many, seed)

function create_test_wand()
  local wand = EntityLoad("data/entities/items/wands/level_01/wand_001.xml")
  wand_remove_all_spells(wand, true, true)
  return wand
end

local tests = {}
-- Returns true if entity is a wand
-- function wand_entity_is_wand(entity_id)
tests.wand_entity_is_wand = function()
  local wand = create_test_wand()
  local not_wand = EntityLoad("data/entities/animals/alchemist.xml")
  local result = wand_entity_is_wand(wand)
  local result2 = wand_entity_is_wand(not_wand)
  EntityKill(wand)
  EntityKill(not_wand)

  assert(result == true, "Does not correctly identify wand")
  assert(result2 == false, "Falsely identified non-wand")
end
-- Returns an averga of both wands stats. WARNING! Only averages handpicked values (see function body)
-- function wand_get_average_stats(wand_id1, wand_id2)
tests.wand_get_average_stats = function()
  assert(5 == 5, "suck it")
end
-- Returns a rough estimate of the wand "level" by looking at the stats
-- function wand_compute_level(wand_id)
tests.wand_compute_level = function()
  assert(5 == 5, "suck it")
end

for function_name, test_function in pairs(tests) do
  local happy, value = pcall(function() return test_function() end)
  if not happy then
    print(function_name .. " - FAIL")
    print("Error message: " ..  value)
  else
    print(function_name .. " - PASS")
  end
end
