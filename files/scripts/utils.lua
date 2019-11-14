function table_shuffle(t) -- This same function seems to have a bug in data/scripts/gun/gun_procedural.lua
  local iterations = #t
  local j
  for i = iterations, 2, -1 do
      j = Random(1, i)
      t[i], t[j] = t[j], t[i]
  end
end

function table_get_key_count(t)
  local count = 0
  for _ in pairs(t) do count = count + 1 end
  return count
end

function string_split(inputstr, sep)
  sep = sep or "%s"
  local t = {}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

function math_average(t)
  local avg = 0
  for i,v in ipairs(t) do
    avg = avg + v
  end
  return avg / #t
end

-- Normalizes the values of a table so that they sum up to 1
function normalize_table(t)
  local sum = 0
  for i=1, #t do
    sum = sum + t[i]
  end
  for i=1, #t do
    t[i] = t[i] / sum
  end
end
-- Setting min higher than 0, close to 1 reduces the variance, for instance min=1 would result in {0.2, 0.2, 0.2, 0.2, 0.2}
function create_normalized_random_distribution(count, min)
  min = min or 0
  local out = {}
  local sum = 0
  for i=1, count do
    local random_number = min + Random() * (1 - min)
    sum = sum + random_number
    table.insert(out, random_number)
  end
  for i=1, count do
    out[i] = out[i] / sum
  end
  return out
end

function get_sign(num)
  num = tonumber(num)
  if num >= 0 then
    return 1
  else
    return -1
  end
end

function get_component_with_member(entity_id, member_name)
	local components = EntityGetAllComponents(entity_id)
	for _, component_id in ipairs(components) do
		for k, v in pairs(ComponentGetMembers(component_id)) do
			if(k == member_name) then
				return component_id
			end
		end
	end
end

function generate_unique_id(len, x, y)
  SetRandomSeed(x, y)
  local chars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
  local char_count = string.len(chars)
  local output = ""
  for i=1,len do
    local randIndex = Random(char_count)
    output = output .. string.sub(chars, randIndex, randIndex)
  end
  return output
end
