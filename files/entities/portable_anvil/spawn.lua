local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)
GamePlaySound( "data/audio/Desktop/event_cues.bank", "event_cues/heart_fullhp/create", x, y )
EntityLoad("mods/anvil_of_destiny/files/entities/portable_anvil/placeholder.xml", x, y - 100 + 10)
-- This clears the area the room would spawn in
LoadPixelScene("mods/anvil_of_destiny/files/entities/portable_anvil/clearer.png", "", x - 125, y - 200 + 10, "", true, false)