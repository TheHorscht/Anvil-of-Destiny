dofile("data/scripts/gun/procedural/gun_procedural.lua")

generate_gun( 40, 2, true )

local entity_id = GetUpdatedEntityID()
EntityAddTag(entity_id, "wand_level_2")
