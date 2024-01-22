local entity_id = GetUpdatedEntityID()

-- Abort if we already added it
for i, child in ipairs(EntityGetAllChildren(entity_id) or {}) do
  if EntityGetName(child) == "kick_me_indicator" then
    return
  end
end

-- Show kick indicator the first 2 times to teach users the new method to activate it
if tonumber(ModSettingGet("anvil_of_destiny.times_portable_anvil_used") or 0) < 2 then
  EntityAddChild(GetUpdatedEntityID(), EntityLoad("mods/anvil_of_destiny/files/entities/portable_anvil/kick_me_indicator.xml"))
end
