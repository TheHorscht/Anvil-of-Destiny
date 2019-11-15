- Make anvil indestructible by black holes etc
- Change how occurence rates work AGAIN, instead of "1.5 anvils per coalmine" use "0.2 anvils per chunk"
- FIX RandomSeed usage in anvil_trigger, only once?
- FIX Different sprites in world vs inventory
- Update mod.xml description
- Test if empty wands combine well
- Somehow set the wand sprite according to deck capacity
- Make wand_utils.lua:wand_add_spell accept a table to add multiple at once?
- Does the anvil sound keep playing forever even when not visible anymore?

try:
-- LifetimeComponent
-- PixelSceneComponent
-- RotateTowardsComponent
-- TeleportComponent
-- VariableStorageComponent
-- VelocityComponent
-- magic number DEBUG_NO_PAUSE_ON_WINDOW_FOCUS_LOST


- Once it exists in the game, maybe use ParticleEmitterComponent::use_rotation_from_entity in anvil.xml
  (On hold since it doesn't rotate now anyway)
