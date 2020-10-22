dofile_once("mods/anvil_of_destiny/files/entities/anvil/anvil.lua")

function item_pickup(entity_item, entity_pickupper, item_name)
  local x, y = EntityGetTransform(entity_item)
  local anvil_id
  for i, entity in ipairs(EntityGetInRadius(x, y + 20, 20)) do
    if EntityGetName(entity) == "anvil_of_destiny" then
      anvil_id = entity
      break
    end
  end
  if anvil_id then
    local anvil_x, anvil_y = EntityGetTransform(anvil_id)
    local state = get_state(anvil_id)
    state.wands = 0
    state.potions = 0
    state.tablets = 0
    set_outline_emitter(anvil_id, false, {})
    set_runes_enabled(anvil_id, "emitter1_powered", false)
    set_runes_enabled(anvil_id, "emitter2_powered", false)
    set_runes_enabled(anvil_id, "emitter1", false)
    set_runes_enabled(anvil_id, "emitter2", false)
    set_runes_enabled(anvil_id, "base", false)
    EntityLoad("mods/anvil_of_destiny/files/entities/anvil/potion_place.xml", anvil_x + 5, anvil_y - 10)

    local audio_loop_component = EntityGetFirstComponentIncludingDisabled(anvil_id, "AudioLoopComponent")
    if audio_loop_component then
      EntitySetComponentIsEnabled(anvil_id, audio_loop_component, true)
    end
    local collision_trigger_components = EntityGetComponentIncludingDisabled(anvil_id, "CollisionTriggerComponent") or {}
    for i, comp in ipairs(collision_trigger_components) do
      EntitySetComponentIsEnabled(anvil_id, comp, true)
    end
    local lua_components = EntityGetComponentIncludingDisabled(anvil_id, "LuaComponent") or {}
    for i, comp in ipairs(lua_components) do
      if ComponentGetValue2(v, "script_source_file") == "mods/anvil_of_destiny/files/entities/anvil/damage_checker.lua" then
        EntitySetComponentIsEnabled(anvil_id, comp, true)
        break
      end
    end

  end
  EntityRemoveComponent(entity_item, GetUpdatedComponentID())
end
