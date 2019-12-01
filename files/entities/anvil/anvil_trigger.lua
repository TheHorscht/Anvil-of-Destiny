dofile("data/scripts/lib/utilities.lua")
dofile("data/scripts/gun/gun_enums.lua")
dofile("mods/anvil_of_destiny/lib/EZWand/EZWand.lua")
dofile("mods/anvil_of_destiny/files/entities/anvil/anvil.lua")
dofile("mods/anvil_of_destiny/config.lua")
dofile("mods/anvil_of_destiny/files/scripts/utils.lua")
dofile("mods/anvil_of_destiny/lib/StringStore/stringstore.lua")
dofile("mods/anvil_of_destiny/lib/StringStore/noitavariablestore.lua")

function init_state()
  local entity_id = GetUpdatedEntityID()
  local STATE_STORE = stringstore.open_store(stringstore.noita.variable_storage_components(entity_id))
  if g_collider_ticks == nil then
    g_collider_ticks = {}
  end
  if g_collider_ticks[entity_id] == nil then
    g_collider_ticks[entity_id] = 0
  end
  if STATE_STORE.wands_sacrificed == nil then
    STATE_STORE.wands_sacrificed = 0
    STATE_STORE.tablets_sacrificed = 0
  end
end

function get_state()
  local entity_id = GetUpdatedEntityID()
  local STATE_STORE = stringstore.open_store(stringstore.noita.variable_storage_components(entity_id))
  return STATE_STORE
end

function collision_trigger(colliding_entity_id)
  local entity_id = GetUpdatedEntityID()
  init_state()
  g_collider_ticks[entity_id] = g_collider_ticks[entity_id] + 1
  -- while something is colliding, do our own custom "collision" check 10 times per second, to get ALL items instead of just one
  if g_collider_ticks[entity_id] % 6 == 0 then
    local x, y = EntityGetTransform(entity_id)
    local wands = EntityGetInRadiusWithTag(x, y - 30, 30, "wand")
    for i, v in ipairs(wands) do
      -- Check if wand is dropped on the floor
      if EntityGetParent(v) == 0 then
        get_state().wands_sacrificed = get_state().wands_sacrificed + 1
        hide_wand(v)
        if get_state().tablets_sacrificed <= 1 and get_state().wands_sacrificed == 1 then
          set_runes_enabled(entity_id, "emitter1", true)
          GamePlaySound("mods/anvil_of_destiny/audio/anvil_of_destiny.snd", "jingle", x, y)
        elseif get_state().tablets_sacrificed == 2 and get_state().wands_sacrificed == 1 then
          set_runes_enabled(entity_id, "emitter2_powered", true)
          path_two(entity_id, x, y)
        elseif get_state().wands_sacrificed == 2 then
          set_runes_enabled(entity_id, "emitter2", true)
          path_one(entity_id, x, y)
        end
      end
    end

    local tablets = EntityGetInRadiusWithTag(x, y - 30, 30, "tablet")
    for i, v in ipairs(tablets) do
      if EntityGetParent(v) == 0 then
        if get_state().tablets_sacrificed < 3 then
          EntityKill(v)
          get_state().tablets_sacrificed = get_state().tablets_sacrificed + 1
          GamePlaySound("mods/anvil_of_destiny/audio/anvil_of_destiny.snd", "jingle", x, y)
        end
        if get_state().tablets_sacrificed == 1 then
          set_runes_enabled(entity_id, "base", true)
        elseif get_state().tablets_sacrificed == 2 then
          if get_state().wands_sacrificed == 0 then
            set_runes_enabled(entity_id, "emitter1_powered", true)
          else
            set_runes_enabled(entity_id, "emitter1", false)
            set_runes_enabled(entity_id, "emitter1_powered", true)
            set_runes_enabled(entity_id, "emitter2_powered", true)
            path_two(entity_id, x, y)
          end
        elseif get_state().tablets_sacrificed == 3 then
          set_runes_enabled(entity_id, "emitter2_powered", true)
          path_easter_egg(entity_id, x, y)
        end
      end
    end
  end
end
-- Two wands
function path_one(entity_id, x, y)
  set_random_seed_with_player_position()
  local stored_wand_id1 = retrieve_wand(1)
  local stored_wand_id2 = retrieve_wand(2)
  local always_cast_spell_count = 0
  if get_state().tablets_sacrificed == 1 then
    always_cast_spell_count = 1
  end
  local success, new_wand_id = pcall(function()
    local seed_x = Random() * 1000
    local seed_y = Random() * 1000
    return anvil_buff1(stored_wand_id1, stored_wand_id2, config_regular_wand_buff, always_cast_spell_count, seed_x, seed_y)
  end)
  if not success then
    error("Anvil of Destiny error: " .. new_wand_id)
  end
  EntityKill(stored_wand_id1)
  EntityKill(stored_wand_id2)
  EZWand(new_wand_id):PlaceAt(x + 4, y - 30)
  finish(entity_id, x, y)
end
-- 2 Tablet + 1 Wand
function path_two(entity_id, x, y)
  set_random_seed_with_player_position()
  buff_stored_wand_and_respawn_it(entity_id, x, y)
  finish(entity_id, x, y)
end
-- Happens in path_two, buff a wand by a lot
function buff_stored_wand_and_respawn_it(entity_id, x, y)
  local stored_wand_id = retrieve_wand(1)
  local stored_wand = EZWand(stored_wand_id)
  local success, new_wand_id = pcall(function()
    local variation = 0.1 - Random() * 0.2
    return buff_wand(stored_wand, config_improved_wand_buff + variation, false)
  end)
  if not success then
    -- If the call was not successful, new_wand_id contains the error message
    print("Anvil of Destiny error: " .. new_wand_id)
  end

  -- TODO: Fix this
  local simple_physics_component = get_component_with_member(stored_wand_id, "can_go_up")
  local item_component = get_component_with_member(stored_wand_id, "preferred_inventory")
  local sprite_component = get_component_with_member(stored_wand_id, "next_rect_animation")
  local light_component = get_component_with_member(stored_wand_id, "fade_out_time")

  EntitySetComponentIsEnabled(stored_wand_id, simple_physics_component, true)
  EntitySetComponentIsEnabled(stored_wand_id, item_component, true)
  EntitySetComponentIsEnabled(stored_wand_id, sprite_component, true)
  EntitySetComponentIsEnabled(stored_wand_id, light_component, true)

  EntityRemoveFromParent(stored_wand.entity_id)
  stored_wand:PlaceAt(x + 4, y - 30)
end
-- :)
function path_easter_egg(entity_id, x, y)
  EntityLoad("mods/anvil_of_destiny/files/entities/holy_bomb/floating.xml", x + 3, y - 42)
  finish(entity_id, x, y, true)
end
-- Play fanfare and make anvil un-reusable
function finish(entity_id, x, y, alternative)
  -- TODO: Dont remove collision trigger but instead luacomp?
  GameScreenshake(20, x, y)
  if alternative then
    GamePrintImportant("A gift from the gods...?", "Or is it?")
  else
    GamePrintImportant("A gift from the gods", "")
  end
  GamePlaySound("mods/anvil_of_destiny/audio/anvil_of_destiny.snd", "fanfare", x, y)
  edit_component(entity_id, "AudioLoopComponent", function(comp, vars)
    EntityRemoveComponent(entity_id, comp)
  end)
  edit_all_components(entity_id, "CollisionTriggerComponent", function(comp, vars)
    EntityRemoveComponent(entity_id, comp)
  end)
end

function get_wand_storage()
  local children = EntityGetAllChildren(GetUpdatedEntityID())
  for i, child in ipairs(children) do
    if EntityGetName(child) == "wand_storage" then
      return child
    end
  end
end

-- "Hides" a wand by removing it's visible components and adds it to the wand storage as a child entity so we can later retrieve it
function hide_wand(wand_id)
  -- Put the wand in the storage and disable all components that make it visible 
  EntityAddChild(get_wand_storage(), wand_id)
  -- Disable physics to keep it floating
  edit_component(wand_id, "SimplePhysicsComponent", function(comp, vars)
    EntitySetComponentIsEnabled(wand_id, comp, false)
  end)
  edit_component(wand_id, "ItemComponent", function(comp, vars)
    EntitySetComponentIsEnabled(wand_id, comp, false)
  end)
  edit_component(wand_id, "SpriteComponent", function(comp, vars)
    EntitySetComponentIsEnabled(wand_id, comp, false)
  end)
  edit_component(wand_id, "LightComponent", function(comp, vars)
    EntitySetComponentIsEnabled(wand_id, comp, false)
  end)
end

function retrieve_wand(index)
  local wand_storage = get_wand_storage()
  local stored_wands = EntityGetAllChildren(wand_storage)

  return stored_wands[index]
end

function set_runes_enabled(entity_id, which, enabled)
  local emitter1, emitter2
  local emitter1_powered, emitter2_powered
  local emitter_base_powered_up

  -- Find the emitters and save them into variables
  local all_components = EntityGetAllComponents(entity_id)
  local particle_emitter_components --, "ParticleEmitterComponent"
	for _, component in ipairs(all_components) do
		for k, v in pairs(ComponentGetMembers(component)) do
			if(k == "image_animation_file") then
        if v == "mods/anvil_of_destiny/files/entities/anvil/runes1.png" then
          local emitted_material_name = ComponentGetValue(component, "emitted_material_name")
          if emitted_material_name == "spark" then
            emitter1 = component
          elseif emitted_material_name == "spark_white_bright" then
            emitter1_powered = component
          end
        elseif v == "mods/anvil_of_destiny/files/entities/anvil/runes2.png" then
          local emitted_material_name = ComponentGetValue(component, "emitted_material_name")
          if emitted_material_name == "spark" then
            emitter2 = component
          elseif emitted_material_name == "spark_white_bright" then
            emitter2_powered = component
          end
        elseif v == "mods/anvil_of_destiny/files/entities/anvil/emitter.png" then
          emitter_base = component
        end
			end
		end
  end
  
  if which == "base" then
    EntitySetComponentIsEnabled(entity_id, emitter_base, enabled)
  elseif which == "emitter1" then
    EntitySetComponentIsEnabled(entity_id, emitter1, enabled)
  elseif which == "emitter1_powered" then
    EntitySetComponentIsEnabled(entity_id, emitter1_powered, enabled)
  elseif which == "emitter2" then
    EntitySetComponentIsEnabled(entity_id, emitter2, enabled)
  elseif which == "emitter2_powered" then
    EntitySetComponentIsEnabled(entity_id, emitter2_powered, enabled)
  else
    error("Argument 'which' is invalid.")
  end
end
