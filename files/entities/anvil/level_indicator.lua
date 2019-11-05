local entity_id = GetUpdatedEntityID()

if g_mymod_anvil_state == nil then
  g_mymod_anvil_state = {}
end

if g_mymod_anvil_state[entity_id] == nil then
  g_mymod_anvil_state[entity_id] = {
    level_indicator = EntityGetFirstComponent(entity_id, "SpriteComponent", "level_indicator"),
    level_indicator_number = EntityGetFirstComponent(entity_id, "SpriteComponent", "level_indicator_number")
  }
end

function get_state()
  return g_mymod_anvil_state[entity_id]
end

function get_wand_level(entity_id)
  for i=0, 6 do
    if EntityHasTag(entity_id, "wand_level_"..i) then
       return i
    end
  end
end

function collision_trigger(colliding_entity_id)
  -- Show level indicator
  local level = get_wand_level(colliding_entity_id)
  ComponentSetValue(get_state().level_indicator, "visible", "1")
  ComponentSetValue(get_state().level_indicator_number, "visible", "1")
  local level_to_show = "?"
  if level ~= nil then
    level_to_show = tostring(level)
  end
  ComponentSetValue(get_state().level_indicator_number, "rect_animation", level_to_show)
end

local x, y = EntityGetTransform(entity_id)
local wands = EntityGetInRadiusWithTag(x, y - 30, 30, "wand")
local player = EntityGetWithTag("player_unit")[1]
local inv = EntityGetComponent(player, "Inventory2Component")[1]
local active_item = ComponentGetValueInt(inv, "mActiveItem")

local is_held_wand_close = false

for i, v in ipairs(wands) do
  if v == active_item then
    is_held_wand_close = true
    break
  end
end

if is_held_wand_close then
  collision_trigger(active_item)
else
  ComponentSetValue(get_state().level_indicator, "visible", "0")
  ComponentSetValue(get_state().level_indicator_number, "visible", "0")
end
