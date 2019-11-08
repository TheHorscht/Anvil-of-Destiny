stringstore.noita = stringstore.noita or {}

local function set_cached_varstorage_primitive(entity_id, storage_cache, key, val)
	if not storage_cache[key] then
		storage_cache[key] = EntityAddComponent(entity_id, "VariableStorageComponent", {
			name = key,
			value_string = val
		})
	else
		ComponentSetValue(storage_cache[key], "value_string", val)
	end
end

local function get_cached_varstorage_primitive(storage_cache, key)
	if not storage_cache[key] then
		return nil
	else
		return ComponentGetValue(storage_cache[key], "value_string")
	end
end

function stringstore.noita.variable_storage_components(entity_id)
	local components = EntityGetComponent(entity_id, "VariableStorageComponent")
	local storage_cache = {}

	if components ~= nil then
		for i, v in ipairs(components) do
			local name = ComponentGetValue(v, "name")
			storage_cache[name] = v
		end
	end

	return {
		set_type = function(key, val)
			set_cached_varstorage_primitive(entity_id, storage_cache, key .. ".type", val)
		end,

		set = function(key, val)
			set_cached_varstorage_primitive(entity_id, storage_cache, key, val)
		end,

		get_type = function(key, val)
			return get_cached_varstorage_primitive(storage_cache, key .. ".type")
		end,

		get = function(key)
			return get_cached_varstorage_primitive(storage_cache, key)
		end,

		get_sub_prefix = function(key)
			return key .. ".idx."
		end,

		get_typed_key = function(key, type)
			return key .. ":" .. type
		end,

		restrict = function(key)
			if key:find("\\.") or key:find(":") then
				error("Cannot use the dot ('.') character or the colon character (':') in the VariableStorageComponent stringstore")
			end
		end
	}
end