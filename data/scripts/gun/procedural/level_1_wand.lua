dofile("data/scripts/gun/procedural/gun_procedural.lua")

-- This is used to generate wands in coalmine

function do_level1( level )

	local entity_id = GetUpdatedEntityID()
	local x, y = EntityGetTransform( entity_id )
	SetRandomSeed( x, y )

	EntityAddTag(entity_id, "wand_level_1")

	local ability_comp = EntityGetFirstComponent( entity_id, "AbilityComponent" )

	if( ability_comp == nil ) then
		print_error( "Couldn't find AbilityComponent for entity, it is probably not enabled" )
	end

	local reload_time = tonumber( ComponentObjectGetValue( ability_comp, "gun_config", "reload_time"  ) )
	local fire_rate_wait = tonumber( ComponentObjectGetValue( ability_comp, "gunaction_config", "fire_rate_wait" ) )
	local spread_degrees = tonumber( ComponentObjectGetValue( ability_comp, "gunaction_config", "spread_degrees" ) )
	local deck_capacity = tonumber( ComponentObjectGetValue( ability_comp, "gun_config", "deck_capacity" ) )
	local mana_max = tonumber( ComponentGetValue( ability_comp, "mana_max" ) )

	local total = reload_time + fire_rate_wait + spread_degrees
	-- print(total)
	-- print( reload_time + fire_rate_wait + spread_degrees )
	--[[
	ComponentObjectSetValue( ability_comp, "gun_config", "actions_per_round", gun["actions_per_round"] )
	ComponentObjectSetValue( ability_comp, "gun_config", "deck_capacity", gun["deck_capacity"] )
	ComponentObjectSetValue( ability_comp, "gun_config", "shuffle_deck_when_empty", gun["shuffle_deck_when_empty"] )
	ComponentObjectSetValue( ability_comp, "gunaction_config", "spread_degrees", gun["spread_degrees"] )
	ComponentObjectSetValue( ability_comp, "gunaction_config", "speed_multiplier", gun["speed_multiplier"] )
	]]--

	total = total + Random( -10, 20 )

	local level_1_cards =
	{
		"LIGHT_BULLET",
		"RUBBER_BALL",
		"ARROW",
		"DISC_BULLET",
		"BOUNCY_ORB",
		"BULLET"
	}	

	local card_count = Random( 1, 5 ) 

	if( total > 50 ) then
		level_1_cards = 
		{
			"GRENADE",
			"BOMB",
		}
		card_count = 1
	end

	local do_util = Random( 0, 100 )
	if( do_util < 30 ) then
		level_1_cards = 
		{
			"CLOUD_WATER",
			"X_RAY",
			"FREEZE_FIELD",
			"BLACK_HOLE",
			"TORCH"
		}
		card_count = 1
	end


	if( card_count > deck_capacity ) then card_count = deck_capacity end

	local card = RandomFromArray( level_1_cards )

	for i=1,card_count do
		AddGunAction( entity_id, card )
	end

end

do_level1( 1 )
