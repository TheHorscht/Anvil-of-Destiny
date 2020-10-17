mod_additional_spells = {}

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

return {
  blood = function(wand)
    local spells = merge_spells("blood", {
      "MIST_BLOOD", "MATERIAL_BLOOD", "TOUCH_BLOOD", "CRITICAL_HIT", "BLOOD_TO_ACID",
      "CLOUD_BLOOD", "HITFX_CRITICAL_BLOOD", "CURSED_ORB", "BLOOD_MAGIC"
    })
    wand.spellsPerCast = wand.spellsPerCast + Random(1, 2)
    wand.rechargeTime = wand.rechargeTime - math.max(Random(1, 2), wand.rechargeTime * Randomf(0.05, 0.1))
    wand.castDelay = wand.castDelay - math.max(Random(1, 2), wand.castDelay * Randomf(0.05, 0.1))
    add_spells_to_wand(wand, spells, math.min(Random(2,4), math.floor(wand.capacity / 2)))
  end,
  water = function(wand)
    local spells = merge_spells("water", {
      "CIRCLE_WATER", "MATERIAL_WATER", "TOUCH_WATER", "WATER_TO_POISON", "SEA_WATER",
      "CLOUD_WATER", "HITFX_CRITICAL_WATER", "WATER_TRAIL"
    })
    wand.manaMax = wand.manaMax + Random(40, 100)
    add_spells_to_wand(wand, spells, math.min(Random(2,4), math.floor(wand.capacity / 2)))
  end,
  urine = function(wand)
    local spells = merge_spells("urine", {})
    -- Make wand piss constantly
    local new_entity = EntityCreateNew()
    EntityAddComponent(new_entity, "InheritTransformComponent", {
      _tags="enabled_in_world,enabled_in_hand",
      parent_hotspot_tag="shoot_pos"
    })
    local emitter = EntityAddComponent(new_entity, "ParticleEmitterComponent", {
      _tags="enabled_in_hand",
      _enabled="0",
      is_emitting="1",
      emitted_material_name="urine",
      emission_interval_min_frames="1",
      emission_interval_max_frames="1",
      count_min="2",
      count_max="3",
      draw_as_long="1",
      is_trail="1",
      trail_gap="1",
      collide_with_grid="0",
      x_vel_min="70",
      x_vel_max="90",
      y_vel_min="-5",
      y_vel_max="5",
    })
    ComponentSetValue2(emitter, "count_min", 2)
    ComponentSetValue2(emitter, "count_max", 3)
    EntitySetComponentIsEnabled(new_entity, emitter, false)
    EntityAddChild(wand.entity_id, new_entity)
    add_spells_to_wand(wand, spells, math.min(Random(2,4), math.floor(wand.capacity / 2)))
  end,
  magic_liquid_teleportation = function(wand)
     local spells = merge_spells("magic_liquid_teleportation", {
      "DELAYED_SPELL", "LONG_DISTANCE_CAST", "TELEPORT_CAST", "TELEPORT_PROJECTILE",
      "TELEPORT_PROJECTILE_STATIC", "TELEPORTATION_FIELD", "SUPER_TELEPORT_CAST"
     })
     wand.manaMax = wand.manaMax + Random(20, 50)
     wand.manaChargeSpeed = wand.manaChargeSpeed + Random(10, 30)
     add_spells_to_wand(wand, spells, math.min(Random(2,4), math.floor(wand.capacity / 2)))
  end,
  magic_liquid_unstable_teleportation = function(wand)
    local spells = merge_spells("magic_liquid_teleportation", {
     "DELAYED_SPELL", "LONG_DISTANCE_CAST", "TELEPORT_CAST", "TELEPORT_PROJECTILE",
     "TELEPORT_PROJECTILE_STATIC", "TELEPORTATION_FIELD", "SUPER_TELEPORT_CAST"
    })
    wand.manaMax = wand.manaMax + Random(20, 50)
    wand.manaChargeSpeed = wand.manaChargeSpeed + Random(10, 30)
    add_spells_to_wand(wand, spells, math.min(Random(2,4), math.floor(wand.capacity / 2)))
 end,
  oil = function(wand)
    local spells = merge_spells("oil", {
      "CIRCLE_OIL", "MATERIAL_OIL", "TOUCH_OIL", "RECOIL_DAMPER", "SEA_OIL",
      "HITFX_CRITICAL_OIL", "OIL_TRAIL"
    })
    wand.rechargeTime = wand.rechargeTime - math.max(Random(1, 2), wand.rechargeTime * 0.15)
    wand.castDelay = wand.castDelay - math.max(Random(1, 2), wand.castDelay * 0.15)
    add_spells_to_wand(wand, spells, math.min(Random(1,3), math.floor(wand.capacity / 2)))
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
    wand.manaChargeSpeed = wand.manaChargeSpeed - math.ceil(math.abs(wand.manaChargeSpeed) * Randomf(0.05, 0.10))
    wand.manaMax = wand.manaMax + math.min(Random(150, 200), wand.manaMax * Randomf(0.10, 0.20))
    wand.capacity = wand.capacity + Random(2, 3)
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
 end,
 gunpowder_unstable = function(wand)
    local spells = merge_spells("gunpowder_unstable", {
      "BOMB_CART", "DYNAMITE", "BOMB", "GLITTER_BOMB", "BOMB_HOLY", "NUKE", "MINE", "FIRE_BLAST", "EXPLOSION", "BOUNCE_EXPLOSION",
      "ARC_GUNPOWDER", "EXPLOSIVE_PROJECTILE", "UNSTABLE_GUNPOWDER", "GUNPOWDER_TRAIL", "TOUCH_SMOKE", "ALL_NUKES", "ALL_ROCKETS"
    })
    wand.capacity = math.min(26, wand.capacity + Random(2,3))
    add_spells_to_wand(wand, spells, math.min(Random(3,5), math.floor(wand.capacity / 2)))
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
  end,
  magic_liquid_berserk = function(wand)
    local spells = merge_spells("magic_liquid_berserk", {
      "ROCKET", "ROCKET_TIER_2", "ROCKET_TIER_3", "BOMB", "GRENADE", "GRENADE_TRIGGER",
      "GRENADE_TIER_2", "GRENADE_TIER_3", "GRENADE_ANTI", "GRENADE_LARGE", "MINE",
      "MINE_DEATH_TRIGGER", "PIPE_BOMB", "PIPE_BOMB_DEATH_TRIGGER", "EXPLODING_DEER",
      "PIPE_BOMB_DETONATOR", "DIGGER", "POWERDIGGER", "METEOR", "DYNAMITE", "GLITTER_BOMB",
      "BOMB_HOLY", "NUKE", "DAMAGE", "HEAVY_SHOT", "EXPLOSIVE_PROJECTILE", "EXPLOSION",
      "BERSERK_FIELD", "BOUNCE_EXPLOSION", "ALL_NUKES"
    })
    wand.manaMax = wand.manaMax + Random(40, 90)
    add_spells_to_wand(wand, spells, math.floor(wand.capacity / 2))
  end,
  magic_liquid_mana_regeneration = function(wand)
    local spells = merge_spells("magic_liquid_mana_regeneration", { "MANA_REDUCE" })
    wand.manaChargeSpeed = wand.manaChargeSpeed + Random(80, 120)
    add_spells_to_wand(wand, spells, Random(0, 1))
  end,
  magic_liquid_movement_faster = function(wand)
    local spells = merge_spells("magic_liquid_movement_faster", {
      "RECHARGE", "LIFETIME", "LIFETIME_DOWN", "LIGHT_SHOT", "KNOCKBACK", "RECOIL",
      "SPEED", "ACCELERATING_SHOT"
    })
    wand.rechargeTime = wand.rechargeTime - math.max(Random(1, 2), wand.rechargeTime * Randomf(0.08, 0.1))
    wand.castDelay = wand.castDelay - math.max(Random(1, 2), wand.castDelay * Randomf(0.08, 0.1))
    add_spells_to_wand(wand, spells, math.min(Random(2, 3), math.floor(wand.capacity / 2)))
  end,
  magic_liquid_faster_levitation = function(wand)
    local spells = merge_spells("magic_liquid_faster_levitation", {
      "RECHARGE", "LIFETIME", "LIFETIME_DOWN", "LIGHT_SHOT", "KNOCKBACK", "RECOIL",
      "SPEED", "ACCELERATING_SHOT"
    })
    wand.rechargeTime = wand.rechargeTime - math.max(Random(1, 2), wand.rechargeTime * Randomf(0.08, 0.1))
    wand.castDelay = wand.castDelay - math.max(Random(1, 2), wand.castDelay * Randomf(0.08, 0.1))
    add_spells_to_wand(wand, spells, math.min(Random(2, 4), math.floor(wand.capacity / 2)))
  end,
  magic_liquid_faster_levitation_and_movement = function(wand)
    local spells = merge_spells("magic_liquid_faster_levitation_and_movement", {
      "RECHARGE", "LIFETIME", "LIFETIME_DOWN", "LIGHT_SHOT", "KNOCKBACK", "RECOIL",
      "SPEED", "ACCELERATING_SHOT"
    })
    EntityAddComponent(wand.entity_id, "LuaComponent", {
      _tags="enabled_in_hand",
      script_source_file="mods/anvil_of_destiny/files/entities/anvil/game_effect_applicator.lua",
      execute_on_added="0",
      execute_every_n_frame=tostring(Random(60 * 10, 60 * 30)),
    })
    wand.rechargeTime = wand.rechargeTime - math.max(Random(2, 4), wand.rechargeTime * Randomf(0.16, 0.2))
    wand.castDelay = wand.castDelay - math.max(Random(2, 4), wand.castDelay * Randomf(0.16, 0.2))
    add_spells_to_wand(wand, spells, math.min(Random(4, 8), math.floor(wand.capacity / 2)))
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
  end,
  magic_liquid_protection_all = function(wand)
    local spells = merge_spells("magic_liquid_protection_all", {
      "WALL_HORIZONTAL", "WALL_VERTICAL", "WALL_SQUARE", "SHIELD_FIELD",
      "PROJECTILE_TRANSMUTATION_FIELD", "ENERGY_SHIELD", "ENERGY_SHIELD_SECTOR", "MAGIC_SHIELD", "BIG_MAGIC_SHIELD"
    })
    wand.spellsPerCast = wand.spellsPerCast + Random(1, 3)
    wand.manaMax = wand.manaMax + Random(80, 140)
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
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
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
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
  end,
  magic_liquid_random_polymorph = function(wand)
    -- transform all spells in wand into random ones
    local spells = merge_spells("magic_liquid_random_polymorph", {
      "TENTACLE_PORTAL", "TENTACLE", "TENTACLE_TIMER", "SUMMON_EGG", "STATIC_TO_SAND",
      "TRANSMUTATION", "CHAOS_POLYMORPH_FIELD", "PROJECTILE_TRANSMUTATION_FIELD",
      "TENTACLE_RAY", "TENTACLE_RAY_ENEMY", "RANDOM_EXPLOSION"
    })
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
  end,
  magic_liquid_charm = function(wand)
    -- charm spells, charm on slime etc
    local spells = merge_spells("magic_liquid_charm", {
      "SUMMON_EGG", "SUMMON_HOLLOW_EGG", "SUMMON_WANDGHOST", "HOMING", "HOMING_SHOOTER",
      "NECROMANCY", "TENTACLE_RAY_ENEMY", "HITFX_TOXIC_CHARM", "SWARM_FLY", "SWARM_FIREBUG", "SWARM_WASP",
      "FRIEND_FLY"
    })
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
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
  end,
  blood_worm = function(wand)
  local spells = merge_spells("blood_worm", {
      "CLIPPING_SHOT", "X_RAY", "MATTER_EATER", "LUMINOUS_DRILL", "LASER_LUMINOUS_DRILL",
      "LANCE", "DIGGER", "POWERDIGGER", "BLACK_HOLE", "ALL_BLACKHOLES"
      })
    add_spells_to_wand(wand, spells, math.min(Random(2, 5), math.floor(wand.capacity / 2)))
  end,
  radioactive_liquid = function(wand)
    local spells = merge_spells("radioactive_liquid", { "MIST_RADIOACTIVE", "AREA_DAMAGE", "HITFX_TOXIC_CHARM" })
    wand.manaMax = wand.manaMax + Random(20, 40)
    wand.manaChargeSpeed = wand.manaChargeSpeed + Random(20, 40)
    wand.capacity = math.min(26, wand.capacity + Random(1, 2))
    add_spells_to_wand(wand, spells, math.min(Random(2, 5), math.floor(wand.capacity / 2)))
  end,
  acid = function(wand)
    local spells = merge_spells("acid", {
      "ACIDSHOT", "CIRCLE_ACID", "MATERIAL_ACID", "CLIPPING_SHOT", "PIERCING_SHOT",
      "TOXIC_TO_ACID", "SEA_ACID", "SEA_ACID_GAS", "CLOUD_ACID", "ACID_TRAIL", "ALL_ACID"
    })
    wand.spellsPerCast = wand.spellsPerCast + Random(1, 2)
    add_spells_to_wand(wand, spells, math.min(Random(4, 6), math.floor(wand.capacity / 2)))
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
  end,
  midas = function(wand)
    local spells = merge_spells("midas", { "TOUCH_GOLD", "ALL_SPELLS" })
    wand.manaChargeSpeed = wand.manaChargeSpeed + Random(20, 40)
    wand.manaMax = math.floor(wand.manaMax * Randomf(1.05, 1.10))
    wand.capacity = math.min(26, wand.capacity + Random(1, 2))
    add_spells_to_wand(wand, spells, math.min(Random(4, 8), math.floor(wand.capacity * 0.5)))
  end,
  -- freezing liquid
  blood_cold = function(wand)
    local spells = merge_spells("blood_cold", { "PROPANE_TANK", "FREEZE_FIELD", "FREEZE", "FREEZING_GAZE" })
    add_spells_to_wand(wand, spells, math.min(Random(4, 6), math.floor(wand.capacity * 0.5)))
  end,
  vomit = function(wand)
    local spells = merge_spells("vomit", {})
    wand.manaChargeSpeed = wand.manaChargeSpeed * Randomf(0.4, 0.6)
    wand.castDelay = Random(-40, -30)
    wand.rechargeTime = Random(260, 340)
    wand.spread = Randomf(50, 70)
    wand.capacity = math.min(26, wand.capacity + Random(2, 3))
    add_spells_to_wand(wand, spells, math.min(Random(4, 6), math.floor(wand.capacity * 0.5)))
  end,

  -- Optional Arcane Alchemy mod compatibility: https://steamcommunity.com/sharedfiles/filedetails/?id=2074171525
  AA_MAT_DARKMATTER = function(wand)
    local spells = merge_spells("AA_MAT_DARKMATTER", { "BLACK_HOLE", "BLACK_HOLE_BIG", "AREA_DAMAGE", "ALL_BLACKHOLES" })
    wand.manaMax = wand.manaMax + Random(20, 40)
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
  end,
  AA_MAT_HITSELF = function(wand)
    local spells = merge_spells("AA_MAT_HITSELF", {
      "TENTACLE_RAY", "TENTACLE_RAY_ENEMY", "FIREBALL_RAY", "FIREBALL_RAY_ENEMY", "PIERCING_SHOT", "HOMING_SHOOTER",
      "TENTACLE_PORTAL", "ALL_DISCS", "DISC_BULLET_BIG"
    })
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
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
  end,
  AA_MAT_HUNGRY_SLIME = function(wand)
    local spells = merge_spells("AA_MAT_HUNGRY_SLIME", { "MATTER_EATER", "BUBBLESHOT_TRIGGER", "BULLET_TRIGGER", "LIGHT_BULLET_TRIGGER",
      "HEAVY_BULLET_TRIGGER", "SLOW_BULLET_TRIGGER", "LARPA_UPWARDS", "LARPA_DOWNWARDS", "LARPA_CHAOS", "LARPA_CHAOS_2", "DUPLICATE" })
    wand.speedMultiplier = wand.speedMultiplier * Randomf(0.7, 0.9)
    add_spells_to_wand(wand, spells, math.min(Random(2, 4), math.floor(wand.capacity / 2)))
  end,
  AA_MAT_REPULTIUM = function(wand)
    local spells = merge_spells("AA_MAT_REPULTIUM", {
      "LIGHT_SHOT", "ACCELERATING_SHOT", "SPEED", "KNOCKBACK", "RECOIL", "AVOIDING_ARC", "FLY_DOWNWARDS", "FLY_UPWARDS", "PINGPONG_PATH", "BOUNCE",
      "ENERGY_SHIELD", "ENERGY_SHIELD_SECTOR", "SHIELD_FIELD", "RUBBER_BALL"
    })
    wand.speedMultiplier = wand.speedMultiplier + Randomf(0.3, 0.6)
    wand.spread = wand.spread + Random(10, 20)
    add_spells_to_wand(wand, spells, math.min(Random(4, 7), math.floor(wand.capacity / 2)))
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
  end,
  -- /Arcane Alchemy
}
