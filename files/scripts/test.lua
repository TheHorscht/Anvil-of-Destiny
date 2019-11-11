local _do_level = do_level
function do_level(level)
  local entity_id = GetUpdatedEntityID()
  EntityAddTag(entity_id, "FUCKYOU")
  print("FUCK")
  _do_level(level)
end
