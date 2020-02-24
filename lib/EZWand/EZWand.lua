-- ########################################
-- #######   EZWand version 1.0.1   #######
-- ########################################

dofile_once("data/scripts/gun/procedural/gun_action_utils.lua")
dofile_once("data/scripts/lib/utilities.lua")
dofile_once("data/scripts/gun/procedural/wands.lua")
dofile_once("data/scripts/gun/procedural/gun_procedural.lua")

-- ##########################
-- ####       UTILS      ####
-- ##########################

wand_props = {
  shuffle = {
    validate = function(val)
      local v = tonumber(val)
      local err = "shuffle needs to be 1 or 0"
      assert(type(v) == "number", err)
      assert(v == 0 or v == 1, err)
    end,
    default = 0,
  },
  spellsPerCast = {
    validate = function(val)
      local v = tonumber(val)
      local err = "spellsPerCast needs to be a number > 0"
      assert(type(v) == "number", err)
      assert(v > 0, err)
    end,
    default = 1,
  },
  castDelay = {
    validate = function(val)
      local v = tonumber(val)
      local err = "castDelay needs to be a number"
      assert(type(v) == "number", err)
    end,
    default = 20,
  },
  rechargeTime = {
    validate = function(val)
      local v = tonumber(val)
      local err = "rechargeTime needs to be a number"
      assert(type(v) == "number", err)
    end,
    default = 40,
  },
  manaMax = {
    validate = function(val)
      local v = tonumber(val)
      local err = "manaMax needs to be a number > 0"
      assert(type(val) == "number", err)
      assert(v > 0, err)
    end,
    default = 500,
  },
  mana = {
    validate = function(val)
      local v = tonumber(val)
      local err = "mana needs to be a number > 0"
      assert(type(val) == "number", err)
      assert(v > 0, err)
    end,
    default = 500,
  },
  manaChargeSpeed = {
    validate = function(val)
      local v = tonumber(val)
      local err = "manaChargeSpeed needs to be a number > 0"
      assert(type(val) == "number", err)
      assert(val > 0, err)
    end,
    default = 200,
  },
  capacity = {
    validate = function(val)
      local v = tonumber(val)
      local err = "capacity needs to be a number > 0"
      assert(type(val) == "number", err)
      assert(val > 0, err)
    end,
    default = 10,
  },
  spread = {
    validate = function(val)
      local v = tonumber(val)
      local err = "spread needs to be a number"
      assert(type(val) == "number", err)
    end,
    default = 10,
  },
  speedMultiplier = {
    validate = function(val)
      local v = tonumber(val)
      local err = "spread needs to be a number"
      assert(type(val) == "number", err)
    end,
    default = 1,
  },
}

--[[
  values is a table that contains info on what values to set
  example:
  values = {
    manaMax = 50,
    rechargeSpeed = 20
  }
  etc
  calls error() if values contains invalid properties
  fills in missing properties with default values
]]
function validate_wand_properties(values)
  if type(values) ~= "table" then
    error("Arg 'values': table expected.")
  end
  -- Check if all passed in values are valid wand properties and have the required type
  for k,v in pairs(values) do
    if wand_props[k] == nil then
      error("Key '" .. tostring(k) .. "' is not a valid wand property.")
    else
      -- The validate function calls error() if the validation fails
      wand_props[k].validate(v)
    end
  end
  -- Fill in missing properties with default values
  for k,v in pairs(wand_props) do
    values[k] = values[k] or v.default
  end
  return values
end

 function table.contains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function get_component_with_member(entity_id, member_name)
  local components = EntityGetAllComponents(entity_id)
  if components ~= nil then
    for _, component_id in ipairs(components) do
      for k, v in pairs(ComponentGetMembers(component_id)) do
        if(k == member_name) then
          return component_id
        end
      end
    end
  end
end

-- Returns true if entity is a wand
local function entity_is_wand(entity_id)
	local comp = EntityGetComponent(entity_id, "ManaReloaderComponent")
	return comp ~= nil
end

local function ends_with(str, ending)
  return ending == "" or str:sub(-#ending) == ending
end

local function get_ability_component(entity_id)
  local ability_components = EntityGetComponent(entity_id, "AbilityComponent")
  if ability_components ~= nil and ability_components[1] ~= nil then
    return ability_components[1]
  else
    local components = EntityGetAllComponents(entity_id)
    for i, component_id in ipairs(components) do
      for k, v2 in pairs(ComponentGetMembers(component_id)) do
        if(k == "mItemRecoil") then
          return component_id
        end
      end
    end
  end
end

local function validate_property(name, value)
  if wand_props[name] == nil then
    error(name .. " is not a valid wand property.")
  end
  if value ~= nil then
    -- check if value has the correct format etc for key
  end
end

local function GetHotspotComponent(entity_id)
  local comps = EntityGetAllComponents(entity_id)
  for i,v in ipairs(comps) do
    if ComponentGetValue(v, "transform_with_scale") ~= "" then
      return v
    end
  end
end

-- This version just updates image_file of the original SpriteComponent, which will only update the visuals once
-- the next game tick comes along that updates sprites (every 60 frames?)
local function SetWandSprite_old(entity_id, ability_comp, item_file, offset_x, offset_y, tip_x, tip_y)
	if ability_comp ~= nil then
    ComponentSetValue(ability_comp, "sprite_file", item_file)
	end
	local sprite_comp = EntityGetFirstComponent(entity_id, "SpriteComponent", "item")
	if sprite_comp ~= nil then
		ComponentSetValue(sprite_comp, "image_file", item_file)
		ComponentSetValue(sprite_comp, "offset_x", offset_x)
    ComponentSetValue(sprite_comp, "offset_y", offset_y)
	end
	local hotspot_comp = GetHotspotComponent(entity_id) --EntityGetFirstComponent(entity_id, "HotspotComponent", "shoot_pos")
  if hotspot_comp ~= nil then
    -- EntitySetComponentIsEnabled(entity_id, hotspot_comp, true)
    ComponentSetValueVector2(hotspot_comp, "offset", tip_x, tip_y)
	end	
end

-- Updating the image_file attribute takes some frames to take effect,
-- the game only updates sprites every 60 frames or something, so to work around that
-- we create a new SpriteComponent, copy over all values of the old one, and remove the old one
-- This will show the new Sprite instantly, but is slower than the old version
local function SetWandSprite(entity_id, ability_comp, item_file, offset_x, offset_y, tip_x, tip_y)
	if ability_comp ~= nil then
    ComponentSetValue(ability_comp, "sprite_file", item_file)
	end
  local sprite_comp = EntityGetFirstComponent(entity_id, "SpriteComponent", "item")
  
  local function GetComponentValues(comp, value_names)
    local values_out = {
      _tags="enabled_in_hand,enabled_in_world,item",
      image_file=item_file,
      offset_x=offset_x,
      offset_y=offset_y,
    }
    for i, value_name in ipairs(value_names) do
      values_out[value_name] = ComponentGetValue(comp, value_name)
    end
    return values_out
  end

	if sprite_comp ~= nil then
    EntityAddComponent(entity_id, "SpriteComponent", GetComponentValues(sprite_comp, {
      "additive",
      "alpha",
      "emissive",
      "fog_of_war_hole",
      "has_special_scale",
      "is_text_sprite",
      "kill_entity_after_finished",
      "never_ragdollify_on_death",
      "rect_animation",
      "next_rect_animation",
      "offset_x",
      "offset_y",
      "smooth_filtering",
      "special_scale_x",
      "special_scale_y",
      "text",
      "ui_is_parent",
      "update_transform",
      "update_transform_rotation",
      "visible",
      "z_index",
    }))
    EntityRemoveComponent(entity_id, sprite_comp)
	end
	local hotspot_comp = GetHotspotComponent(entity_id) --EntityGetFirstComponent(entity_id, "HotspotComponent", "shoot_pos")
  if hotspot_comp ~= nil then
    -- EntitySetComponentIsEnabled(entity_id, hotspot_comp, true)
    ComponentSetValueVector2(hotspot_comp, "offset", tip_x, tip_y)
	end	
end

local function GetWandSprite(entity_id, ability_comp)
  local item_file, offset_x, offset_y, tip_x, tip_y
	if ability_comp ~= nil then
		item_file = ComponentGetValue(ability_comp, "sprite_file")
	end
	local sprite_comp = EntityGetFirstComponent(entity_id, "SpriteComponent", "item")
	if sprite_comp ~= nil then
		offset_x = ComponentGetValue(sprite_comp, "offset_x")
    offset_y = ComponentGetValue(sprite_comp, "offset_y")
	end
	local hotspot_comp = GetHotspotComponent(entity_id) --EntityGetFirstComponent(entity_id, "HotspotComponent", "shoot_pos")
  if hotspot_comp ~= nil then
    tip_x, tip_y = ComponentGetValueVector2(hotspot_comp, "offset")
  end
  return item_file, offset_x, offset_y, tip_x, tip_y
end

-- ##########################
-- ####    UTILS END     ####
-- ##########################

local wand = {}
-- Setter
wand.__newindex = function(table, key, value)
  if rawget(table, "_protected")[key] ~= nil then
    error("Cannot set protected property '" .. key .. "'")
  end
  table:SetProperties({ [key] = value })
end
-- Getter
wand.__index = function(table, key)
  if type(rawget(wand, key)) == "function" then
    return rawget(wand, key)
  end
  if rawget(table, "_protected")[key] ~= nil then
    return rawget(table, "_protected")[key]
  end
  return table:GetProperties({ key })[key]
end

function wand:new(from, rng_seed_x, rng_seed_y)
  -- 'protected' should not be accessed by end users!
  local protected = {}
  local o = {
    _protected = protected
  }
  setmetatable(o, self)
  if type(from) == "table" or from == nil then
    -- Just load some existing wand that we alter later instead of creating one from scratch
    protected.entity_id = EntityLoad("data/entities/items/wand_level_04.xml")
    protected.ability_component = get_ability_component(protected.entity_id)
    -- Copy all validated props over or initialize with defaults
    local props = from or {}
    validate_wand_properties(props)
    o:SetProperties(props)
    o:RemoveSpells()
    o:DetachSpells()
  elseif type(from) == "number" then
    -- Wrap an existing wand
    protected.entity_id = from
    protected.ability_component = get_ability_component(protected.entity_id)
  else
    -- Load a wand by xml
    if ends_with(from, ".xml") then
      local player_unit = EntityGetWithTag("player_unit")[1]
      local x, y = EntityGetTransform(player_unit)
      protected.entity_id = EntityLoad(from, rng_seed_x or x, rng_seed_y or y)
      protected.ability_component = get_ability_component(protected.entity_id)
    else
      error("Wrong format for wand creation.")
    end
  end

  if not entity_is_wand(protected.entity_id) then
    error("Loaded entity is not a wand.")
  end

  return o
end

local variable_mappings = {
  shuffle = { target = "gun_config", name = "shuffle_deck_when_empty" },
  spellsPerCast = { target = "gun_config", name="actions_per_round"},
  castDelay = { target = "gunaction_config", name="fire_rate_wait"},
  rechargeTime = { target = "gun_config", name="reload_time"},
  manaMax = { target = "ability_component", name="mana_max"},
  mana = { target = "ability_component", name="mana"},
  manaChargeSpeed = { target = "ability_component", name="mana_charge_speed"},
  capacity = { target = "gun_config", name="deck_capacity"},
  spread = { target = "gunaction_config", name="spread_degrees"},
  speedMultiplier = { target = "gunaction_config", name="speed_multiplier"},
}

-- Sets the actual property on the corresponding component/object
function wand:_SetProperty(key, value)
  local mapped_key = variable_mappings[key].name
  local target_setters = {
    ability_component = function(key, value)
      ComponentSetValue(self.ability_component, key, value)
    end,
    gunaction_config = function(key, value)
      ComponentObjectSetValue(self.ability_component, "gunaction_config", key, value)
    end,
    gun_config = function(key, value)
      ComponentObjectSetValue(self.ability_component, "gun_config", key, value)
    end,
  }
  -- We need a special rule for capacity, since always cast spells count towards capacity, but not in the UI...
  if key == "capacity" then
    -- TODO: set capacity to value + numalwayscastspells
    value = value + select(2, self:GetSpellsCount())
  end
  target_setters[variable_mappings[key].target](mapped_key, tostring(value))
end
-- Retrieves the actual property from the component or object
function wand:_GetProperty(key)
  local mapped_key = variable_mappings[key].name
  local target_getters = {
    ability_component = function(key)
      return ComponentGetValue(self.ability_component, key, value)
    end,
    gunaction_config = function(key)
      return ComponentObjectGetValue(self.ability_component, "gunaction_config", key)
    end,
    gun_config = function(key)
      return ComponentObjectGetValue(self.ability_component, "gun_config", key)
    end,
  }
  local result = target_getters[variable_mappings[key].target](mapped_key)
  -- We need a special rule for capacity, since always cast spells count towards capacity, but not in the UI...
  if key == "capacity" then
    result = result - select(2, self:GetSpellsCount())
  end
  return tonumber(result)
end

function wand:SetProperties(key_values)
  for k,v in pairs(key_values) do
    validate_property(k)
    self:_SetProperty(k, v)
  end
end

function wand:GetProperties(keys)
  -- Return all properties when empty
  if keys == nil then
    keys = {}
    for k,v in pairs(wand_props) do
      table.insert(keys, k)
    end
  end
  local result = {}
  for i,key in ipairs(keys) do
    validate_property(key)
    result[key] = self:_GetProperty(key)
  end
  return result
end
-- For making the interface nicer, this allows us to use this one function here for
function wand:_AddSpells(spells, attach)
  if type(spells) ~= "table" then
    error("'spells' should be a table with action_id strings")
  end
  -- Check if capacity is sufficient
  if not attach and self:GetSpellsCount() + #spells > tonumber(self.capacity) then
    error("Wand capacity too low to add that many spells.")
  end
  for i,action_id in ipairs(spells) do
    if not attach then
      AddGunAction(self.entity_id, action_id)
    else
      -- Extend slots to not consume one slot
      self.capacity = self.capacity + 1
      AddGunActionPermanent(self.entity_id, action_id)
    end
  end
end
-- Input can be a table of action_ids, or multiple arguments
-- e.g.:
-- AddSpells("BLACK_HOLE")
-- AddSpells("BLACK_HOLE", "BLACK_HOLE", "BLACK_HOLE")
-- AddSpells({"BLACK_HOLE", "BLACK_HOLE"})
function wand:AddSpells(...)
  local spells
  if type(...) ~= "table" then
    spells = {...}
  else
    spells = ...
  end
  self:_AddSpells(spells, false)
end
-- Same as AddSpells but permanently attach the spells
function wand:AttachSpells(...)
  local spells
  if type(...) ~= "table" then
    spells = {...}
  else
    spells = ...
  end
  self:_AddSpells(spells, true)
end
-- Returns: spells_count, always_cast_spells_count
function wand:GetSpellsCount()
	local children = EntityGetAllChildren(self.entity_id)
  local num_children = children and #children or 0
  
  if children == nil then
    return 0, 0
  end
  -- Count the number of always cast spells
  local always_cast_spells_count = 0
  for i,v in ipairs(children) do
    local all_comps = EntityGetAllComponents(v)
    for i, c in ipairs(all_comps) do
      if ComponentGetValue(c, "permanently_attached") == "1" then
        always_cast_spells_count = always_cast_spells_count + 1
      end
    end
  end

	return num_children - always_cast_spells_count, always_cast_spells_count
end
-- Returns two values:
-- 1: table of spells with each entry having the format { action_id = "BLACK_HOLE", inventory_x = 1, entity_id = <action_entity_id> }
-- 2: table of attached spells with the same format
-- inventory_x should give the position in the wand slots, 1 = first up to num_slots
-- inventory_x is not working yet
function wand:GetSpells()
	local spells = {}
	local always_cast_spells = {}
	local children = EntityGetAllChildren(self.entity_id)
  if children == nil then
    return spells, always_cast_spells
  end
	for _, v in ipairs(children) do
		local all_comps = EntityGetAllComponents(v)
		local action_id = nil
		local permanent = false
		local inventory_x = -1
		-- TODO: Refactor this when EntityGetComponent() returns disabled components...
		for _, c in ipairs(all_comps) do
			-- ItemActionComponent::action_id
			local val = ComponentGetValue(c, "action_id")
			if val ~= "" then
				action_id = val
			end
			-- ItemComponent::permanently_attached
			val = ComponentGetValue(c, "permanently_attached")
			if val ~= "" then
				if val == "1" then
					permanent = true
				end
				local inventory_y
				-- ItemComponent::inventory_slot.x [0, count] gives the slot it's in
        -- Does not work yet, always returns 0, 0...
				inventory_x, inventory_y = ComponentGetValueVector2(c, "inventory_slot")
			end
		end
		if action_id ~= nil then
			if permanent == true then
				table.insert(always_cast_spells, { action_id = action_id, entity_id = v, inventory_x = inventory_x })
			else
				table.insert(spells, { action_id = action_id, entity_id = v, inventory_x = inventory_x })
			end
		end
	end
	return spells, always_cast_spells
end

function wand:_RemoveSpells(action_ids, detach)
	local spells, attached_spells = self:GetSpells()
  local which = detach and attached_spells or spells
  for i,v in ipairs(which) do
    if action_ids == nil or table.contains(action_ids, v.action_id) then
      EntityRemoveFromParent(v.entity_id)
    end
  end
end
-- action_ids = {"BLACK_HOLE", "GRENADE"} remove all spells of those types
-- If action_ids is empty, remove all spells
function wand:RemoveSpells(...)
  local args = {...}
  local spells
  if #args == 0 then
    spells = nil
  elseif type(args[1]) == "table" then
    spells = ...
  else
    spells = { ... }
  end
  self:_RemoveSpells(spells, false)
end
function wand:DetachSpells(...)
  local args = {...}
  local spells
  if #args == 0 then
    spells = nil
  elseif type(args[1]) == "table" then
    spells = ...
  else
    spells = { ... }
  end
  self:_RemoveSpells(spells, true)
end

function wand:Clone()
  local new_wand = wand:new(self:GetProperties())
  local spells, attached_spells = self:GetSpells()
  for k, v in pairs(spells) do
    new_wand:AddSpells{v.action_id}
  end
  for k, v in pairs(attached_spells) do
    new_wand:AttachSpells{v.action_id}
  end
  -- TODO: Make this work if sprite_file is an xml
  SetWandSprite(new_wand.entity_id, new_wand.ability_component, GetWandSprite(self.entity_id, self.ability_component))
  return new_wand
end

-- Applies an appropriate Sprite using the games own algorithm
-- use_new_method = true will update instantly but lag a little
function wand:UpdateSprite(use_old_method)
  local gun = {
    fire_rate_wait = self.castDelay,
    actions_per_round = self.spellsPerCast,
    shuffle_deck_when_empty = self.shuffle,
    deck_capacity = self.capacity,
    spread_degrees = self.spread,
    reload_time = self.rechargeTime,
  }
  local sprite_data = GetWand(gun)
  local fun = SetWandSprite
  if use_old_method then
    fun = SetWandSprite_old
  end
  fun(self.entity_id, self.ability_component,
    sprite_data.file, sprite_data.grip_x, sprite_data.grip_y,
    (sprite_data.tip_x - sprite_data.grip_x),
    (sprite_data.tip_y - sprite_data.grip_y))
end

function wand:PlaceAt(x, y)
	EntitySetComponentIsEnabled(self.entity_id, self.ability_component, true)
	local hotspot_comp = get_component_with_member(self.entity_id, "sprite_hotspot_name")
	EntitySetComponentIsEnabled(self.entity_id, hotspot_comp, true)
  local item_component = get_component_with_member(self.entity_id, "collect_nondefault_actions")
	EntitySetComponentIsEnabled(self.entity_id, item_component, true)
	local sprite_component = get_component_with_member(self.entity_id, "rect_animation")
	EntitySetComponentIsEnabled(self.entity_id, sprite_component, true)
	local light_component = get_component_with_member(self.entity_id, "blinking_freq")
	EntitySetComponentIsEnabled(self.entity_id, light_component, true)
	edit_component(self.entity_id, "ItemComponent", function(comp, vars)
		ComponentSetValue(comp, "has_been_picked_by_player", "0")
		ComponentSetValue(comp, "play_hover_animation", "1")
		ComponentSetValueVector2(comp, "spawn_pos", x, y)
	end)
	local lua_comp = get_component_with_member(self.entity_id, "script_item_picked_up")
	EntitySetComponentIsEnabled(self.entity_id, lua_comp, true)
	edit_component(self.entity_id, "SimplePhysicsComponent", function(comp, vars)
		EntitySetComponentIsEnabled(self.entity_id, comp, false)
	end)
	-- Does this wand have a ray particle effect? Most do, except the starter wands
	local sprite_particle_emitter_comp = get_component_with_member(self.entity_id, "velocity_always_away_from_center")
	if sprite_particle_emitter_comp ~= nil then
		EntitySetComponentIsEnabled(self.entity_id, sprite_particle_emitter_comp, true)
	else
		-- TODO: As soon as there's some way to clone Components or Transplant/Remove+Add to another Entity, copy
		-- the SpriteParticleEmitterComponent of entities/base_wand.xml
  end
end

function wand:PutInPlayersInventory()
  local inventory_id = EntityGetWithName("inventory_quick")
  -- Get number of wands currently already in inventory
  local count = 0
  local inventory_items = EntityGetAllChildren(inventory_id)
  if inventory_items ~= nil then
    for i,v in ipairs(inventory_items) do
      if entity_is_wand(v) then
        count = count + 1
      end
    end
  end
  if count < 4 then
    -- local item_components = EntityGetComponent(rawget(self, "_protected").entity_id, "ItemComponent")
    local item_components = EntityGetComponent(self.entity_id, "ItemComponent")
    if item_components ~= nil and item_components[1] ~= nil then
      ComponentSetValue(item_components[1], "play_hover_animation", "0")
      ComponentSetValue(item_components[1], "has_been_picked_by_player", "1")
    end
    EntityAddChild(inventory_id, self.entity_id)
  else
    error("Cannot add wand to players inventory, it's already full.")
  end
end

return function(from)
  return wand:new(from)
end
