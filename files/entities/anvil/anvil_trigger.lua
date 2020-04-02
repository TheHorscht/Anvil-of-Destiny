dofile("mods/anvil_of_destiny/files/entities/anvil/anvil.lua")

function collision_trigger(colliding_entity_id)
  local entity_id = GetUpdatedEntityID()
  -- Aproximate the same hitbox as the CollisionTriggerComponent by getting everything inside a circle,
  -- then filter the results by cutting off the top and bottom of the circle to re-create the same rectangle
  local function get_entities_with_tag(x, y, tag)
    local entities = EntityGetInRadiusWithTag(x, y, 28, tag)
    for i, v in ipairs(entities) do
      local tx, ty = EntityGetTransform(v)
      if ty > y + 5 or ty < y - 10 then
        table.remove(entities, i)
      end
    end
    return entities
  end
  -- while something is colliding, do our own custom "collision" check 10 times per second, to get ALL items instead of just one
  if GameGetFrameNum() % 6 == 0 then
    local x, y = EntityGetTransform(entity_id)
    local wands = get_entities_with_tag(x, y, "wand")
    for i, wand_id in ipairs(wands) do
      -- Check if wand is dropped on the floor
      if EntityGetParent(wand_id) == 0 then
        feed_anvil(entity_id, "wand", wand_id)
        -- hide_wand(v)
      end
    end

    local tablets = get_entities_with_tag(x, y, "tablet")
    for i, tablet_id in ipairs(tablets) do
      if EntityGetParent(tablet_id) == 0 then
        feed_anvil(entity_id, "tablet", tablet_id)
      end
    end
  end
end
