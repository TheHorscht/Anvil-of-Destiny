dofile("mods/anvil_of_destiny/lib/StringStore/stringstore.lua")
dofile("mods/anvil_of_destiny/lib/StringStore/noitavariablestore.lua")


local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local STATE = stringstore.open_store(stringstore.noita.variable_storage_components(entity_id))

STATE.tick = (STATE.tick or 0) + 1

if STATE.tick <= 3 then
  local sprite_component = EntityGetComponent(entity_id, "SpriteComponent")
  if sprite_component ~= nil and sprite_component[1] ~= nil then
    local number_to_show = tostring(STATE.tick)
    if STATE.tick == 3 then
      number_to_show = "5"
    end
    ComponentSetValue(sprite_component[1], "rect_animation", number_to_show)
    ComponentSetValue(sprite_component[1], "alpha", "1")
    if STATE.tick < 3 then
      GamePlaySound("mods/anvil_of_destiny/fmod/Build/Desktop/anvil_of_destiny.snd", "tick_low", x, y)
    else
      GamePlaySound("mods/anvil_of_destiny/fmod/Build/Desktop/anvil_of_destiny.snd", "tick_high", x, y)
    end
    local shrink_script = EntityGetFirstComponent(entity_id, "LuaComponent", "script_shrink")
    if shrink_script ~= nil then
      EntityRemoveComponent(entity_id, shrink_script)
    end
    EntityAddComponent(entity_id, "LuaComponent", {
      script_source_file="mods/anvil_of_destiny/files/entities/countdown/shrink.lua",
      execute_on_added="1",
      execute_every_n_frame="1",
      execute_times="60"
    })
  end
end
