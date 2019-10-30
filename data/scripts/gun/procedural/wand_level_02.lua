dofile("data/scripts/gun/procedural/gun_procedural.lua")

generate_gun( 40, 2, false )
-- Add a tag so we can later use it to get the wand level
local entity_id = GetUpdatedEntityID()
EntityAddTag(entity_id, "wand_level_2")
