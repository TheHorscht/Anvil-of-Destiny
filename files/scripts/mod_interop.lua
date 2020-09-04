function potion_recipe_add_spells(material_name, spells, version)
  local api_version = 1
  if version ~= api_version then
    error("potion_recipe_add_spells function usage has changed, please read update notes \
and update version argument to " .. api_version .. " after you adapted your code", 2)
  end

  local recipes = dofile_once("mods/anvil_of_destiny/files/entities/anvil/potion_bonuses.lua")
  if not recipes[material_name] then
    error("Potion recipe for material '" .. material_name .. "' does not exist.", 2) -- Throw the error to the caller
  end

  local content = ModTextFileGetContent("mods/anvil_of_destiny/files/_virtual/potion_bonuses_append.lua") or ""
  local to_append = "potion_recipe_add_spells(\"" .. material_name .. "\", { "
  for i, action_id in ipairs(spells) do
    to_append = to_append .. "\"" .. action_id .. "\""
    if i < #spells then
      to_append = to_append .. ", "
    end
  end
  to_append = to_append .. " })"
  ModTextFileSetContent("mods/anvil_of_destiny/files/_virtual/potion_bonuses_append.lua", content .. to_append .. "\n")
end

return {
  potion_recipe_add_spells = potion_recipe_add_spells
}
