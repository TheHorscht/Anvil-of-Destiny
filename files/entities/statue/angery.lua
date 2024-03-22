dofile_once("mods/anvil_of_destiny/files/scripts/utils.lua")
dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

function shoot_projectile_at(who_shot, entity_file, x, y, target_x, target_y, send_message)
	local entity_id = EntityLoad( entity_file, x, y )
	local herd_id   = get_herd_id( who_shot )
	if( send_message == nil ) then send_message = true end

  GameShootProjectile( who_shot, x, y, target_x, target_y, entity_id, send_message )

	edit_component( entity_id, "ProjectileComponent", function(comp,vars)
		vars.mWhoShot       = who_shot
		vars.mShooterHerdId = herd_id
	end)

	return entity_id
end

function vector_scale(vec, scalar)
  vec.x = vec.x * scalar
  vec.y = vec.y * scalar
end

function vector_get_magnitude(vec)
  local dood = math.sqrt(vec.x * vec.x + vec.y * vec.y)
  return dood
end

function vector_get_magnitude_squared(vec)
  local dood = vec.x * vec.x + vec.y + vec.y
  return math.abs(dood)
end

function vector_normalize(vec)
  local magnitude = vector_get_magnitude(vec)
  vec.x = vec.x / magnitude
  vec.y = vec.y / magnitude
end

local player_entity = EntityGetWithTag("player_unit")
if player_entity ~= nil and player_entity[1] ~= nil then
  local px, py = EntityGetTransform(player_entity[1])
  local p = { x = px, y = py - 4 }
  local statue_eyes_pos = nil

  if get_stored_entity_type(entity_id) == "statue_facing_left" then
    statue_eyes_pos = { x = x + 6, y = y - 18 }
  else
    statue_eyes_pos = { x = x - 7, y = y - 18 }
  end

  local function point_can_be_seen(vec_origin, vec_destination, distance_max)
    local d = {
      x = vec_destination.x - vec_origin.x,
      y = vec_destination.y - vec_origin.y
    }
    local distance = vector_get_magnitude(d)
    vector_normalize(d)
    vector_scale(d, distance - 10)
    -- Will return true if it hit a wall or something
    local has_hit_something = Raytrace(vec_origin.x, vec_origin.y, vec_origin.x + d.x, vec_origin.y + d.y)
    return not has_hit_something and distance < distance_max
  end

  if point_can_be_seen(statue_eyes_pos, p, 200) then
    shoot_projectile_at(entity_id, "data/entities/projectiles/deck/laser.xml", statue_eyes_pos.x, statue_eyes_pos.y, p.x, p.y, false)
  end
end
