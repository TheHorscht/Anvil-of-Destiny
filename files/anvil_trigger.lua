dofile( "data/scripts/lib/utilities.lua" )

g_mymod_anvil_state = {
  wands_sacrificed = 0,
  level_low = 999,
  level_high = 0
}

function get_wand_level(entity_id)
  for i=1,6 do
    if EntityHasTag(entity_id, "wand_level_"..i) then
      GamePrint("wand level found: " .. i)
      return i
    end
  end
end

function collision_trigger(colliding_entity_id)
  local entity_id = GetUpdatedEntityID()
  local x, y = EntityGetTransform(entity_id)
  if EntityGetParent(colliding_entity_id) == 0 then
    local wand_level = get_wand_level(colliding_entity_id)
    if wand_level == nil then
      GamePrint("wand level is nil")
    else
      GamePrint("wand_level:" .. wand_level)

      EntityKill(colliding_entity_id)
      g_mymod_anvil_state.wands_sacrificed = g_mymod_anvil_state.wands_sacrificed + 1
      if wand_level < g_mymod_anvil_state.level_low then
        g_mymod_anvil_state.level_low = wand_level
      elseif wand_level > g_mymod_anvil_state.level_high then
        g_mymod_anvil_state.level_high = wand_level
      end
      
      if g_mymod_anvil_state.wands_sacrificed == 1 then
        EntitySetComponentsWithTagEnabled(entity_id, "emitter1", true)
        GamePlaySound("mods/mymod/fmod/Build/Desktop/my_mod_audio.snd", "snd_mod/jingle", x, y)
      elseif g_mymod_anvil_state.wands_sacrificed == 2 then
        EntitySetComponentsWithTagEnabled(entity_id, "emitter2", true)
  
  
        --function script_wait_frames( entity_id, frames )
  
  
        -- TODO: Localize this
        -- GamePrintImportant("$logdesc_temple_spawn_guardian", "")
        
        GamePrintImportant("A gift from the gods", "")
        -- GamePlaySound("data/audio/Desktop/event_cues.snd", "event_cues/sampo_pick/create", x, y)
        GamePlaySound("mods/mymod/fmod/Build/Desktop/my_mod_audio.snd", "snd_mod/fanfare", x, y)
        edit_component(entity_id, "AudioLoopComponent", function(comp, vars)
          EntityRemoveComponent(entity_id, comp)
        end)
        -- mods/example/files/my_mod_audio.snd
        GameScreenshake(20, x, y)
        --data/entities/items/wand_level_03.xml
        local wand_level_to_spawn = g_mymod_anvil_state.level_low + 1
        if wand_level_to_spawn > 6 then
          wand_level_to_spawn = 6
        end
        EntityLoad("data/entities/items/wand_level_0" .. wand_level_to_spawn .. ".xml", x + 4, y - 25)
        GamePrint("Spawning level " .. wand_level_to_spawn .. " wand")
        edit_component(entity_id, "CollisionTriggerComponent", function(comp, vars)
          EntityRemoveComponent(entity_id, comp)
        end)
      end
    end
    
  end
end
