- Change the wand level logic?
- Make anvil indestructible by black holes etc
- Change how occurence rates work AGAIN, instead of "1.5 anvils per coalmine" use "0.2 anvils per chunk"
- BUG: In dev mode, while holding a level > 0 wand and teleporting, on player re-spawning attaches level 0 to all held wands

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
