dofile_once("mods/anvil_of_destiny/files/scripts/utils.lua")
dofile_once("data/scripts/lib/coroutines.lua")
dofile_once("data/scripts/lib/utilities.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

async(function()
  wait(120)
  for i=1, 180 do
    y = y - 0.2
    EntitySetTransform(entity_id, x, y)
    wait(0)
  end
end)

async(function()
  GamePlaySound("data/audio/Desktop/animals.bank", "animals/boss_centipede/dying", x, y)
  for i=1, 60 do
    GameScreenshake(10, x, y)
    wait(0)
  end
  -- Get the statues and disable their glowing eyes
  local x, y = EntityGetTransform(entity_id)
  local entities_in_radius = EntityGetInRadius(x, y, 100)
  local statues = {}
  for i, entity in ipairs(entities_in_radius) do
    local entity_type = get_stored_entity_type(entity)
    if entity_type == "statue_facing_left" then
      table.insert(statues, { entity_id = entity, direction = "left" })
    elseif entity_type == "statue_facing_right" then
      table.insert(statues, { entity_id = entity, direction = "right" })
    end
  end
  -- "Kill" the statues and make them drop their ragdoll 
  for i,statue in ipairs(statues) do
    EntityAddComponent2(statue.entity_id, "DamageModelComponent", {
      hp=0,
      ragdoll_offset_y=3,
      ragdoll_filenames_file="mods/anvil_of_destiny/files/entities/statue/ragdoll_facing_" .. statue.direction .. "/filenames.txt",
    })
    EntityInflictDamage(statue.entity_id, 26.64, "DAMAGE_PHYSICS_HIT", "", "NORMAL", 0, 0, statue)
  end
end)
