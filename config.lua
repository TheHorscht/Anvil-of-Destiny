-- The occurence rate of anvil for each biome, on average (does not guarantee that many will spawn!)

-- Pyramid
config_altar_room_occurences_pyramid = 1 -- max 4.739173553719	
-- Mines
config_altar_room_occurences_coalmine = 1 -- max 1.2926232741617
-- Coal Pits
config_altar_room_occurences_excavationsite = 1.5 -- max 1.6384
-- Snowy Depths
config_altar_room_occurences_snowcave = 1.5 -- max 2.7266272189349
-- Hiisi Base
config_altar_room_occurences_snowcastle = 1.5 -- max 2.262090729783
-- Underground Jungle
config_altar_room_occurences_rainforest = 1.5 -- max 3.9936
-- The Vault
config_altar_room_occurences_vault = 2 -- max 4.9152
-- Temple of the Art
config_altar_room_occurences_crypt = 3 -- max 4.739173553719	

-- true = generated wands can have shuffle YES
-- false = generated wands will always have NO shuffle
config_can_generate_shuffle_wands = false

-- These will always get added to a wand, regardless of % buff, Random(min, max)
config_flat_buff_amounts = {
  mana_charge_speed = { min = 40, max = 60 },
  mana_max = { min = 25, max = 40 },
  reload_time = { min = 0, max = 1 }, -- Recharge time in frames
  fire_rate_wait = { min = 0, max = 1 }, -- Cast delay in frames
  spread_degrees = { min = 0, max = 1 },
}

-- Buff % are randomly split among the following 5 stats, for instance:
-- 100% buff =
-- Mana charge speed + 25%
-- Mana max + 12%
-- Recharge time - 13%
-- Cast delay - 19%
-- Spread - 31%

-- By how much percent a new wand with 0 or 1 tablets sacrificed should be buffed
config_regular_wand_buff_percent = 75

-- By how much percent a wand should get buffed with 2 tablets
config_improved_wand_buff_percent = 150
