local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local particle_emitters = EntityGetComponent(entity_id, "ParticleEmitterComponent")
if particle_emitters ~= nil then
  for i, v in ipairs(particle_emitters) do
    EntitySetComponentIsEnabled(entity_id, v, false)
  end
end
