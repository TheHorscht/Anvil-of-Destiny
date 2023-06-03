local entity_id = GetUpdatedEntityID()
local player = EntityGetWithTag("player_unit")[1]
if not player then
  EntityAddComponent2(entity_id, "LuaComponent", {
    script_source_file="mods/anvil_of_destiny/files/entities/anvil/mimic/fade_away.lua",
    execute_every_n_frame=1,
  })
  EntityRemoveComponent(entity_id, GetUpdatedComponentID())
  return
end

local acceleration = 0.10
local max_speed = 5
local angular_acceleration = 0.01
local bite_hitbox_radius = 10

local is_clicked = false

local Controls_comp = EntityGetFirstComponentIncludingDisabled(player, "ControlsComponent")
-- is_clicked = ComponentGetValue2(Controls_comp, "mButtonFrameLeftClick") == GameGetFrameNum()

-- Calculate how many frames it takes to reach the destination
function calculateETA(x, y, target_x, target_y, speed, acc)
  local frames = 0
  local dir = get_direction(x, y, target_x, target_y)
  local dx = math.cos(dir)
  local dy = math.sin(dir)
  local dist = get_distance(x, y, target_x, target_y)
  -- Don't use while loop because maybe it could get into an infinite loop
  for i=1, 100 do
    dist = get_distance(x, y, target_x, target_y)
    speed = math.min(max_speed, speed + acc)
    x = x + dx * math.min(dist, speed)
    y = y + dy * math.min(dist, speed)
    frames = frames + 1
    if dist <= 10 then
      break
    end
  end
  return frames
end

function vec_rotate(x, y, angle)
	local ca = math.cos(angle)
	local sa = math.sin(angle)
	local px = ca * x - sa * y
	local py = sa * x + ca * y
	return px,py
end

function get_angle_difference(a, b)
  return ((a - b) + math.pi) % (math.pi*2) - math.pi
end

function get_direction( x1, y1, x2, y2 )
	return math.atan2( ( y2 - y1 ), ( x2 - x1 ) )
end

function get_magnitude( x, y )
	local result = math.sqrt( x ^ 2 + y ^ 2 )
	return result
end

function vec_normalize(x, y)
	local m = get_magnitude(x, y)
	if m == 0 then return 0,0 end
	x = x / m
	y = y / m
	return x,y
end

function get_distance(x1, y1, x2, y2)
  local dx = x1 - x2
  local dy = y1 - y2
  return math.sqrt(dx*dx + dy*dy)
end

function get_distance2(x1, y1, x2, y2)
  local dx = x1 - x2
  local dy = y1 - y2
  return dx*dx + dy*dy
end

function move_angle_towards(current_angle, target_angle, speed)
  -- Make angle go from 0 to 2pi
  if target_angle < 0 then
    target_angle = target_angle + math.pi * 2
  end
  if current_angle < 0 then
    current_angle = current_angle + math.pi * 2
  end

  local dist_up = math.abs(target_angle - current_angle)
  local dist_down = math.abs((current_angle + math.pi * 2) - target_angle)
  if current_angle > target_angle then
    dist_up = math.abs((target_angle + math.pi * 2) - current_angle)
    dist_down = math.abs(current_angle - target_angle)
  end

  local dir
  if math.abs(dist_up) < math.abs(dist_down) then
    dir = 1
  else
    dir = -1
  end

  local new_angle = current_angle + speed * dir
  if dir > 0 and current_angle < target_angle and new_angle > target_angle then
    new_angle = target_angle
  elseif dir <= 0 and current_angle > target_angle and new_angle < target_angle then
  -- elseif dir < 0 and current_angle > target_angle and new_angle < target_angle  then
    new_angle = target_angle
  end
  new_angle = new_angle % (math.pi * 2)

  return new_angle
end

-- local target_x, target_y = DEBUG_GetMouseWorld()
local target_x, target_y = EntityGetTransform(player)
local x, y, rot = EntityGetTransform(entity_id)

local angular_velocity = GetValueNumber("angular_velocity", 0)
local vx = GetValueNumber("vx", 0)
local vy = GetValueNumber("vy", 0)
local speed = GetValueNumber("speed", 0.5)

local target_angle = get_direction(x, y, target_x, target_y)
local new_rot = move_angle_towards(rot, target_angle + math.rad(90), angular_velocity)
local angle_diff = get_angle_difference(rot, target_angle + math.rad(90))

if math.abs(angular_velocity) < 0.1 then
  angular_velocity = angular_velocity + angular_acceleration
end

if math.abs(angle_diff) < 0.01 and not GetValueBool("charging", false) then
  angular_velocity = angular_velocity * 0.98
  -- Start charging by picking a target behind the player first
  local dx = target_x - x
  local dy = target_y - y
  local magnitude = get_magnitude(dx, dy)
  magnitude = math.max(30, math.min(100, magnitude))
  local nx, ny = vec_normalize(dx, dy)

  SetValueBool("charging", true)
  SetValueNumber("target_x", target_x + nx * magnitude)
  SetValueNumber("target_y", target_y + ny * magnitude)
end

if GetValueBool("charging", false) then
  local target_x = GetValueNumber("target_x", target_x)
  local target_y = GetValueNumber("target_y", target_y)
  local dir = get_direction(x, y, target_x, target_y)
  local dist = get_distance(x, y, target_x, target_y)
  local dx = math.cos(dir)
  local dy = math.sin(dir)
  speed = math.min(max_speed, speed + acceleration)
  x = x + dx * math.min(dist, speed)
  y = y + dy * math.min(dist, speed)
  if dist <= 10 then
    speed = 0
    SetValueBool("charging", false)
  end
end

local dx = x - target_x
local dy = y - target_y
local distance_to_target = dx * dx + dy * dy

function handle_bite_damage()
  local offsets = {
    { 20, -17 },
    { 10, -17 },
    { 0, -17 },
    { -10, -17 },
    { -20, -15 },
  }
  for i, v in ipairs(offsets) do
    local dx, dy = vec_rotate(v[1], v[2], rot)
    if get_distance2(x + dx, y + dy, target_x, target_y) < bite_hitbox_radius * bite_hitbox_radius then
      -- Deal a minimum of 5% of max hp to the target, or 25, whatever is bigger
      local damage_model_component = EntityGetFirstComponentIncludingDisabled(player, "DamageModelComponent")
      if damage_model_component then
        local max_hp = ComponentGetValue2(damage_model_component, "max_hp")
        local damage = math.max(max_hp * 0.05, 1)
        EntityInflictDamage(player, damage, "DAMAGE_BITE", "Anvil... bite?!", "NORMAL", 0, 0, entity_id)
        GamePlaySound("data/audio/Desktop/animals.bank", "animals/generic/attack_bite", x, y)
      end
      break
    end
  end
end

function set_rect_animation(animation)
  local entity_id = GetUpdatedEntityID()
  local sprite_component = EntityGetFirstComponentIncludingDisabled(entity_id, "SpriteComponent")
  if sprite_component then
    ComponentSetValue2(sprite_component, "image_file", animation)
    EntityRefreshSprite(entity_id, sprite_component)
  end
end

local frame = GetValueInteger("bite_frame", 0)
local is_biting = GetValueBool("is_biting", false)
local frames_max = 6
local frame_delay = 4

function update_bite()
  if is_biting then
    frame = (frame + 1) % (frame_delay * frames_max + 1)
    local animation_frame = math.floor(frame / frame_delay)
    if frame == 4 * frame_delay then
      handle_bite_damage()
    elseif frame == frames_max * frame_delay then
      is_biting = false
      frame = 0
      set_rect_animation("mods/anvil_of_destiny/files/entities/anvil/mimic/anim_1.png")
    else
      set_rect_animation(("mods/anvil_of_destiny/files/entities/anvil/mimic/anim_%d.png"):format(animation_frame + 1))
    end
  end
end
update_bite()

if not is_biting then
  local eta = calculateETA(x, y, target_x, target_y, speed, acceleration)
  if eta == 17 then
    is_biting = true
  end
end

-- Hitbox stuff
local offsets = {
  -- Top
  { 30, -17, 5},
  { 20, -17, 5 },
  { 10, -17, 5 },
  { 0, -17, 5 },
  { -10, -17, 5 },
  -- "Beak"
  { -20, -15, 4 },
  { -30, -15, 4 },
  -- Body
  { -3, -4, 7 },
  { 5, -4, 7 },
  { 2, 2, 8 },
}
-- Create hitboxes if they don't exist already
if not EntityGetFirstComponentIncludingDisabled(entity_id, "HitboxComponent") then
  for i, v in ipairs(offsets) do
    local hitbox_size = v[3]--5
    EntityAddComponent2(entity_id, "HitboxComponent", {
      aabb_min_x=-hitbox_size,
      aabb_max_x=hitbox_size,
      aabb_min_y=-hitbox_size,
      aabb_max_y=hitbox_size,
    })
  end
end
for i, comp in ipairs(EntityGetComponentIncludingDisabled(entity_id, "HitboxComponent") or {}) do
  ComponentSetValue2(comp, "offset",
    math.cos(rot) * offsets[i][1] + math.sin(rot) * -offsets[i][2],
    math.sin(rot) * offsets[i][1] + math.cos(rot) * offsets[i][2]
  )
end

SetValueNumber("speed", speed)
SetValueNumber("angular_velocity", angular_velocity)
SetValueNumber("vx", vx)
SetValueNumber("vy", vy)
SetValueBool("is_biting", is_biting)
SetValueInteger("bite_frame", frame)
EntitySetTransform(entity_id, x, y, new_rot)
