mod_additional_spells = {}
mod_effects = {}

local function apply_mod_effects(material_name, wand)
  for i, func in ipairs(mod_effects[material_name] or {}) do
    func(wand)
  end
end

-- DEPRECATED, use the new method, check files/scripts/modded_content_example.lua!
-- Gets called from files/scripts/mod_interop.lua
function potion_recipe_add_spells(material_name, spells)
  mod_additional_spells[material_name] = mod_additional_spells[material_name] or {}
  for i, spell in ipairs(spells) do
    table.insert(mod_additional_spells[material_name], spell)
  end
end

local function merge_spells(material_name, spells)
  if mod_additional_spells[material_name] then
    for i, action_id in ipairs(mod_additional_spells[material_name]) do
      if not action_exists(action_id) then
        print("Anvil of Destiny WARNING: Spell with ID '" .. action_id .. "' does not exist.")
      else
        table.insert(spells, action_id)
      end
    end
  end
	return spells
end

local bonuses = {
  blood = function(wand)
    local spells = merge_spells("blood", {
      "MIST_BLOOD", "MATERIAL_BLOOD", "TOUCH_BLOOD", "CRITICAL_HIT", "BLOOD_TO_ACID",
      "CLOUD_BLOOD", "HITFX_CRITICAL_BLOOD", "CURSED_ORB", "BLOOD_MAGIC"
    })
    wand.spellsPerCast = wand.spellsPerCast + Random(1, 2)
    wand.rechargeTime = wand.rechargeTime - math.max(Random(1, 2), wand.rechargeTime * Randomf(0.05, 0.1))
    wand.castDelay = wand.castDelay - math.max(Random(1, 2), wand.castDelay * Randomf(0.05, 0.1))
    add_spells_to_wand(wand, spells, math.min(Random(2,4), math.floor(wand.capacity / 2)))
    apply_mod_effects("blood", wand)
  end,
  water = function(wand)
    local spells = merge_spells("water", {
      "CIRCLE_WATER", "MATERIAL_WATER", "TOUCH_WATER", "WATER_TO_POISON", "SEA_WATER",
      "CLOUD_WATER", "HITFX_CRITICAL_WATER", "WATER_TRAIL"
    })
    wand.manaMax = wand.manaMax + Random(40, 100)
    add_spells_to_wand(wand, spells, math.min(Random(2,4), math.floor(wand.capacity / 2)))
    apply_mod_effects("water", wand)
  end,
  urine = function(wand)
    local spells = merge_spells("urine", {})
    -- Make wand piss constantly
    local new_entity = EntityCreateNew()
    EntityAddComponent(new_entity, "InheritTransformComponent", {
      _tags="enabled_in_world,enabled_in_hand",
      parent_hotspot_tag="shoot_pos"
    })
    local emitter = EntityAddComponent2(new_entity, "ParticleEmitterComponent", {
      _tags="enabled_in_hand",
      is_emitting=true,
      emitted_material_name="urine",
      emission_interval_min_frames=1,
      emission_interval_max_frames=1,
      count_min=2,
      count_max=3,
      draw_as_long=true,
      is_trail=false,
      trail_gap=1,
      collide_with_grid=false,
      x_vel_min=70,
      x_vel_max=90,
      y_vel_min=-5,
      y_vel_max=5,
    })
    EntitySetComponentIsEnabled(new_entity, emitter, false)
    EntityAddChild(wand.entity_id, new_entity)
    add_spells_to_wand(wand, spells, math.min(Random(2,4), math.floor(wand.capacity / 2)))
    apply_mod_effects("urine", wand)
  end,
  magic_liquid_teleportation = function(wand)
     local spells = merge_spells("magic_liquid_teleportation", {
      "DELAYED_SPELL", "LONG_DISTANCE_CAST", "TELEPORT_CAST", "TELEPORT_PROJECTILE",
      "TELEPORT_PROJECTILE_STATIC", "TELEPORTATION_FIELD", "SUPER_TELEPORT_CAST"
     })
     wand.manaMax = wand.manaMax + Random(20, 50)
     wand.manaChargeSpeed = wand.manaChargeSpeed + Random(10, 30)
     add_spells_to_wand(wand, spells, math.min(Random(2,4), math.floor(wand.capacity / 2)))
     apply_mod_effects("magic_liquid_teleportation", wand)
  end,
  magic_liquid_unstable_teleportation = function(wand)
    local spells = merge_spells("magic_liquid_teleportation", {
     "DELAYED_SPELL", "LONG_DISTANCE_CAST", "TELEPORT_CAST", "TELEPORT_PROJECTILE",
     "TELEPORT_PROJECTILE_STATIC", "TELEPORTATION_FIELD", "SUPER_TELEPORT_CAST"
    })
    wand.manaMax = wand.manaMax + Random(20, 50)
    wand.manaChargeSpeed = wand.manaChargeSpeed + Random(10, 30)
    wand.spread = wand.spread + Random(5, 10)
    add_spells_to_wand(wand, spells, math.min(Random(2,4), math.floor(wand.capacity / 2)))
    apply_mod_effects("magic_liquid_unstable_teleportation", wand)
 end,
  oil = function(wand)
    local spells = merge_spells("oil", {
      "CIRCLE_OIL", "MATERIAL_OIL", "TOUCH_OIL", "RECOIL_DAMPER", "SEA_OIL",
      "HITFX_CRITICAL_OIL", "OIL_TRAIL"
    })
    wand.rechargeTime = wand.rechargeTime - math.max(Random(1, 2), wand.rechargeTime * 0.15)
    wand.castDelay = wand.castDelay - math.max(Random(1, 2), wand.castDelay * 0.15)
    add_spells_to_wand(wand, spells, math.min(Random(1,3), math.floor(wand.capacity / 2)))
    apply_mod_effects("oil", wand)
  end,
  slime = function(wand)
    local spells = merge_spells("slime", { "MIST_SLIME", "RECOIL_DAMPER", "HITFX_EXPLOSION_SLIME", "HITFX_EXPLOSION_SLIME_GIGA",
      "LIFETIME", "SLIMEBALL", "TENTACLE", "TENTACLE_TIMER", "BOUNCY_ORB_TIMER", "BULLET_TIMER", "HEAVY_BULLET_TIMER",
      "LIGHT_BULLET_TIMER", "SLOW_BULLET_TIMER", "SPITTER_TIER_2_TIMER", "SPITTER_TIER_3_TIMER", "SPITTER_TIMER", "ADD_TIMER",
      "DECELERATING_SHOT"
    })
    wand.spread = wand.spread - Random(7, 15)
    -- Slow down the wand
    wand.rechargeTime = wand.rechargeTime + math.ceil(math.abs(wand.rechargeTime) * Randomf(0.05, 0.10))
    wand.castDelay = wand.castDelay + math.ceil(math.abs(wand.castDelay) * Randomf(0.05, 0.10))
    wand.manaChargeSpeed = math.max(1, wand.manaChargeSpeed - math.ceil(math.abs(wand.manaChargeSpeed) * Randomf(0.05, 0.10)))
    wand.manaMax = wand.manaMax + math.min(Random(150, 200), wand.manaMax * Randomf(0.10, 0.20))
    wand.capacity = wand.capacity + Random(2, 3)
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
    apply_mod_effects("slime", wand)
 end,
 gold = function(wand)
  local spells = merge_spells("gold", { "TOUCH_GOLD", "MONEY_MAGIC" })
  wand.shuffle = false
  wand.castDelay = wand.castDelay - Random(1, 3)
  wand.rechargeTime = wand.rechargeTime - Random(1, 3)
  wand.manaChargeSpeed = wand.manaChargeSpeed + Random(30, 50)
  wand.capacity = math.min(math.max(26, wand.capacity), wand.capacity + Random(2, 5))
  add_spells_to_wand(wand, spells, Random(1, 3), true)
  apply_mod_effects("gold", wand)
end,
 gunpowder_unstable = function(wand)
    local spells = merge_spells("gunpowder_unstable", {
      "BOMB_CART", "DYNAMITE", "BOMB", "GLITTER_BOMB", "BOMB_HOLY", "NUKE", "MINE", "FIRE_BLAST", "EXPLOSION", "BOUNCE_EXPLOSION",
      "ARC_GUNPOWDER", "EXPLOSIVE_PROJECTILE", "UNSTABLE_GUNPOWDER", "GUNPOWDER_TRAIL", "TOUCH_SMOKE", "ALL_NUKES", "ALL_ROCKETS"
    })
    wand.capacity = math.min(26, wand.capacity + Random(2,3))
    add_spells_to_wand(wand, spells, math.min(Random(3,5), math.floor(wand.capacity / 2)))
    apply_mod_effects("gunpowder_unstable", wand)
  end,
  monster_powder_test = function(wand)
    local spells = merge_spells("monster_powder_test", { "SUMMON_WANDGHOST" })
    wand.manaMax = wand.manaMax + Random(450, 550)
    add_spells_to_wand(wand, spells, math.min(Random(3,5), math.floor(wand.capacity / 2)), true)
    apply_mod_effects("monster_powder_test", wand)
  end,
  liquid_fire = function(wand)
    local spells = merge_spells("liquid_fire", {
      "FIREBALL", "METEOR", "FLAMETHROWER",
      "ROCKET", "ROCKET_TIER_2", "ROCKET_TIER_3", "GRENADE", "GRENADE_TRIGGER",
      "GRENADE_TIER_2", "GRENADE_TIER_3", "GRENADE_ANTI", "GRENADE_LARGE",
      "FIREBOMB", "CIRCLE_FIRE", "FIRE_BLAST", "HITFX_BURNING_CRITICAL_HIT",
      "FIREBALL_RAY", "FIREBALL_RAY_LINE", "FIREBALL_RAY_ENEMY", "ARC_FIRE", "FIRE_TRAIL", "BURN_TRAIL"
    })
    wand.rechargeTime = wand.rechargeTime - math.ceil(math.abs(wand.rechargeTime) * Randomf(0.05, 0.10))
    wand.castDelay = wand.castDelay - math.ceil(math.abs(wand.castDelay) * Randomf(0.05, 0.10))
    add_spells_to_wand(wand, spells, math.min(Random(4, 6), math.floor(wand.capacity / 2)))
    apply_mod_effects("liquid_fire", wand)
  end,
  magic_liquid_berserk = function(wand)
    local spells = merge_spells("magic_liquid_berserk", {
      "ROCKET", "ROCKET_TIER_2", "ROCKET_TIER_3", "BOMB", "GRENADE", "GRENADE_TRIGGER",
      "GRENADE_TIER_2", "GRENADE_TIER_3", "GRENADE_ANTI", "GRENADE_LARGE", "MINE",
      "MINE_DEATH_TRIGGER", "PIPE_BOMB", "PIPE_BOMB_DEATH_TRIGGER", "EXPLODING_DEER",
      "DIGGER", "POWERDIGGER", "METEOR", "DYNAMITE", "GLITTER_BOMB",
      "BOMB_HOLY", "NUKE", "DAMAGE", "HEAVY_SHOT", "EXPLOSIVE_PROJECTILE", "EXPLOSION",
      "BERSERK_FIELD", "BOUNCE_EXPLOSION", "ALL_NUKES"
    })
    wand.manaMax = wand.manaMax + Random(40, 90)
    add_spells_to_wand(wand, spells, math.floor(wand.capacity / 2))
    apply_mod_effects("magic_liquid_berserk", wand)
  end,
  magic_liquid_mana_regeneration = function(wand)
    local spells = merge_spells("magic_liquid_mana_regeneration", { "MANA_REDUCE" })
    if wand.manaChargeSpeed < 30 then
      wand.manaChargeSpeed = wand.manaChargeSpeed + Random(40, 60)
    else
      wand.manaChargeSpeed = wand.manaChargeSpeed + Random(80, 120)
    end
    add_spells_to_wand(wand, spells, Random(0, 1))
    apply_mod_effects("magic_liquid_mana_regeneration", wand)
  end,
  magic_liquid_movement_faster = function(wand)
    local spells = merge_spells("magic_liquid_movement_faster", {
      "RECHARGE", "LIFETIME", "LIFETIME_DOWN", "LIGHT_SHOT", "KNOCKBACK", "RECOIL",
      "SPEED", "ACCELERATING_SHOT"
    })
    wand.rechargeTime = wand.rechargeTime - math.max(Random(1, 2), wand.rechargeTime * Randomf(0.08, 0.1))
    wand.castDelay = wand.castDelay - math.max(Random(1, 2), wand.castDelay * Randomf(0.08, 0.1))
    add_spells_to_wand(wand, spells, math.min(Random(2, 3), math.floor(wand.capacity / 2)))
    apply_mod_effects("magic_liquid_movement_faster", wand)
  end,
  magic_liquid_faster_levitation = function(wand)
    local spells = merge_spells("magic_liquid_faster_levitation", {
      "RECHARGE", "LIFETIME", "LIFETIME_DOWN", "LIGHT_SHOT", "KNOCKBACK", "RECOIL",
      "SPEED", "ACCELERATING_SHOT"
    })
    wand.rechargeTime = wand.rechargeTime - math.max(Random(1, 2), wand.rechargeTime * Randomf(0.08, 0.1))
    wand.castDelay = wand.castDelay - math.max(Random(1, 2), wand.castDelay * Randomf(0.08, 0.1))
    add_spells_to_wand(wand, spells, math.min(Random(2, 4), math.floor(wand.capacity / 2)))
    apply_mod_effects("magic_liquid_faster_levitation", wand)
  end,
  magic_liquid_faster_levitation_and_movement = function(wand)
    local spells = merge_spells("magic_liquid_faster_levitation_and_movement", {
      "RECHARGE", "LIFETIME", "LIFETIME_DOWN", "LIGHT_SHOT", "KNOCKBACK", "RECOIL",
      "SPEED", "ACCELERATING_SHOT"
    })
    wand.rechargeTime = wand.rechargeTime - math.max(Random(2, 4), wand.rechargeTime * Randomf(0.16, 0.2))
    wand.castDelay = wand.castDelay - math.max(Random(2, 4), wand.castDelay * Randomf(0.16, 0.2))
    add_spells_to_wand(wand, spells, math.min(Random(4, 8), math.floor(wand.capacity / 2)))
    apply_mod_effects("magic_liquid_faster_levitation_and_movement", wand)
  end,
  material_confusion = function(wand)
    local spells = merge_spells("material_confusion", {
      "CHAOTIC_ARC", "HEAVY_SPREAD", "DAMAGE_RANDOM", "RANDOM_EXPLOSION", "FIZZLE", "RANDOM_SPELL",
      "RANDOM_PROJECTILE", "RANDOM_MODIFIER", "RANDOM_STATIC_PROJECTILE", "DRAW_RANDOM", "DRAW_RANDOM_X3", "DRAW_3_RANDOM"
    })
    wand.shuffle = (Random() > 0.5) and true or false
    wand.spellsPerCast = math.max(1, wand.spellsPerCast + Random(0, 3) * (Random() > 0.5 and -1 or 1))
    wand.castDelay = wand.castDelay - math.max(Random(0, 4), wand.castDelay * Randomf(0, 0.2)) * (Random() > 0.5 and -1 or 1)
    wand.rechargeTime = wand.rechargeTime - math.max(Random(0, 4), wand.rechargeTime * Randomf(0, 0.2)) * (Random() > 0.5 and -1 or 1)
    wand.manaMax = math.max(50, wand.manaMax + Random(20, 40) * (Random() > 0.5 and -1 or 1))
    wand.manaChargeSpeed = math.max(10, wand.manaChargeSpeed + Random(10, 50) * (Random() > 0.5 and -1 or 1))
    wand.capacity = wand.capacity + math.max(1, wand.capacity + Random(1, 3) * (Random() > 0.5 and -1 or 1))
    wand.spread = wand.spread - Random(wand.spread * 0.1, wand.spread * 0.3) * (Random() > 0.5 and -1 or 1)
    add_spells_to_wand(wand, spells, math.min(Random(2, 3), math.floor(wand.capacity / 2)))
    apply_mod_effects("material_confusion", wand)
  end,
  magic_liquid_protection_all = function(wand)
    local spells = merge_spells("magic_liquid_protection_all", {
      "WALL_HORIZONTAL", "WALL_VERTICAL", "WALL_SQUARE", "SHIELD_FIELD",
      "PROJECTILE_TRANSMUTATION_FIELD", "ENERGY_SHIELD", "ENERGY_SHIELD_SECTOR", "MAGIC_SHIELD", "BIG_MAGIC_SHIELD"
    })
    wand.spellsPerCast = wand.spellsPerCast + Random(1, 3)
    wand.manaMax = wand.manaMax + Random(80, 140)
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
    apply_mod_effects("magic_liquid_protection_all", wand)
  end,
  magic_liquid_hp_regeneration = function(wand)
    local spells = merge_spells("magic_liquid_hp_regeneration", { "HEAL_BULLET", "REGENERATION_FIELD" })
    -- on pickup, spawn 4 hiisi healers
    EntityAddComponent(wand.entity_id, "VariableStorageComponent", {
      name="material",
      value_string="magic_liquid_hp_regeneration",
    })
    EntityAddComponent(wand.entity_id, "LuaComponent", {
      script_item_picked_up="mods/anvil_of_destiny/files/entities/anvil/wand_pickup_custom_effect.lua",
      execute_every_n_frame="-1",
      remove_after_executed="1"
    })
    wand.manaChargeSpeed = wand.manaChargeSpeed + Random(50, 70)
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)), true)
    apply_mod_effects("magic_liquid_hp_regeneration", wand)
  end,
  magic_liquid_polymorph = function(wand)
    -- transform all spells in wand into random ones
    local spells = merge_spells("magic_liquid_polymorph", {
      "SUMMON_EGG", "SUMMON_HOLLOW_EGG", "SUMMON_WANDGHOST", "STATIC_TO_SAND",
      "TRANSMUTATION", "POLYMORPH_FIELD", "PROJECTILE_TRANSMUTATION_FIELD",
      "TENTACLE_RAY_ENEMY"
    })
    wand.spellsPerCast = wand.spellsPerCast + Random(1, 2)
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
    apply_mod_effects("magic_liquid_polymorph", wand)
  end,
  magic_liquid_random_polymorph = function(wand)
    -- transform all spells in wand into random ones?
    local spells = merge_spells("magic_liquid_random_polymorph", {
      "TENTACLE_PORTAL", "TENTACLE", "TENTACLE_TIMER", "SUMMON_EGG", "STATIC_TO_SAND",
      "TRANSMUTATION", "CHAOS_POLYMORPH_FIELD", "PROJECTILE_TRANSMUTATION_FIELD",
      "TENTACLE_RAY", "TENTACLE_RAY_ENEMY", "RANDOM_EXPLOSION"
    })
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
    apply_mod_effects("magic_liquid_random_polymorph", wand)
  end,
  magic_liquid_unstable_polymorph = function(wand)
    local spells = merge_spells("magic_liquid_unstable_polymorph", {
      "TENTACLE_PORTAL", "TENTACLE", "TENTACLE_TIMER", "SUMMON_EGG", "STATIC_TO_SAND",
      "TRANSMUTATION", "CHAOS_POLYMORPH_FIELD", "PROJECTILE_TRANSMUTATION_FIELD",
      "TENTACLE_RAY", "TENTACLE_RAY_ENEMY", "RANDOM_EXPLOSION"
    })
    wand.spellsPerCast = wand.spellsPerCast + Random(2, 3)
    wand.spread = wand.spread + Random(5, 10)
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
    apply_mod_effects("magic_liquid_unstable_polymorph", wand)
  end,
  magic_liquid_charm = function(wand)
    -- charm spells, charm on slime etc
    local spells = merge_spells("magic_liquid_charm", {
      "SUMMON_EGG", "SUMMON_HOLLOW_EGG", "SUMMON_WANDGHOST", "HOMING", "HOMING_SHOOTER",
      "NECROMANCY", "TENTACLE_RAY_ENEMY", "HITFX_TOXIC_CHARM", "SWARM_FLY", "SWARM_FIREBUG", "SWARM_WASP",
      "FRIEND_FLY"
    })
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
    apply_mod_effects("magic_liquid_charm", wand)
  end,
  magic_liquid_invisibility = function(wand)
    -- Turn player invisible for some time on pickup (not working right now)
    -- EntityAddComponent(wand.entity_id, "VariableStorageComponent", {
    --  name="material",
    --  value_string="magic_liquid_invisibility",
    -- })
    -- EntityAddComponent(wand.entity_id, "LuaComponent", {
    --  script_item_picked_up="mods/anvil_of_destiny/files/entities/anvil/wand_pickup_custom_effect.lua",
    --  execute_every_n_frame="-1",
    --  remove_after_executed="1"
    -- })
    local spells = merge_spells("magic_liquid_invisibility", {
      "BLACK_HOLE", "ALL_BLACKHOLES", "EXPLODING_DEER", "LANCE", "X_RAY", "LIGHT", "GLOWING_BOLT"
    })
    wand.manaMax = wand.manaMax + Random(30, 40)
    wand.manaChargeSpeed = wand.manaChargeSpeed + Random(10, 30)
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
    apply_mod_effects("magic_liquid_invisibility", wand)
  end,
  magic_liquid_worm_attractor = function(wand)
    local spells = merge_spells("magic_liquid_worm_attractor", { "SUMMON_EGG", "SUMMON_HOLLOW_EGG", "HOMING", "HOMING_SHOOTER" })
    -- While wand is held spawn worms randomly and apply worm attractor game effect to the player
    local comp = EntityAddComponent(wand.entity_id, "LuaComponent", {
      _tags="enabled_in_hand",
      script_source_file="mods/anvil_of_destiny/files/scripts/worm_spawner_and_attractor.lua",
      execute_every_n_frame="60",
      execute_on_added="0",
    })
    EntitySetComponentIsEnabled(wand.entity_id, comp, false)
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
    apply_mod_effects("magic_liquid_worm_attractor", wand)
  end,
  alcohol = function(wand)
    local spells = merge_spells("alcohol", {
      "BUCKSHOT", "MIST_ALCOHOL", "TOUCH_ALCOHOL", "SCATTER_3", "SCATTER_4", "I_SHAPE",
      "Y_SHAPE", "T_SHAPE", "W_SHAPE", "CIRCLE_SHAPE", "PENTAGRAM_SHAPE", "HEAVY_SPREAD",
      "GRAVITY", "GRAVITY_ANTI", "SINEWAVE", "CHAOTIC_ARC", "PINGPONG_PATH",
      "ALCOHOL_BLAST", "SEA_ALCOHOL", "HITFX_EXPLOSION_ALCOHOL",
      "HITFX_EXPLOSION_ALCOHOL_GIGA", "FIZZLE"
    })
    wand.spread = wand.spread + Random(20, 30)
    wand.manaMax = wand.manaMax + Random(200, 300)
    wand.manaChargeSpeed = math.max(10, wand.manaChargeSpeed - Random(20, 40))
    add_spells_to_wand(wand, spells, math.min(Random(5, 10), math.floor(wand.capacity / 2)))
    apply_mod_effects("alcohol", wand)
  end,
  blood_worm = function(wand)
  local spells = merge_spells("blood_worm", {
      "CLIPPING_SHOT", "X_RAY", "MATTER_EATER", "LUMINOUS_DRILL", "LASER_LUMINOUS_DRILL",
      "LANCE", "DIGGER", "POWERDIGGER", "BLACK_HOLE", "ALL_BLACKHOLES"
      })
    add_spells_to_wand(wand, spells, math.min(Random(2, 5), math.floor(wand.capacity / 2)))
    apply_mod_effects("blood_worm", wand)
  end,
  porridge = function(wand)
    local spells = merge_spells("porridge", { "HEAL_BULLET", "REGENERATION_FIELD" })
    add_spells_to_wand(wand, spells, Random(3, 5), true)
    apply_mod_effects("porridge", wand)
  end,
  radioactive_liquid = function(wand)
    local spells = merge_spells("radioactive_liquid", { "MIST_RADIOACTIVE", "AREA_DAMAGE", "HITFX_TOXIC_CHARM" })
    wand.manaMax = wand.manaMax + Random(20, 40)
    wand.manaChargeSpeed = wand.manaChargeSpeed + Random(20, 40)
    wand.capacity = math.min(26, wand.capacity + Random(1, 2))
    add_spells_to_wand(wand, spells, math.min(Random(2, 5), math.floor(wand.capacity / 2)))
    apply_mod_effects("radioactive_liquid", wand)
  end,
  acid = function(wand)
    local spells = merge_spells("acid", {
      "ACIDSHOT", "CIRCLE_ACID", "MATERIAL_ACID", "CLIPPING_SHOT", "PIERCING_SHOT",
      "TOXIC_TO_ACID", "SEA_ACID", "SEA_ACID_GAS", "CLOUD_ACID", "ACID_TRAIL", "ALL_ACID"
    })
    wand.spellsPerCast = wand.spellsPerCast + Random(1, 2)
    add_spells_to_wand(wand, spells, math.min(Random(4, 6), math.floor(wand.capacity / 2)))
    apply_mod_effects("acid", wand)
  end,
  lava = function(wand)
    local spells = merge_spells("lava", {
      "FIREBALL", "METEOR", "FLAMETHROWER",
      "ROCKET", "ROCKET_TIER_2", "ROCKET_TIER_3", "GRENADE", "GRENADE_TRIGGER",
      "GRENADE_TIER_2", "GRENADE_TIER_3", "GRENADE_ANTI", "GRENADE_LARGE",
      "FIREBOMB", "CIRCLE_FIRE", "LAVA_TO_BLOOD", "FIRE_BLAST", "SEA_LAVA",
      "HITFX_BURNING_CRITICAL_HIT", "FIREBALL_RAY", "FIREBALL_RAY_LINE",
      "FIREBALL_RAY_ENEMY", "ARC_FIRE", "FIRE_TRAIL", "BURN_TRAIL"
    })
    add_spells_to_wand(wand, spells, math.min(Random(4, 6), math.floor(wand.capacity / 2)))
    apply_mod_effects("lava", wand)
  end,
  midas_precursor = function(wand)
    local spells = merge_spells("midas_precursor", {
      "LIGHT_BULLET_TRIGGER", "LIGHT_BULLET_TRIGGER_2", "BULLET_TRIGGER", "HEAVY_BULLET_TRIGGER",
      "SLOW_BULLET_TRIGGER", "BUBBLESHOT_TRIGGER", "GRENADE_TRIGGER", "MINE_DEATH_TRIGGER", "PIPE_BOMB_DEATH_TRIGGER",
      "TRANSMUTATION", "ADD_TRIGGER", "ADD_DEATH_TRIGGER"
    })
    wand.manaChargeSpeed = wand.manaChargeSpeed + Random(20, 40)
    wand.manaMax = math.floor(wand.manaMax * Randomf(1.01, 1.05))
    add_spells_to_wand(wand, spells, math.min(Random(5, 7), math.floor(wand.capacity * 0.5)))
    apply_mod_effects("midas_precursor", wand)
  end,
  midas = function(wand)
    local spells = merge_spells("midas", { "TOUCH_GOLD", "ALL_SPELLS" })
    wand.manaChargeSpeed = wand.manaChargeSpeed + Random(20, 40)
    wand.manaMax = math.floor(wand.manaMax * Randomf(1.05, 1.10))
    wand.capacity = math.min(26, wand.capacity + Random(1, 2))
    add_spells_to_wand(wand, spells, math.min(Random(4, 8), math.floor(wand.capacity * 0.5)))
    apply_mod_effects("midas", wand)
  end,
  -- freezing liquid
  blood_cold = function(wand)
    local spells = merge_spells("blood_cold", { "PROPANE_TANK", "FREEZE_FIELD", "FREEZE", "FREEZING_GAZE" })
    add_spells_to_wand(wand, spells, math.min(Random(4, 6), math.floor(wand.capacity * 0.5)))
    apply_mod_effects("blood_cold", wand)
  end,
  vomit = function(wand)
    local spells = merge_spells("vomit", {})
    wand.manaChargeSpeed = math.max(1, wand.manaChargeSpeed * Randomf(0.4, 0.6))
    wand.castDelay = Random(-40, -30)
    wand.rechargeTime = Random(260, 340)
    wand.spread = Randomf(50, 70)
    wand.capacity = math.min(26, wand.capacity + Random(2, 3))
    add_spells_to_wand(wand, spells, math.min(Random(4, 6), math.floor(wand.capacity * 0.5)))
    apply_mod_effects("vomit", wand)
  end,

  -- Optional Arcane Alchemy mod compatibility: https://steamcommunity.com/sharedfiles/filedetails/?id=2074171525
  AA_MAT_DARKMATTER = function(wand)
    local spells = merge_spells("AA_MAT_DARKMATTER", { "BLACK_HOLE", "BLACK_HOLE_BIG", "AREA_DAMAGE", "ALL_BLACKHOLES" })
    wand.manaMax = wand.manaMax + Random(20, 40)
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
    apply_mod_effects("AA_MAT_DARKMATTER", wand)
  end,
  AA_MAT_HITSELF = function(wand)
    local spells = merge_spells("AA_MAT_HITSELF", {
      "TENTACLE_RAY", "TENTACLE_RAY_ENEMY", "FIREBALL_RAY", "FIREBALL_RAY_ENEMY", "PIERCING_SHOT", "HOMING_SHOOTER",
      "TENTACLE_PORTAL", "ALL_DISCS", "DISC_BULLET_BIG"
    })
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
    apply_mod_effects("AA_MAT_HITSELF", wand)
  end,
  AA_MAT_ARBORIUM = function(wand)
    local spells = merge_spells("AA_MAT_ARBORIUM", {
      -- Wood related spells, branching, woodcutting
      "CHAINSAW", "ARROW", "DISC_BULLET", "DISC_BULLET_BIG", "TORCH", "SCATTER_2", "SCATTER_3", "SCATTER_4", "Y_SHAPE", "W_SHAPE",
      -- and fire because wood can burn
      "FIREBALL", "METEOR", "FLAMETHROWER", "FIREBOMB", "CIRCLE_FIRE", "FIRE_BLAST", "ARC_FIRE", "FIRE_TRAIL", "BURN_TRAIL"
    })
    wand.manaMax = wand.manaMax + Random(20, 40)
    wand.manaChargeSpeed = wand.manaChargeSpeed + Random(10, 30)
    wand.capacity = math.min(26, wand.capacity + Random(0, 2))
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
    apply_mod_effects("AA_MAT_ARBORIUM", wand)
  end,
  AA_MAT_HUNGRY_SLIME = function(wand)
    local spells = merge_spells("AA_MAT_HUNGRY_SLIME", { "MATTER_EATER", "BUBBLESHOT_TRIGGER", "BULLET_TRIGGER", "LIGHT_BULLET_TRIGGER",
      "HEAVY_BULLET_TRIGGER", "SLOW_BULLET_TRIGGER", "LARPA_UPWARDS", "LARPA_DOWNWARDS", "LARPA_CHAOS", "LARPA_CHAOS_2", "DUPLICATE" })
    wand.speedMultiplier = wand.speedMultiplier * Randomf(0.7, 0.9)
    add_spells_to_wand(wand, spells, math.min(Random(2, 4), math.floor(wand.capacity / 2)))
    apply_mod_effects("AA_MAT_HUNGRY_SLIME", wand)
  end,
  AA_MAT_REPULTIUM = function(wand)
    local spells = merge_spells("AA_MAT_REPULTIUM", {
      "LIGHT_SHOT", "ACCELERATING_SHOT", "SPEED", "KNOCKBACK", "RECOIL", "AVOIDING_ARC", "FLY_DOWNWARDS", "FLY_UPWARDS", "PINGPONG_PATH", "BOUNCE",
      "ENERGY_SHIELD", "ENERGY_SHIELD_SECTOR", "SHIELD_FIELD", "RUBBER_BALL"
    })
    wand.speedMultiplier = wand.speedMultiplier + Randomf(0.3, 0.6)
    wand.spread = wand.spread + Random(10, 20)
    add_spells_to_wand(wand, spells, math.min(Random(4, 7), math.floor(wand.capacity / 2)))
    apply_mod_effects("AA_MAT_REPULTIUM", wand)
  end,
  AA_MAT_STATIC_CHARGE = function(wand)
    local spells = merge_spells("AA_MAT_STATIC_CHARGE", {
      "LIGHTNING_RAY", "LIGHTNING_RAY_ENEMY", "ELECTRIC_CHARGE", "ARC_ELECTRIC", "TORCH_ELECTRIC", "PROJECTILE_THUNDER_FIELD", "CLOUD_THUNDER",
      "ELECTROCUTION_FIELD", "THUNDER_BLAST", "THUNDERBALL", "LIGHTNING"
    })
    wand.manaMax = wand.manaMax + Random(50, 100)
    wand.manaChargeSpeed = wand.manaChargeSpeed + Random(10, 20)
    wand.spread = wand.spread + Random(5, 10)
    add_spells_to_wand(wand, spells, math.min(Random(4, 7), math.floor(wand.capacity / 2)))
    apply_mod_effects("AA_MAT_STATIC_CHARGE", wand)
  end,
  AA_MAT_SHRINKIUM = function(wand)
    -- Shrink the wand sprite and hotspots, reduce capacity, increase firing rate and recharge speed
    local sprite_component = EntityGetFirstComponentIncludingDisabled(wand.entity_id, "SpriteComponent")
    ComponentSetValue2(sprite_component, "has_special_scale", true)
    ComponentSetValue2(sprite_component, "special_scale_x", 0.5)
    ComponentSetValue2(sprite_component, "special_scale_y", 0.5)
    local var_stores = EntityGetComponent(wand.entity_id, "VariableStorageComponent") or {}
    local var_store_offset
    for i, var_store in ipairs(var_stores) do
      if ComponentGetValue2(var_store, "name") == "aod_offset_changed" then
        var_store_offset = var_store
        break
      end
    end
    local hotspot_component = EntityGetFirstComponentIncludingDisabled(wand.entity_id, "HotspotComponent", "shoot_pos")
    local offset_x, offset_y = ComponentGetValue2(hotspot_component, "offset")
    if not var_store_offset then
      ComponentSetValue2(hotspot_component, "offset", math.floor(offset_x * 0.5), math.floor(offset_y * 0.5))
      EntityAddComponent2(wand.entity_id, "VariableStorageComponent", { name = "aod_offset_changed" })
    end
    -- Reduce capacity
    -- TODO: When EZWand supports safe capacity reducing (removing spells that don't fit anymore), use that instead
    local spells = wand:GetSpells()
    local spells_count = #spells
    wand:RemoveSpells()
    wand.capacity = math.max(1, math.floor(wand.capacity * 0.7) - 1)
    for i=1,math.min(wand.capacity, spells_count) do
      wand:AddSpells(spells[i].action_id)
    end
    wand.castDelay = math.ceil(wand.castDelay * 0.5)
    wand.rechargeTime = math.ceil(wand.rechargeTime * 0.5)
    wand.manaMax = wand.manaMax * 0.5
    wand.manaChargeSpeed = wand.manaChargeSpeed * 0.8
    apply_mod_effects("AA_MAT_SHRINKIUM", wand)
  end,
  -- /Arcane Alchemy
  -- Pickup items, yeah they're not potions, SO WHAT?! Put them in here anyways because I'm too lazy to refactor "Potions" to a new name
  runestone_disc = function(wand)
    local spells = { "DISC_BULLET", "DISC_BULLET_BIG", "DISC_BULLET_BIGGER" }
    wand.capacity = math.min(26, wand.capacity + Random(1, 2))
    add_spells_to_wand(wand, spells, Random(4, 6))
    apply_mod_effects("runestone_disc", wand)
  end,
  runestone_slow = function(wand)
    wand:AttachSpells("DECELERATING_SHOT")
    apply_mod_effects("runestone_slow", wand)
  end,
  runestone_laser = function(wand)
    local spells = { "LASER" }
    wand.spread = math.floor(wand.spread - math.abs(wand.spread * 0.2))
    add_spells_to_wand(wand, spells, Random(4, 6))
    apply_mod_effects("runestone_laser", wand)
  end,
  runestone_fireball = function(wand)
    local spells = { "FIREBALL" }
    add_spells_to_wand(wand, spells, Random(4, 6))
    apply_mod_effects("runestone_fireball", wand)
  end,
  runestone_null = function(wand)
    -- Increase capacity based on #spells on wand, up to a maximum of 16
    wand.spellsPerCast = 1
    -- Remove all spells from the wand and scatter them
    local spells = wand:GetSpells()
    local x, y = EntityGetTransform(wand.entity_id)
    for i, spell in ipairs(spells) do
      local item_entity = CreateItemActionEntity(spell.action_id, x, y - 3)
      local velocity_component = EntityGetFirstComponentIncludingDisabled(item_entity, "VelocityComponent")
      ComponentSetValue2(velocity_component, "mVelocity", Random(-80, 80), Random(-160, -200))
    end
    wand:RemoveSpells()
    wand.capacity = math.max(wand.capacity, math.min(16, wand.capacity + #spells))
    apply_mod_effects("runestone_null", wand)
  end,
  chest_random = function(wand)
    wand.capacity = math.max(wand.capacity, math.min(16, wand.capacity + Random(5, 7)))
    local spells = wand:GetSpells()
    local free_space = wand.capacity - #spells
    for i=1,math.min(free_space, 10) do
      local action = GetRandomAction(Random(1, 100), Random(1, 100), 4, i)
      wand:AddSpells(action)
    end
    apply_mod_effects("chest_random", wand)
  end,
  chest_random_super = function(wand)
    wand.shuffle = false
    wand.capacity = math.min(26, wand.capacity + Random(6, 8))
    local spells = wand:GetSpells()
    local free_space = wand.capacity - #spells
    for i=1,math.min(free_space, 16) do
      local action = GetRandomAction(Random(1, 100), Random(1, 100), 6, i)
      wand:AddSpells(action)
    end
    apply_mod_effects("chest_random_super", wand)
  end,
  gourd = function(wand)
    local spells = merge_spells("gourd", { "HEAL_BULLET" })
    add_spells_to_wand(wand, spells, Random(4, 6), true)
    apply_mod_effects("gourd", wand)
  end,
  moon = function(wand)
    local spells = merge_spells("moon", { "BLACK_HOLE_BIG", "EXPANDING_ORB", "GRAVITY", "GRAVITY_ANTI",
      "ORBIT_SHOT", "SPIRALING_SHOT", "HOMING", "HOMING_SHORT", "HOMING_SHOOTER",
      "HOMING_ACCELERATING", "HOMING_CURSOR", "LEVITATION_FIELD", "PROJECTILE_GRAVITY_FIELD", "GRAVITY_FIELD_ENEMY"
    })
    add_spells_to_wand(wand, spells, Random(3, 5))
    apply_mod_effects("moon", wand)
  end,
  physics_die = function(wand)
    local spells = merge_spells("physics_die", {})
    local function random_with_dropoff(scale, dropoff)
      local x = Randomf()
      return math.pow(math.exp(1), -dropoff*x) * scale
    end
    wand.shuffle = Random(0, 1) == 1
    wand.spellsPerCast = math.ceil(random_with_dropoff(10, 4))
    wand.castDelay = random_with_dropoff(120, 3) - 5
    wand.rechargeTime = random_with_dropoff(120, 2.5) - 5
    wand.manaMax = 1500 - random_with_dropoff(1500, 1)
    wand.manaChargeSpeed = 500 - random_with_dropoff(500, 2)
    wand.capacity = math.ceil(random_with_dropoff(26, 2.5))
    wand.spread = -15 + math.floor(random_with_dropoff(45, 3))
    add_spells_to_wand(wand, spells, Random(3, 5))
    apply_mod_effects("physics_die", wand)
  end,
  safe_haven = function(wand)
    local spells = merge_spells("safe_haven", { "HEAL_BULLET" })
    wand.shuffle = false
    wand.capacity = math.min(26, wand.capacity + Random(4, 6))
    add_spells_to_wand(wand, spells, Random(4, 6), true)
    apply_mod_effects("safe_haven", wand)
  end,
  thunderstone = function(wand)
    wand.capacity = math.min(26, wand.capacity + Random(1, 3))
    wand.spread = wand.spread + Random(3, 7)
    wand:AttachSpells("ELECTRIC_CHARGE")
    apply_mod_effects("thunderstone", wand)
  end,
  egg = function(wand)
    local spells = merge_spells("egg", { "SUMMON_EGG" })
    add_spells_to_wand(wand, spells, Random(4, 6), true)
    apply_mod_effects("egg", wand)
  end,
  wandstone = function(wand)
    local spells = merge_spells("wandstone", { "LIGHT_BULLET_TRIGGER", "LIGHT_BULLET_TRIGGER_2",
      "LASER_LUMINOUS_DRILL", "LONG_DISTANCE_CAST", "TELEPORT_CAST", "SUPER_TELEPORT_CAST", "BURST_2",
      "BURST_3", "BURST_4", "BURST_8", "CIRCLE_SHAPE", "PENTAGRAM_SHAPE", "RECHARGE", "LIFETIME", "LIFETIME_DOWN",
      "NOLLA", "MANA_REDUCE", "BLOOD_MAGIC", "MONEY_MAGIC", "BLOOD_TO_POWER", "DUPLICATE", "HOMING", "HOMING_ROTATE",
      "HOMING_SHOOTER", "PIERCING_SHOT", "BLOODLUST", "DAMAGE_FOREVER", "SPELLS_TO_POWER", "ESSENCE_TO_POWER",
      "HEAVY_SHOT", "STATIC_TO_SAND", "DRAW_RANDOM", "DRAW_RANDOM_X3", "DRAW_3_RANDOM", "ADD_TRIGGER", "ADD_TIMER",
      "ADD_DEATH_TRIGGER", "LARPA_CHAOS", "LARPA_DOWNWARDS", "LARPA_UPWARDS", "LARPA_CHAOS_2", "LARPA_DEATH",
      "ALPHA", "GAMMA", "TAU", "OMEGA", "MU", "PHI", "SIGMA", "ZETA", "DIVIDE_2", "DIVIDE_3", "DIVIDE_4", "DIVIDE_10",
      "RESET", "IF_ENEMY", "IF_PROJECTILE", "IF_HP", "IF_HALF", "IF_END", "IF_ELSE"
    })
    -- Adds all kinds of helpful spells for building strong late game wands
    wand.capacity = math.min(math.max(26, wand.capacity), wand.capacity + Random(4, 6))
    add_spells_to_wand(wand, spells, Random(6, 10))
    apply_mod_effects("wandstone", wand)
  end,
  sunseed = function(wand)
    local spells = merge_spells("sunseed", { "FIREBALL", "METEOR", "FLAMETHROWER", "BOMB_HOLY", "BOMB_HOLY_GIGA",
      "EXPANDING_ORB", "FIREBOMB", "CIRCLE_FIRE", "NUKE", "NUKE_GIGA", "EXPLOSIVE_PROJECTILE", "EXPLOSION", "EXPLOSION_LIGHT",
      "FIRE_BLAST", "SEA_LAVA", "HITFX_BURNING_CRITICAL_HIT", "FIREBALL_RAY", "FIREBALL_RAY_LINE", "FIREBALL_RAY_ENEMY",
      "ORBIT_FIREBALLS", "ORBIT_NUKES", "UNSTABLE_GUNPOWDER","FIRE_TRAIL","BURN_TRAIL","METEOR_RAIN",
    })
    wand.manaMax = wand.manaMax + Random(150, 300)
    wand.manaChargeSpeed = wand.manaChargeSpeed + Random(40, 60)
    wand.capacity = math.min(math.max(26, wand.capacity), wand.capacity + Random(3, 5))
    add_spells_to_wand(wand, spells, Random(4, 6))
    apply_mod_effects("sunseed", wand)
  end,
  sunstone = function(wand)
    local spells = merge_spells("sunstone", { "FIREBALL", "METEOR", "FLAMETHROWER", "BOMB_HOLY", "BOMB_HOLY_GIGA",
      "EXPANDING_ORB", "FIREBOMB", "CIRCLE_FIRE", "NUKE", "NUKE_GIGA", "EXPLOSIVE_PROJECTILE", "EXPLOSION", "EXPLOSION_LIGHT",
      "FIRE_BLAST", "SEA_LAVA", "HITFX_BURNING_CRITICAL_HIT", "FIREBALL_RAY", "FIREBALL_RAY_LINE", "FIREBALL_RAY_ENEMY",
      "ORBIT_FIREBALLS", "ORBIT_NUKES", "UNSTABLE_GUNPOWDER","FIRE_TRAIL","BURN_TRAIL","METEOR_RAIN",
    })
    wand.manaMax = wand.manaMax + Random(200, 400)
    wand.manaChargeSpeed = wand.manaChargeSpeed + Random(60, 80)
    wand.capacity = math.min(math.max(26, wand.capacity), wand.capacity + Random(4, 6))
    add_spells_to_wand(wand, spells, Random(4, 6))
    apply_mod_effects("sunstone", wand)
  end,
  beamstone = function(wand)
    local spells = merge_spells("beamstone", { "LASER_EMITTER", "LASER_EMITTER_FOUR", "LASER_EMITTER_CUTTER", "LUMINOUS_DRILL",
      "LASER_LUMINOUS_DRILL", "DEATH_CROSS_BIG", "WALL_HORIZONTAL", "WALL_VERTICAL", "WALL_SQUARE", "LASER_EMITTER_WIDER",
    })
    wand.rechargeTime = math.max(0, wand.rechargeTime - Random(3, 5))
    wand.castDelay = math.max(0, wand.castDelay - Random(3, 5))
    add_spells_to_wand(wand, { "LASER_EMITTER_WIDER" }, Random(1, 3), true)
    add_spells_to_wand(wand, spells, Random(3, 5))
    apply_mod_effects("beamstone", wand)
  end,
  evil_eye = function(wand)
    local spells = merge_spells("evil_eye", { "CURSED_ORB", "SPREAD_REDUCE", "BLOOD_MAGIC", "MATTER_EATER",
      "CURSE", "CURSE_WITHER_PROJECTILE", "CURSE_WITHER_EXPLOSION", "CURSE_WITHER_MELEE",
      "CURSE_WITHER_ELECTRICITY", "X_RAY"
    })
    wand.spread = wand.spread - Random(8, 15)
    add_spells_to_wand(wand, spells, Random(3, 5))
    apply_mod_effects("evil_eye", wand)
  end,
  musicstone = function(wand)
    local spells = {
      ocarina = { "OCARINA_A", "OCARINA_B", "OCARINA_C", "OCARINA_D", "OCARINA_E",
        "OCARINA_F", "OCARINA_GSHARP", "OCARINA_A2"
      },
      kantele = { "KANTELE_A", "KANTELE_D", "KANTELE_DIS", "KANTELE_E", "KANTELE_G", }
    }
    local spells_to_add = spells.ocarina
    if Random(1, 2) == 1 then
      spells_to_add = spells.kantele
    end
    for i, spell in ipairs(spells_to_add) do
      add_spells_to_wand(wand, { spell }, 1, true)
    end
    apply_mod_effects("musicstone", wand)
  end,
  physics_gold_orb = function(wand)
    local spells = merge_spells("physics_gold_orb", { "TOUCH_GOLD", "MONEY_MAGIC" })
    wand.manaMax = wand.manaMax + Random(75, 150)
    wand.castDelay = wand.castDelay - Random(1, 4)
    wand.rechargeTime = wand.rechargeTime - Random(1, 4)
    add_spells_to_wand(wand, spells, Random(2, 3), true)
    apply_mod_effects("physics_gold_orb", wand)
  end,
  physics_gold_orb_greed = function(wand)
    local spells = merge_spells("physics_gold_orb_greed", { "CURSED_ORB", "MIST_BLOOD",
      "MATERIAL_BLOOD", "TOUCH_GOLD", "TOUCH_BLOOD", "BLOOD_MAGIC", "MONEY_MAGIC", "BLOOD_TO_POWER",
      "BLOOD_TO_ACID", "LAVA_TO_BLOOD", "CLOUD_BLOOD", "HITFX_CRITICAL_BLOOD", "CURSE", "CURSE_WITHER_PROJECTILE",
      "CURSE_WITHER_EXPLOSION", "CURSE_WITHER_MELEE", "CURSE_WITHER_ELECTRICITY", "ADD_DEATH_TRIGGER"
    })
    wand.shuffle = Random(100) > 75
    wand.spellsPerCast = math.max(1, wand.spellsPerCast + Random(-2, 2))
    wand.castDelay = wand.castDelay + Random(-6, 3)
    wand.rechargeTime = wand.rechargeTime + Random(-6, 3)
    wand.manaMax = math.max(100, wand.manaMax + Random(-50, 100))
    wand.manaChargeSpeed = math.max(30, wand.manaChargeSpeed + Random(-30, 60))
    wand.capacity = math.min(math.max(26, wand.capacity), wand.capacity + Random(0, 3))
    wand.spread = wand.spread + Random(-20, 10)
    add_spells_to_wand(wand, spells, Random(4, 6))
    apply_mod_effects("physics_gold_orb_greed", wand)
  end,
  physics_greed_die = function(wand)
    local spells = merge_spells("physics_greed_die", { "CURSED_ORB", "MIST_BLOOD",
      "MATERIAL_BLOOD", "TOUCH_GOLD", "TOUCH_BLOOD", "BLOOD_MAGIC", "MONEY_MAGIC", "BLOOD_TO_POWER",
      "BLOOD_TO_ACID", "LAVA_TO_BLOOD", "CLOUD_BLOOD", "HITFX_CRITICAL_BLOOD", "CURSE", "CURSE_WITHER_PROJECTILE",
      "CURSE_WITHER_EXPLOSION", "CURSE_WITHER_MELEE", "CURSE_WITHER_ELECTRICITY", "ADD_DEATH_TRIGGER"
    })
    wand.shuffle = Random(100) > 75
    wand.spellsPerCast = math.max(1, wand.spellsPerCast + Random(-2, 2))
    wand.castDelay = wand.castDelay + Random(-6, 3)
    wand.rechargeTime = wand.rechargeTime + Random(-6, 3)
    wand.manaMax = math.max(100, wand.manaMax + Random(-50, 100))
    wand.manaChargeSpeed = math.max(30, wand.manaChargeSpeed + Random(-30, 60))
    wand.capacity = math.min(math.max(26, wand.capacity), wand.capacity + Random(0, 3))
    wand.spread = wand.spread + Random(-20, 10)
    add_spells_to_wand(wand, spells, Random(4, 6))
    apply_mod_effects("physics_greed_die", wand)
  end,
  stonestone = function(wand)
    local spells = merge_spells("stonestone", { "DIGGER", "POWERDIGGER", "CRUMBLING_EARTH",
      "SUMMON_ROCK", "SOILBALL", "CLIPPING_SHOT", "STATIC_TO_SAND", "TRANSMUTATION",
      "VACUUM_POWDER", "MATTER_EATER", "HITFX_PETRIFY", "CRUMBLING_EARTH_PROJECTILE"
    })
    wand.capacity = math.min(math.max(26, wand.capacity), wand.capacity + Random(2, 4))
    add_spells_to_wand(wand, spells, Random(4, 6))
    apply_mod_effects("stonestone", wand)
  end,
  summon_portal_broken = function(wand)
    add_spells_to_wand(wand, { "SUMMON_PORTAL" }, 1, true)
    apply_mod_effects("summon_portal_broken", wand)
  end,
  runestone_metal = function(wand)
    local spells = merge_spells("runestone_metal", { "DISC_BULLET", "DISC_BULLET_BIG",
      "DISC_BULLET_BIGGER", "PROPANE_TANK", "BOMB_CART", "WATER_TO_POISON", "POISON_BLAST",
      "POISON_TRAIL"
    })
    add_spells_to_wand(wand, spells, Random(4, 6))
    apply_mod_effects("runestone_metal", wand)
  end,
  key = function(wand)
    local spells = merge_spells("key", { "ALL_NUKES", "ALL_DISCS", "ALL_ROCKETS", "ALL_DEATHCROSSES",
      "ALL_BLACKHOLES", "ALL_ACID", "ALPHA", "GAMMA", "TAU", "OMEGA", "MU", "PHI", "SIGMA", "ZETA",
      "DIVIDE_2", "DIVIDE_3", "DIVIDE_4", "DIVIDE_10"
    })
    wand.shuffle = false
    wand.manaMax = wand.manaMax + Random(100, 300)
    wand.manaChargeSpeed = wand.manaChargeSpeed + Random(30, 50)
    wand.capacity = math.min(math.max(26, wand.capacity), wand.capacity + Random(3, 5))
    add_spells_to_wand(wand, spells, Random(2, 4), true)
    apply_mod_effects("key", wand)
  end,
  poopstone = function(wand)
    local spells = merge_spells("poopstone", { "AIR_BULLET" })
    wand.shuffle = false
    wand.castDelay = wand.castDelay - Random(2, 6)
    wand.rechargeTime = wand.rechargeTime - Random(2, 6)
    wand.capacity = math.min(math.max(26, wand.capacity), wand.capacity + Random(2, 6))
    add_spells_to_wand(wand, spells, Random(4, 6), true)
    apply_mod_effects("poopstone", wand)
  end,
}

function add_spells_to_effect(effect_name, spells)
  mod_additional_spells[effect_name] = mod_additional_spells[effect_name] or {}
  for i, spell in ipairs(spells) do
    table.insert(mod_additional_spells[effect_name], spell)
  end
end

function append_effect(material_name, func)
  mod_effects[material_name] = mod_effects[material_name] or {}
  table.insert(mod_effects[material_name], func)
  if not bonuses[material_name] then
    bonuses[material_name] = function(wand)
      local spells = merge_spells(material_name, {})
      add_spells_to_wand(wand, spells, math.min(Random(4, 6), math.floor(wand.capacity / 2)))
      apply_mod_effects(material_name, wand)
    end
  end
end

-- This doesn't take into account that merge_spells("alcohol", { "HEAL_BULLET" }) will still mention alcohol
-- fix some time later maybe... too lazy right now, would require a big rewrite
bonuses.sima = bonuses.alcohol
bonuses.juhannussima = bonuses.alcohol
bonuses.magic_liquid_hp_regeneration_unstable = bonuses.magic_liquid_hp_regeneration

-- Set up some dummy functions that aren't available here but in item_detector.lua,
-- but will be called from the appended functions by other mods
function register_physics_item() end
dofile("mods/anvil_of_destiny/files/scripts/modded_content.lua")

return bonuses
