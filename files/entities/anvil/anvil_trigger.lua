dofile("data/scripts/lib/utilities.lua")
dofile("mods/anvil_of_destiny/files/wand_utils.lua")
dofile("data/scripts/gun/gun_enums.lua")


if g_mymod_anvil_state == nil then
  g_mymod_anvil_state = {}
end

function init_state()
  local entity_id = GetUpdatedEntityID()
  if g_mymod_anvil_state[entity_id] == nil then
    g_mymod_anvil_state[entity_id] = {
      wands_sacrificed = 0,
      level_low = 999,
      level_high = 0
    }
  end
end

function get_state()
  local entity_id = GetUpdatedEntityID()
  return g_mymod_anvil_state[entity_id]
end

function get_state_var(name)
  local entity_id = GetUpdatedEntityID()
  return g_mymod_anvil_state[entity_id][name]
end

function set_state_var(name, value)
  local entity_id = GetUpdatedEntityID()
  g_mymod_anvil_state[entity_id][name] = value
end

function get_wand_level(entity_id)
  for i=1,6 do
    if EntityHasTag(entity_id, "wand_level_"..i) then
      return i
    end
  end
end

function collision_trigger(colliding_entity_id)
  init_state()
  local entity_id = GetUpdatedEntityID()
  local x, y = EntityGetTransform(entity_id)
  if EntityGetParent(colliding_entity_id) == 0 then
    local wand_level = get_wand_level(colliding_entity_id)
    if wand_level ~= nil then
      EntityKill(colliding_entity_id)
      get_state().wands_sacrificed = get_state().wands_sacrificed + 1
      if wand_level < get_state().level_low then
        get_state().level_low = wand_level
      elseif wand_level > get_state().level_high then
        get_state().level_high = wand_level
      end
      
      if get_state().wands_sacrificed == 1 then
        EntitySetComponentsWithTagEnabled(entity_id, "emitter1", true)
        GamePlaySound("mods/anvil_of_destiny/fmod/Build/Desktop/my_mod_audio.snd", "snd_mod/jingle", x, y)
      elseif get_state().wands_sacrificed == 2 then
        EntitySetComponentsWithTagEnabled(entity_id, "emitter2", true)
        GamePrintImportant("A gift from the gods", "")
        GamePlaySound("mods/anvil_of_destiny/fmod/Build/Desktop/my_mod_audio.snd", "snd_mod/fanfare", x, y)
        edit_component(entity_id, "AudioLoopComponent", function(comp, vars)
          EntityRemoveComponent(entity_id, comp)
        end)
        GameScreenshake(20, x, y)
        local wand_level_to_spawn = get_state().level_low + 1
        if wand_level_to_spawn > 6 then
          wand_level_to_spawn = 6
        end
        local wand_type = "level"
        if Random() < 0.5 then
          wand_type = "unshuffle"
        end
        -- For now let's only spawn wands with no shuffle, otherwise the anvil is too weak
        wand_type = "unshuffle"
        local generated_wand = EntityLoad("data/entities/items/wand_"..wand_type.."_0"..wand_level_to_spawn..".xml", x + 4, y - 25)
        if get_state().powered_up then
          local rand_spell_roll = Random()
          local always_cast_spell = nil
          if rand_spell_roll < 0.50 then
            always_cast_spell = GetRandomActionWithType(x, y, wand_level, ACTION_TYPE_PROJECTILE)
          elseif rand_spell_roll < 0.80 then
            always_cast_spell = GetRandomActionWithType(x, y, wand_level, ACTION_TYPE_MODIFIER)
          else
            always_cast_spell = GetRandomActionWithType(x, y, wand_level, ACTION_TYPE_DRAW_MANY)
          end
          if always_cast_spell == nil then
            GamePrint("Anvil of Destiny could not find a spell for your wand!")
          else
            -- If lowest sacrificed wand level is below 6, do not add another always cast spell if the generated wand already has one
            -- otherwise, get a chance of a second permanent spell!
            if get_state().level_low >= 6 or wand_get_attached_spells_count(generated_wand) == 0 then
              GamePrint("Adding more power!")
              --debug_print_table(always_cast_spell)
              AddGunActionPermanentSafely(generated_wand, always_cast_spell)
            end
          end
        end
        edit_all_components(entity_id, "CollisionTriggerComponent", function(comp, vars)
          EntityRemoveComponent(entity_id, comp)
        end)
      end
    elseif EntityHasTag(colliding_entity_id, "tablet") then
      if not get_state().powered_up then
        EntitySetComponentsWithTagEnabled(entity_id, "emitter_powered_up", true)
        get_state().powered_up = true
        EntityKill(colliding_entity_id)
        GamePlaySound("mods/anvil_of_destiny/fmod/Build/Desktop/my_mod_audio.snd", "snd_mod/jingle", x, y)
      end
    end
  end
end
