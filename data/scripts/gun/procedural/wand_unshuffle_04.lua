dofile("data/scripts/gun/procedural/gun_procedural.lua")

generate_gun( 80, 4, true )

local entity_id = GetUpdatedEntityID()
EntityAddTag(entity_id, "wand_level_4")
