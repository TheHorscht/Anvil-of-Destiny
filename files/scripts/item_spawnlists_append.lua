local spawn_chance = ModSettingGet("anvil_of_destiny.portable_anvil_spawn_chance")
if spawn_chance > 0.5 then
  local old_max = spawnlists.potion_spawnlist.rnd_max
  local new_max = old_max + spawn_chance

  spawnlists.potion_spawnlist.rnd_max = new_max
  table.insert(spawnlists.potion_spawnlist.spawns, {
    value_min = old_max + 1,
    value_max = new_max + 1,
    load_entity = "mods/anvil_of_destiny/files/entities/portable_anvil/item.xml",
    offset_y = -3,
  })
end
