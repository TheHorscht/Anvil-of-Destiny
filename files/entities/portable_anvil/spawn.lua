dofile_once("data/scripts/lib/utilities.lua")

local time_buildup_start = 120
local time_spawn = time_buildup_start + 100

local entity_id = GetUpdatedEntityID()
local pos_x, pos_y = EntityGetTransform( entity_id )
local t = GameGetFrameNum()
local comp = get_variable_storage_component(entity_id, "throw_time")
local throw_time = ComponentGetValue2(comp, "value_int")

if throw_time < 0 then return end -- not thrown yet

if t == throw_time + time_buildup_start then
	-- buildup
	local e = EntityLoad("mods/anvil_of_destiny/files/entities/portable_anvil/buildup.xml", pos_x, pos_y)
	EntityAddChild(entity_id, e)
	EntitySetComponentsWithTagEnabled(entity_id, "enabled_before_spawn", true)
	GamePlaySound( "data/audio/Desktop/projectiles.snd", "player_projectiles/crumbling_earth/create", pos_x, pos_y )
elseif t == throw_time + time_spawn then
	GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/heart_fullhp/create", pos_x, pos_y )
	EntityLoad("mods/anvil_of_destiny/files/entities/portable_anvil/placeholder.xml", pos_x, pos_y - 100 + 10)
  -- This clears the area the room would spawn in
  LoadPixelScene("mods/anvil_of_destiny/files/entities/portable_anvil/clearer.png", "", pos_x - 125, pos_y - 200 + 10, "", true, false)
	-- cleanup
	EntityKill(entity_id)
end

