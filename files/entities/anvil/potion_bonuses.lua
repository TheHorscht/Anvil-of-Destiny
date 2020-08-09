return {
  blood=function(wand)
    local spells = {
			"MIST_BLOOD", "MATERIAL_BLOOD", "TOUCH_BLOOD", "CRITICAL_HIT", "BLOOD_TO_ACID",
			"CLOUD_BLOOD", "HITFX_CRITICAL_BLOOD"      
    }
    add_spells_to_wand(wand, spells, math.min(Random(2,4), math.floor(wand.capacity / 2)))
    wand.spellsPerCast = wand.spellsPerCast + Random(1, 2)
    wand.rechargeTime = wand.rechargeTime - math.max(Random(1, 2), wand.rechargeTime * Randomf(0.05, 0.1))
		wand.castDelay = wand.castDelay - math.max(Random(1, 2), wand.castDelay * Randomf(0.05, 0.1))
	end,
	water=function(wand)
     local spells = {
			"CIRCLE_WATER", "MATERIAL_WATER", "TOUCH_WATER", "WATER_TO_POISON", "SEA_WATER",
			"CLOUD_WATER", "HITFX_CRITICAL_WATER", "WATER_TRAIL"
    }
    add_spells_to_wand(wand, spells, math.min(Random(2,4), math.floor(wand.capacity / 2)))
    wand.manaMax = wand.manaMax + Random(40, 100)
	end,
	urine=function(wand)
    -- Make wand piss constantly
    local new_entity = EntityCreateNew()
    EntityAddComponent(new_entity, "InheritTransformComponent", {
      _tags="enabled_in_world,enabled_in_hand",
      parent_hotspot_tag="shoot_pos"
    })
    local emitter = EntityAddComponent(new_entity, "ParticleEmitterComponent", {
      _tags="enabled_in_hand",
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
    })
    EntitySetComponentIsEnabled(new_entity, emitter, false)
    EntityAddChild(wand.entity_id, new_entity)
	end,
	magic_liquid_teleportation=function(wand)
     local spells = {
      "DELAYED_SPELL", "LONG_DISTANCE_CAST", "TELEPORT_CAST", "TELEPORT_PROJECTILE",
			"TELEPORT_PROJECTILE_STATIC", "TELEPORTATION_FIELD"
     }
     add_spells_to_wand(wand, spells, math.min(Random(2,4), math.floor(wand.capacity / 2)))
     wand.manaMax = wand.manaMax + Random(20, 50)
     wand.manaChargeSpeed = wand.manaChargeSpeed + Random(10, 30)
	end,
	oil=function(wand)
		 local spells = {
			"CIRCLE_OIL", "MATERIAL_OIL", "TOUCH_OIL", "RECOIL_DAMPER", "SEA_OIL",
			"HITFX_CRITICAL_OIL", "OIL_TRAIL"
		 }
		 add_spells_to_wand(wand, spells, math.min(Random(1,3), math.floor(wand.capacity / 2)))
		 wand.rechargeTime = wand.rechargeTime - math.max(Random(1, 2), wand.rechargeTime * 0.15)
		 wand.castDelay = wand.castDelay - math.max(Random(1, 2), wand.castDelay * 0.15)
	end,
	magic_liquid_berserk=function(wand)
		local spells = {
			"ROCKET", "ROCKET_TIER_2", "ROCKET_TIER_3", "BOMB", "GRENADE", "GRENADE_TRIGGER",
			"GRENADE_TIER_2", "GRENADE_TIER_3", "GRENADE_ANTI", "GRENADE_LARGE", "MINE",
			"MINE_DEATH_TRIGGER", "PIPE_BOMB", "PIPE_BOMB_DEATH_TRIGGER", "EXPLODING_DEER",
			"PIPE_BOMB_DETONATOR", "DIGGER", "POWERDIGGER", "METEOR", "DYNAMITE", "GLITTER_BOMB",
			"BOMB_HOLY", "NUKE", "DAMAGE", "HEAVY_SHOT", "EXPLOSIVE_PROJECTILE", "EXPLOSION",
			"BERSERK_FIELD", "BOUNCE_EXPLOSION"
		}
		add_spells_to_wand(wand, spells, math.floor(wand.capacity / 2))
		wand.manaMax = wand.manaMax + Random(40, 90)
	end,
	magic_liquid_mana_regeneration=function(wand)
		local spells = { "MANA_REDUCE" }
    add_spells_to_wand(wand, spells, Random(0, 1))
    wand.manaChargeSpeed = wand.manaChargeSpeed + Random(80, 120)
	end,
	magic_liquid_movement_faster=function(wand)
    local spells = {
      "RECHARGE", "LIFETIME", "LIFETIME_DOWN", "LIGHT_SHOT", "KNOCKBACK", "RECOIL",
			"SPEED", "ACCELERATING_SHOT"
    }
    add_spells_to_wand(wand, spells, math.min(Random(2, 3), math.floor(wand.capacity / 2)))
    wand.rechargeTime = wand.rechargeTime - math.max(Random(1, 2), wand.rechargeTime * Randomf(0.08, 0.1))
		wand.castDelay = wand.castDelay - math.max(Random(1, 2), wand.castDelay * Randomf(0.08, 0.1))
		EntityAddComponent(wand.entity_id, "LuaComponent", {
			_tags="enabled_in_hand",
      script_source_file="mods/anvil_of_destiny/files/entities/anvil/game_effect_applicator.lua",
      execute_on_added="0",
			execute_every_n_frame=tostring(Random(60 * 10, 60 * 30)),
		})
	end,
	material_confusion=function(wand)
    local spells = {
      "CHAOTIC_ARC", "HEAVY_SPREAD"
    }
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
  magic_liquid_protection_all=function(wand)
    local spells = {
      "WALL_HORIZONTAL", "WALL_VERTICAL", "WALL_SQUARE", "SHIELD_FIELD",
      "PROJECTILE_TRANSMUTATION_FIELD", "ENERGY_SHIELD", "ENERGY_SHIELD_SECTOR"
    }
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
    wand.spellsPerCast = wand.spellsPerCast + Random(1, 3)
    wand.manaMax = wand.manaMax + Random(80, 140)
	end,
	magic_liquid_hp_regeneration=function(wand)
		local spells = { "HEAL_BULLET", "REGENERATION_FIELD" }
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
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
    wand.manaChargeSpeed = wand.manaChargeSpeed + Random(50, 70)
	end,
	magic_liquid_polymorph=function(wand)
		-- transform all spells in wand into random ones
		local spells = {
			"SUMMON_EGG", "SUMMON_HOLLOW_EGG", "SUMMON_WANDGHOST", "STATIC_TO_SAND",
			"TRANSMUTATION", "POLYMORPH_FIELD", "PROJECTILE_TRANSMUTATION_FIELD",
			"TENTACLE_RAY_ENEMY"
    }
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
    wand.spellsPerCast = wand.spellsPerCast + Random(1, 2)
    --[^(,| \t)]+
	end,
	magic_liquid_random_polymorph=function(wand)
    -- transform all spells in wand into random ones
    local spells = {
      "TENTACLE_PORTAL", "TENTACLE", "TENTACLE_TIMER", "SUMMON_EGG", "STATIC_TO_SAND",
			"TRANSMUTATION", "CHAOS_POLYMORPH_FIELD", "PROJECTILE_TRANSMUTATION_FIELD",
			"TENTACLE_RAY", "TENTACLE_RAY_ENEMY"
    }
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
	end,
	magic_liquid_charm=function(wand)
    -- charm spells, charm on slime etc
    local spells = {
      "SUMMON_EGG", "SUMMON_HOLLOW_EGG", "SUMMON_WANDGHOST", "HOMING", "HOMING_SHOOTER",
      "NECROMANCY", "TENTACLE_RAY_ENEMY", "HITFX_TOXIC_CHARM"
    }
		add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
	end,
	magic_liquid_invisibility=function(wand)
		-- Turn player invisible for some time on pickup (not working right now)
		-- EntityAddComponent(wand.entity_id, "VariableStorageComponent", {
		-- 	name="material",
		-- 	value_string="magic_liquid_invisibility",
		-- })
		-- EntityAddComponent(wand.entity_id, "LuaComponent", {
		-- 	script_item_picked_up="mods/anvil_of_destiny/files/entities/anvil/wand_pickup_custom_effect.lua",
		-- 	execute_every_n_frame="-1",
		-- 	remove_after_executed="1"
		-- })
    local spells = {
      "BLACK_HOLE", "EXPLODING_DEER", "LANCE", "X_RAY", "LIGHT"
    }
		add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
    wand.manaMax = wand.manaMax + Random(30, 40)
    wand.manaChargeSpeed = wand.manaChargeSpeed + Random(10, 30)
	end,
	magic_liquid_worm_attractor=function(wand)
		-- make player attract worms while wand is active
		EntityAddComponent(wand.entity_id, "VariableStorageComponent", {
			name="material",
			value_string="magic_liquid_worm_attractor",
		})
		EntityAddComponent(wand.entity_id, "LuaComponent", {
			script_item_picked_up="mods/anvil_of_destiny/files/entities/anvil/wand_pickup_custom_effect.lua",
			execute_every_n_frame="-1",
			remove_after_executed="1"
    })
    local spells = { "SUMMON_EGG", "SUMMON_HOLLOW_EGG", "HOMING", "HOMING_SHOOTER" }
    add_spells_to_wand(wand, spells, math.min(Random(3, 5), math.floor(wand.capacity / 2)))
	end,
	alcohol=function(wand)
		local spells = {
			"BUCKSHOT", "MIST_ALCOHOL", "TOUCH_ALCOHOL", "SCATTER_3", "SCATTER_4", "I_SHAPE",
			"Y_SHAPE", "T_SHAPE", "W_SHAPE", "CIRCLE_SHAPE", "PENTAGRAM_SHAPE", "HEAVY_SPREAD",
			"GRAVITY", "GRAVITY_ANTI", "SINEWAVE", "CHAOTIC_ARC", "PINGPONG_PATH",
			"ALCOHOL_BLAST", "SEA_ALCOHOL", "HITFX_EXPLOSION_ALCOHOL",
			"HITFX_EXPLOSION_ALCOHOL_GIGA"
    }
    wand.spread = wand.spread + Random(20, 30)
    wand.manaMax = wand.manaMax + Random(200, 300)
    wand.manaChargeSpeed = math.max(10, wand.manaChargeSpeed - Random(20, 40))
    add_spells_to_wand(wand, spells, math.min(Random(5, 10), math.floor(wand.capacity / 2)))
	end,
	blood_worm=function(wand)
		-- spawn a bunch of worms
		EntityAddComponent(wand.entity_id, "VariableStorageComponent", {
			name="material",
			value_string="blood_worm",
		})
		EntityAddComponent(wand.entity_id, "LuaComponent", {
			script_item_picked_up="mods/anvil_of_destiny/files/entities/anvil/wand_pickup_custom_effect.lua",
			execute_every_n_frame="-1",
			remove_after_executed="1"
		})
		local spells_count = wand:GetSpellsCount()
		while wand.capacity - 1 > spells_count do
			wand:AddSpells("SUMMON_EGG")
			spells_count = spells_count + 1
		end
		wand:AddSpells("X_RAY")
	end,
	radioactive_liquid=function(wand)
    local spells = { "MIST_RADIOACTIVE", "AREA_DAMAGE", "HITFX_TOXIC_CHARM" }
    add_spells_to_wand(wand, spells, math.min(Random(2, 5), math.floor(wand.capacity / 2)))
    wand.manaMax = wand.manaMax + Random(20, 40)
    wand.manaChargeSpeed = wand.manaChargeSpeed + Random(20, 40)
    wand.capacity = math.min(26, wand.capacity + Random(1, 2))
	end,
  acid=function(wand)
    local spells = {
      "ACIDSHOT", "CIRCLE_ACID", "MATERIAL_ACID", "CLIPPING_SHOT", "PIERCING_SHOT",
			"TOXIC_TO_ACID", "SEA_ACID", "SEA_ACID_GAS", "CLOUD_ACID", "ACID_TRAIL"
    }
    add_spells_to_wand(wand, spells, math.min(Random(4, 6), math.floor(wand.capacity / 2)))
    wand.spellsPerCast = wand.spellsPerCast + Random(1, 2)
	end,
	lava=function(wand)
		local spells = {
			"FIREBALL", "METEOR", "FLAMETHROWER",
			"ROCKET", "ROCKET_TIER_2", "ROCKET_TIER_3", "GRENADE", "GRENADE_TRIGGER",
			"GRENADE_TIER_2", "GRENADE_TIER_3", "GRENADE_ANTI", "GRENADE_LARGE",
			"FIREBOMB", "CIRCLE_FIRE", "LAVA_TO_BLOOD", "FIRE_BLAST", "SEA_LAVA",
			"HITFX_BURNING_CRITICAL_HIT", "FIREBALL_RAY", "FIREBALL_RAY_LINE",
			"FIREBALL_RAY_ENEMY", "ARC_FIRE", "FIRE_TRAIL", "BURN_TRAIL"
    }
    add_spells_to_wand(wand, spells, math.min(Random(4, 6), math.floor(wand.capacity / 2)))
	end,
	midas_precursor=function(wand)
		local spells = {
			"LIGHT_BULLET_TRIGGER", "LIGHT_BULLET_TRIGGER_2", "BULLET_TRIGGER", "HEAVY_BULLET_TRIGGER",
			"SLOW_BULLET_TRIGGER", "BUBBLESHOT_TRIGGER", "GRENADE_TRIGGER", "MINE_DEATH_TRIGGER", "PIPE_BOMB_DEATH_TRIGGER",
			""
    }
    add_spells_to_wand(wand, spells, math.min(Random(4, 6), math.floor(wand.capacity / 2)))
	end,
}
