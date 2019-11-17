--[[ dofile("mods/anvil_of_destiny/lib/StringStore/stringstore.lua")
dofile("mods/anvil_of_destiny/lib/StringStore/noitavariablestore.lua") ]]

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
-- local STATE = stringstore.open_store(stringstore.noita.variable_storage_components(entity_id))

local sprite_component = EntityGetComponent(entity_id, "SpriteComponent")
if sprite_component ~= nil and sprite_component[1] ~= nil then
  local alpha = ComponentGetValue(sprite_component[1], "alpha")
  if alpha ~= nil then
    alpha = tonumber(alpha)
  end
  ComponentSetValue(sprite_component[1], "alpha", alpha - 0.016666666)
end

print("shrinking")

--[[ <LuaComponent
script_source_file="mods/anvil_of_destiny/files/entities/countdown/shrink.lua"
execute_on_added="1"
execute_every_n_frame="1"
execute_times="60"
>
</LuaComponent> ]]