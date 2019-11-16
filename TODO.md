- Change how occurence rates work AGAIN, instead of "1.5 anvils per coalmine" use "0.2 anvils per chunk"
- FIX RandomSeed usage in anvil_trigger, only once?
- Update Github description
- Update modworkshop destription
- Somehow set the wand sprite according to deck capacity
- Make wand_utils.lua:wand_add_spell accept a table to add multiple at once?
- Does the anvil sound keep playing forever even when not visible anymore?
- seed with GameGetFrameNum()?
- Check if wand + wand can generate always cast spell

try:
-- LifetimeComponent
-- PixelSceneComponent
-- RotateTowardsComponent
-- TeleportComponent
-- VariableStorageComponent
-- VelocityComponent
-- magic number DEBUG_NO_PAUSE_ON_WINDOW_FOCUS_LOST
-- LoadEntitiesComponent

- Once it exists in the game, maybe use ParticleEmitterComponent::use_rotation_from_entity in anvil.xml
  (On hold since it doesn't rotate now anyway)
