dofile( "data/scripts/lib/utilities.lua" )

g_mymod_anvil_state = {
  wands_sacrificed = 0
}

function collision_trigger(colliding_entity_id)
  local entity_id = GetUpdatedEntityID()
  local x, y = EntityGetTransform(entity_id)

  if EntityGetParent(colliding_entity_id) == 0 then
    EntityKill(colliding_entity_id)
    g_mymod_anvil_state.wands_sacrificed = g_mymod_anvil_state.wands_sacrificed + 1
    if g_mymod_anvil_state.wands_sacrificed == 1 then
      EntitySetComponentsWithTagEnabled(entity_id, "emitter1", true)
    elseif g_mymod_anvil_state.wands_sacrificed == 2 then
      EntitySetComponentsWithTagEnabled(entity_id, "emitter2", true)
      -- TODO: Localize this
      -- GamePrintImportant("$logdesc_temple_spawn_guardian", "")
      GamePrintImportant("A gift from the gods", "")
      GamePlaySound("data/audio/Desktop/event_cues.snd", "event_cues/sampo_pick/create", x, y)
      GameScreenshake(20, x, y)
      SpawnActionItem(x, y, 1)
      --data/entities/items/wand_level_03.xml
      EntityLoad("data/entities/items/wand_level_03.xml", x + 4, y - 25)
      edit_component(entity_id, "CollisionTriggerComponent", function(comp, vars)
        EntityRemoveComponent(entity_id, comp)
      end)
--[[       local collision_component = EntityGetComponent(entity_id, "CollisionTriggerComponent")
      EntityRemoveComponent(entity_id, collision_component) ]]
    end
  end
end

--[[ function collision_trigger_timer_finished()
  local entity_id = GetUpdatedEntityID()
  local anvil_x, anvil_y = EntityGetTransform(entity_id)
  local closest_wand = EntityGetClosestWithTag(x, y, "wand")

  -- local distance = math.abs(py - y) * 0.5 + math.abs(px - x)
  local closest_wand_in_

  g_what = (g_what + 1) % 3
end ]]