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
  if sum == 0 then
    for i=1, #t do
      t[i] = 1 / #t
    end
  else
    for i=1, #t do
      t[i] = t[i] / sum
    end
  end
end
-- Setting min higher than 0, close to 1 reduces the variance, for instance min=1 would result in {0.2, 0.2, 0.2, 0.2, 0.2}
function create_normalized_random_distribution(count, min)
  min = min or 0
  local out = {}
  for i=1, count do
    local random_number = min + Random() * (1 - min)
    table.insert(out, random_number)
  end
  normalize_table(out)
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
-- converts the subtables { min=2, max=5 } to a value using Random(min, max)
function config_populate_flat_buffs(flat_buff_amounts, rand_seed_x, rand_seed_y)
  local o = {}
  SetRandomSeed(rand_seed_x, rand_seed_y)
  for k,v in pairs(flat_buff_amounts) do
    o[k] = Random(v.min, v.max)
  end
  return o
end

function set_random_seed_with_player_position()
  local players = EntityGetWithTag("player_unit")
  if #players > 0 then
    local x, y = EntityGetTransform(players[1])
    SetRandomSeed(x, y)
  end
end

function table.imerge(t1, t2)
  local out = {}
  for i, v in ipairs(t1) do
    table.insert(out, v)
  end
  for i, v in ipairs(t2) do
    table.insert(out, v)
  end
  return out
end
-- Randomly either rounds up or down
function randround(val)
  if Random() < 0.5 then
    return math.ceil(val)
  else
    return math.floor(val)
  end
end

function clamp(val, lower, upper)
  if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
  return math.max(lower, math.min(upper, val))
end

function get_stored_entity_type(entity_id)
  local variable_storage_components = EntityGetComponent(entity_id, "VariableStorageComponent")
  if variable_storage_components ~= nil then
    for i, component in ipairs(variable_storage_components) do
      local name = ComponentGetValue(component, "name")
      local value_string = ComponentGetValue(component, "value_string")
      if name == "entity_type" then
        return value_string
      end
    end
  end
end

function is_debug()
  return GlobalsGetValue("anvil_of_destiny_debug", "0") == "1"
end

function get_variable_storage_component(entity_id, name)
  for i,comp_id in ipairs(EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent") or {}) do
    local var_name = ComponentGetValue2(comp_id, "name")
    if var_name == name then
      return comp_id
    end
  end
end

function get_anvil_state(anvil_id)
  dofile_once("mods/anvil_of_destiny/lib/StringStore/stringstore.lua")
  dofile_once("mods/anvil_of_destiny/lib/StringStore/noitavariablestore.lua")
	local state = stringstore.open_store(stringstore.noita.variable_storage_components(anvil_id))

	if state.wands == nil then
		state.wands = 0
		state.tablets = 0
		state.potions = 0
	end

	return state
end

function reenable_anvil(anvil_id)
  local anvil_x, anvil_y = EntityGetTransform(anvil_id)
  local state = get_anvil_state(anvil_id)
  state.wands = 0
  state.potions = 0
  state.tablets = 0
  state.is_disabled = false
  set_outline_emitter(anvil_id, false, {})
  set_runes_enabled(anvil_id, "emitter1_powered", false)
  set_runes_enabled(anvil_id, "emitter2_powered", false)
  set_runes_enabled(anvil_id, "emitter1", false)
  set_runes_enabled(anvil_id, "emitter2", false)
  set_runes_enabled(anvil_id, "base", false)
  EntityLoad("mods/anvil_of_destiny/files/entities/anvil/potion_place.xml", anvil_x + 5, anvil_y - 10)

  local audio_loop_component = EntityGetFirstComponentIncludingDisabled(anvil_id, "AudioLoopComponent")
  if audio_loop_component then
    EntitySetComponentIsEnabled(anvil_id, audio_loop_component, true)
  end
  local collision_trigger_components = EntityGetComponentIncludingDisabled(anvil_id, "CollisionTriggerComponent") or {}
  for i, comp in ipairs(collision_trigger_components) do
    EntitySetComponentIsEnabled(anvil_id, comp, true)
  end
  local lua_components = EntityGetComponentIncludingDisabled(anvil_id, "LuaComponent") or {}
  for i, comp in ipairs(lua_components) do
    if ComponentGetValue2(comp, "script_source_file") == "mods/anvil_of_destiny/files/entities/anvil/damage_checker.lua" then
      EntitySetComponentIsEnabled(anvil_id, comp, true)
      break
    end
  end
end