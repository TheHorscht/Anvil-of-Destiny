function death(damage_type_bit_field, damage_message, entity_thats_responsible, drop_items)
  local entity_id = GetUpdatedEntityID()
  local x, y = EntityGetTransform(entity_id)
  GameScreenshake(30, x, y)
  GamePlaySound("data/audio/Desktop/animals.bank", "animals/statue_physics/death", x, y)
  EntityLoad("data/entities/items/wand_unshuffle_03.xml", x, y)
end
