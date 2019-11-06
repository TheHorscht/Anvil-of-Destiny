local entity_id = GetUpdatedEntityID()

if g_mymod_anvil_state == nil then
  g_mymod_anvil_state = {}
end

function init_state()
  local entity_id = GetUpdatedEntityID()
  if g_mymod_anvil_state[entity_id] == nil then
    g_mymod_anvil_state[entity_id] = {
      collider_ticks = 0,
      level_indicator = EntityGetFirstComponent(entity_id, "SpriteComponent", "level_indicator"),
      level_indicator_number = EntityGetFirstComponent(entity_id, "SpriteComponent", "level_indicator_number")
    }
  end
end

function get_state()
  local entity_id = GetUpdatedEntityID()
  return g_mymod_anvil_state[entity_id]
end

function is_active_item(entity_id)
  local player = EntityGetWithTag("player_unit")[1]
  local inv = EntityGetComponent(player, "Inventory2Component")[1]
  local active_item = ComponentGetValueInt(inv, "mActiveItem")   
  if entity_id == active_item then
    return true
  else
    return false
  end
end

function get_wand_level(entity_id)
  for i=0,6 do
    if EntityHasTag(entity_id, "wand_level_"..i) then
      return i
    end
  end
end


init_state()
local x, y = EntityGetTransform(entity_id)
local wands = EntityGetInRadiusWithTag(x, y - 30, 30, "wand")
local active_item_level = nil
-- Try to find if any of the wands in the vicinity are the actively held item
-- or in other words, see if the actively held wand is in the vicinity
for i, v in ipairs(wands) do
  if is_active_item(v) then
    local level = get_wand_level(v)
    local level_to_show = "?"
    if level ~= nil then
      level_to_show = tostring(level)
    end
    active_item_level = level_to_show
  end
end

if active_item_level ~= nil then
  ComponentSetValue(get_state().level_indicator, "visible", "1")
  ComponentSetValue(get_state().level_indicator_number, "visible", "1")
  ComponentSetValue(get_state().level_indicator_number, "rect_animation", active_item_level)
else
  ComponentSetValue(get_state().level_indicator, "visible", "0")
  ComponentSetValue(get_state().level_indicator_number, "visible", "0")
  -- Remove itself and add level_indicator_trigger
  EntityRemoveComponent(entity_id, GetUpdatedComponentID())
  local level_indicator_trigger = EntityAddComponent(entity_id, "LuaComponent", {
    script_collision_trigger_hit="mods/anvil_of_destiny/files/entities/anvil/level_indicator_trigger.lua",
  })
end
