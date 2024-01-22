local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
local vx, vy = GameGetVelocityCompVelocity(entity_id)
local speed2 = vx^2 + vy^2
local current_frame_num = GameGetFrameNum()
local frame_last_movement_detected = GetValueInteger("frame_last_movement_detected", current_frame_num)
local _alpha = GetValueNumber("_alpha", 0)
if ComponentGetValue2(GetUpdatedComponentID(), "mLastExecutionFrame") < current_frame_num - 1 then
	_alpha = 0
end
if speed2 > 50 then
	frame_last_movement_detected = current_frame_num
	SetValueInteger("frame_last_movement_detected", frame_last_movement_detected)
end

local function get_distance2(x1, y1, x2, y2)
	return (x2 - x1) ^ 2 + (y2 - y1) ^ 2
end

local function get_distance2_to_player()
	local player = EntityGetWithTag("player_unit")[1]
	if player then
		local px, py = EntityGetTransform(player)
		return get_distance2(px, py, x, y)
	end
	return math.huge
end

local target_alpha = 0
if frame_last_movement_detected < current_frame_num - 60 and get_distance2_to_player() < 625 then -- 625 = 25²
	target_alpha = 1
end

local function smoothstep(edge0, edge1, x)
	x = math.max(0, math.min((x - edge0) / (edge1 - edge0), 1))
	return x * x * (3 - 2 * x)
end

for i, child in ipairs(EntityGetAllChildren(entity_id) or {}) do
	if EntityGetName(child) == "outline" then
		local sprite_component = EntityGetFirstComponentIncludingDisabled(child, "SpriteComponent")
		if sprite_component then
			EntitySetComponentIsEnabled(child, sprite_component, true)
			if target_alpha == 1 then
				_alpha = math.min(1, _alpha + 0.02)
			else
				_alpha = math.max(0, _alpha - 0.02)
			end
			SetValueNumber("_alpha", _alpha)
			local alpha = smoothstep(0, 1, _alpha)
			ComponentSetValue2(sprite_component, "alpha", alpha)
		end
	end
end
