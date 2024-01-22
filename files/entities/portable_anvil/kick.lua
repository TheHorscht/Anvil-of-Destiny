function kick(entity_who_kicked)
  local entity_id = GetUpdatedEntityID()
  local x, y = EntityGetTransform(entity_id)
  EntityLoad("mods/anvil_of_destiny/files/entities/portable_anvil/buildup.xml", x, y - 6)
  GamePlaySound("data/audio/Desktop/projectiles.snd", "player_projectiles/crumbling_earth/create", x, y)
  EntityKill(entity_id)
  local times_portable_anvil_used = tonumber(ModSettingGet("anvil_of_destiny.times_portable_anvil_used")) or 0
  times_portable_anvil_used = times_portable_anvil_used + 1
  ModSettingSet("anvil_of_destiny.times_portable_anvil_used", times_portable_anvil_used)
end
