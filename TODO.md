- Change how occurence rates work AGAIN, instead of "1.5 anvils per coalmine" use "0.2 anvils per chunk"
- Does the anvil sound keep playing forever even when not visible anymore?
- Smithing animation?

try:
-- LifetimeComponent
-- PixelSceneComponent
-- RotateTowardsComponent
-- TeleportComponent
-- VelocityComponent
-- magic number DEBUG_NO_PAUSE_ON_WINDOW_FOCUS_LOST
-- LoadEntitiesComponent

- Once it exists in the game, maybe use ParticleEmitterComponent::use_rotation_from_entity in anvil.xml
  (On hold since it doesn't rotate now anyway)
