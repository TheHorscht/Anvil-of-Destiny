dofile( "data/scripts/lib/utilities.lua" )

function collision_trigger()
  -- local entity_id = EntityGetWithName("mymod_anvil")
  local entity_id = GetUpdatedEntityID()

	local components = EntityGetAllComponents( entity_id )
	if components == nil then
		return
	end

  for i,comp in ipairs( components ) do 
    EntitySetComponentsWithTagEnabled(entity_id, "emitter1", true)
  end
end

g_what = 0

function collision_trigger_timer_finished()
  local entity_id = GetUpdatedEntityID()
  local anvil_x, anvil_y = EntityGetTransform(entity_id)
  local closest_wand = EntityGetClosestWithTag(x, y, "wand")

  -- local distance = math.abs(py - y) * 0.5 + math.abs(px - x)
  local closest_wand_in_

  g_what = (g_what + 1) % 3
end