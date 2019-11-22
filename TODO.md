- Change how occurence rates work AGAIN, instead of "1.5 anvils per coalmine" use "0.2 anvils per chunk"
- Update Github description
- Update modworkshop destription
- Somehow set the wand sprite according to deck capacity
- Make wand_utils.lua:wand_add_spell accept a table to add multiple at once?
- Does the anvil sound keep playing forever even when not visible anymore?
- Smithing animation?
- Think about implementing Twitch ws api wand tooltip for Pyry
- Make wand_fill_with_semi_random_spells spit out more projectiles in a row
- Put include guards everywhere?
if not some_lib then
    dofile("mods/my_mod/files/some_lib.lua")
end

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
