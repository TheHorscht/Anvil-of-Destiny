local entity_id = GetUpdatedEntityID()
EntityAddComponent2(entity_id, "LuaComponent", {
  script_source_file="mods/anvil_of_destiny/files/scripts/important2.lua",
  execute_every_n_frame=1,
})
