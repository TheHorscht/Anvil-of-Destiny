- Change the wand level logic?
- Get rid of wand level logic, instead use stats?
- Make anvil indestructible by black holes etc
- Change how occurence rates work AGAIN, instead of "1.5 anvils per coalmine" use "0.2 anvils per chunk"
- When buffing reload time and cast delay, use same algo as spread as to not go towards 0 when buffing negative values
- Refactor wand hiding/respawning
- FIX RandomSeed usage in anvil_trigger, only once?
- FIX Different sprites in world vs inventory
- FIX Anvil still taking tablets after WAND + WAND
- Update mod.xml description
- Test if empty wands combine well
- Somehow set the wand sprite according to deck capacity

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
