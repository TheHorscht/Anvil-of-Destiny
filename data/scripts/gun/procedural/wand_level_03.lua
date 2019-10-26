dofile("data/scripts/gun/procedural/gun_procedural.lua")

generate_gun( 60, 3, false )

local entity_id = GetUpdatedEntityID()
EntityAddTag(entity_id, "wand_level_3")
