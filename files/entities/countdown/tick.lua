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
      GamePlaySound("mods/anvil_of_destiny/audio/anvil_of_destiny.snd", "tick_low", x, y)
    else
      GamePlaySound("mods/anvil_of_destiny/audio/anvil_of_destiny.snd", "tick_high", x, y)
    end
    local shrink_script_file = "mods/anvil_of_destiny/files/entities/countdown/shrink.lua"
    local lua_components = EntityGetComponent(entity_id, "LuaComponent")
    if lua_components ~= nil then
      for i, lua_component in ipairs(lua_components) do
        local script_source_file = ComponentGetValue(lua_component, "script_source_file")
        if script_source_file == shrink_script_file then
          EntityRemoveComponent(entity_id, lua_component)
        end
      end
    end
    EntityAddComponent(entity_id, "LuaComponent", {
      script_source_file=shrink_script_file,
      execute_on_added="1",
      execute_every_n_frame="1",
      execute_times="60"
    })
  end
end
