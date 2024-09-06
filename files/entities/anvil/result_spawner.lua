dofile_once("mods/anvil_of_destiny/config.lua")
local EZWand = dofile_once("mods/anvil_of_destiny/lib/EZWand/EZWand.lua")

local entity_id = GetUpdatedEntityID()
local x, y = EntityGetTransform(entity_id)

local function retrieve_result()
  local children = EntityGetAllChildren(entity_id)
  for i, child in ipairs(children) do
    if EntityGetName(child) == "output_storage" then
      local output_storage_children = EntityGetAllChildren(child)
      if output_storage_children == nil then
        return -1
      end
      return output_storage_children[1]
    end
  end
end

local result_entity_id = retrieve_result()
if result_entity_id == -1 then
  EntityLoad("mods/anvil_of_destiny/files/entities/holy_bomb/floating.xml", x + 3, y - 22)
  GamePrintImportant("$log_AoD_anvil_overcharged", "$log_AoD_anvil_overcharged_desc")
  GamePlaySound("mods/anvil_of_destiny/audio/anvil_of_destiny.bank", "fanfare", x + 4, y - 10)
else
  EntityRemoveFromParent(result_entity_id)
  EZWand(result_entity_id):PlaceAt(x + 4, y - 10)
  local cx, cy = GameGetCameraPos()
  SetRandomSeed(cx, cy)
  if ModSettingGet("anvil_of_destiny.reusable") and (Randomf() <= ModSettingGet("anvil_of_destiny.reusable_chance")) then
    EntityAddComponent2(result_entity_id, "LuaComponent", {
      script_item_picked_up = "mods/anvil_of_destiny/files/entities/anvil/result_pickup.lua",
      execute_every_n_frame = -1,
    })
  end
  GamePrintImportant("$log_AoD_anvil_success", "")
  GamePlaySound("mods/anvil_of_destiny/audio/anvil_of_destiny.bank", "fanfare", x + 4, y - 10)
end
