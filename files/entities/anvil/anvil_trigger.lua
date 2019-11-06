dofile("data/scripts/lib/utilities.lua")
dofile("data/scripts/gun/gun_enums.lua")
dofile("mods/anvil_of_destiny/files/wand_utils.lua")
dofile("mods/anvil_of_destiny/anvil_of_destiny_config.lua")
-- dofile("data/scripts/lib/coroutines.lua")

if g_mymod_anvil_state == nil then
  g_mymod_anvil_state = {}
end

function init_state()
  local entity_id = GetUpdatedEntityID()
  if g_mymod_anvil_state[entity_id] == nil then
    g_mymod_anvil_state[entity_id] = {
      collider_ticks = 0,
      wands_sacrificed = 0,
      tablets_sacrificed = 0,
      level_low = 999,
      level_high = -1,
      first_wand_id = nil,
      level_indicator = EntityGetFirstComponent(entity_id, "SpriteComponent", "level_indicator"),
      level_indicator_number = EntityGetFirstComponent(entity_id, "SpriteComponent", "level_indicator_number")
    }
  end
end

function get_state()
  local entity_id = GetUpdatedEntityID()
  return g_mymod_anvil_state[entity_id]
end

-- TODO: Extract this function so wand_utils or something
function get_wand_level(entity_id)
  for i=0,6 do
    if EntityHasTag(entity_id, "wand_level_"..i) then
      return i
    end
  end
end

function collision_trigger(colliding_entity_id)
  init_state()
  get_state().collider_ticks = get_state().collider_ticks + 1
  -- while something is colliding, do our own custom "collision" check 10 times per second, to get ALL items instead of just one
  if get_state().collider_ticks % 6 == 0 then
    local entity_id = GetUpdatedEntityID()
    local x, y = EntityGetTransform(entity_id)
    local wands = EntityGetInRadiusWithTag(x, y - 30, 30, "wand")
    -- local player = EntityGetWithTag("player_unit")[1]
    local active_item_level = nil
    for i, v in ipairs(wands) do
      -- Check if wand is dropped on the floor
      if EntityGetParent(v) == 0 then
        local wand_level = get_wand_level(v)
        if wand_level ~= nil then
          get_state().wands_sacrificed = get_state().wands_sacrificed + 1
          if get_state().wands_sacrificed == 1 then
            get_state().first_wand_id = v
            hide_wand(v)
          else
            EntityKill(v)
          end
    
          if wand_level < get_state().level_low then
            get_state().level_low = wand_level
          elseif wand_level > get_state().level_high then
            get_state().level_high = wand_level
          end
          
          if get_state().tablets_sacrificed <= 1 and get_state().wands_sacrificed == 1 then
            EntitySetComponentsWithTagEnabled(entity_id, "emitter1", true)
            GamePlaySound("mods/anvil_of_destiny/fmod/Build/Desktop/my_mod_audio.snd", "snd_mod/jingle", x, y)
          elseif get_state().tablets_sacrificed == 2 and get_state().wands_sacrificed == 1 then
            EntitySetComponentsWithTagEnabled(entity_id, "emitter2_powered", true)
            respawn_buffed_wand(entity_id, x, y)
          elseif get_state().wands_sacrificed == 2 then
            EntitySetComponentsWithTagEnabled(entity_id, "emitter2", true)
            local wand_level_to_spawn = get_state().level_low + 1
            if wand_level_to_spawn > 6 then
              wand_level_to_spawn = 6
            end
            local shuffle = false
            if config_can_generate_shuffle_wands then
              if Random() < 0.5 then
                shuffle = true
              end
            end
            local perma_spell_count = 0
            if get_state().tablets_sacrificed == 1 then
              perma_spell_count = perma_spell_count + 1
            end
            -- Always add an always cast spell if both wands are level 6
            if get_state().level_low == 6 then
              perma_spell_count = perma_spell_count + 1
            end
            spawn_new_wand(shuffle, wand_level_to_spawn, perma_spell_count, x + 4, y - 25)
            finish(entity_id, x, y)
          end
        end
      end
    end

    local tablets = EntityGetInRadiusWithTag(x, y - 30, 30, "tablet")
    for i, v in ipairs(tablets) do
      if EntityGetParent(v) ~= 0 then
        break
      end
      if get_state().tablets_sacrificed < 2 then
        EntityKill(v)
        get_state().tablets_sacrificed = get_state().tablets_sacrificed + 1
        GamePlaySound("mods/anvil_of_destiny/fmod/Build/Desktop/my_mod_audio.snd", "snd_mod/jingle", x, y)
        -- TODO: make this sound higher on second tablet to indicate more power!
      end
      if get_state().tablets_sacrificed == 1 then
        EntitySetComponentsWithTagEnabled(entity_id, "emitter_base_powered_up", true)
      elseif get_state().tablets_sacrificed == 2 then
        if get_state().wands_sacrificed == 0 then
          EntitySetComponentsWithTagEnabled(entity_id, "emitter1_powered", true)
        else
          EntitySetComponentsWithTagEnabled(entity_id, "emitter1", false)
          EntitySetComponentsWithTagEnabled(entity_id, "emitter1_powered", true)
          EntitySetComponentsWithTagEnabled(entity_id, "emitter2_powered", true)
          respawn_buffed_wand(entity_id, x, y)
        end
      elseif get_state().tablets_sacrificed == 3 then
        -- TODO: Explode!
      end
    end
  end
end

function finish(entity_id, x, y)
  GameScreenshake(20, x, y)
  GamePrintImportant("A gift from the gods", "")
  GamePlaySound("mods/anvil_of_destiny/fmod/Build/Desktop/my_mod_audio.snd", "snd_mod/fanfare", x, y)
  edit_component(entity_id, "AudioLoopComponent", function(comp, vars)
    EntityRemoveComponent(entity_id, comp)
  end)
  edit_all_components(entity_id, "CollisionTriggerComponent", function(comp, vars)
    EntityRemoveComponent(entity_id, comp)
  end)
end

function hide_wand(wand_id)
  -- Just yeet the wand into the nether and make it float there forever
  EntitySetTransform(wand_id, 200000, 200000)
  -- Disable physics to stop it from falling endlessly
  edit_component(wand_id, "SimplePhysicsComponent", function(comp, vars)
    EntitySetComponentIsEnabled(wand_id, comp, false)
    print("SimplePhysicsComponent: " .. comp)
  end)
end

function spawn_new_wand(shuffle, level, permaspell_count, x, y)
  local wand_type = "unshuffle"
  if shuffle == true then
    wand_type = "level"
  end
  local generated_wand = EntityLoad("data/entities/items/wand_"..wand_type.."_0"..level..".xml", x, y)

  -- Add perma spell
  local function get_random_action()
    local rand_spell_roll = Random()
    local spell = nil
    if rand_spell_roll < 0.33 then
      spell = GetRandomActionWithType(x, y, level, ACTION_TYPE_PROJECTILE)
    elseif rand_spell_roll < 0.67 then
      spell = GetRandomActionWithType(x, y, level, ACTION_TYPE_MODIFIER)
    else
      spell = GetRandomActionWithType(x, y, level, ACTION_TYPE_DRAW_MANY)
    end
    return spell
  end

  for i=1, permaspell_count - wand_get_attached_spells_count(generated_wand) do
    local action = get_random_action()
    wand_add_always_cast_spell(generated_wand, action)
  end

  return generated_wand
end

function respawn_buffed_wand(entity_id, x, y)
  local wand_id = get_state().first_wand_id
  local props = wand_get_properties(wand_id)
  local spells, attached_spells = wand_get_spells(wand_id)
	props.ability_component_members.mana_charge_speed = props.ability_component_members.mana_charge_speed * (1.1 + Random() * 0.15)
	props.ability_component_members.mana_max = props.ability_component_members.mana_max * (1.1 + Random() * 0.15)
  props.ability_component_members.mana = props.ability_component_members.mana_max
  local slot_add_count = math.floor(props.gun_config.deck_capacity / 4) + 1
  slot_add_count = math.min(3, slot_add_count)
  props.gun_config.shuffle_deck_when_empty = "0"
  props.gun_config.deck_capacity = props.gun_config.deck_capacity + slot_add_count
	props.gun_config.reload_time = props.gun_config.reload_time * (0.9 - Random() * 0.15)
	props.gunaction_config.fire_rate_wait = props.gunaction_config.fire_rate_wait * (0.9 - Random() * 0.15)
	props.gunaction_config.spread_degrees = props.gunaction_config.spread_degrees * (0.9 - Random() * 0.15)

  wand_set_properties(wand_id, props)
  wand_restore_to_unpicked_state(wand_id, x, y)
  finish(entity_id, x, y)
end
