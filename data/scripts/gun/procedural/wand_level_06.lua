dofile("data/scripts/gun/procedural/gun_procedural.lua")

generate_gun( 120, 6, false )

local entity_id = GetUpdatedEntityID()
EntityAddTag(entity_id, "wand_level_6")
