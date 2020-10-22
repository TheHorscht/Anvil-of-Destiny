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
  GamePrintImportant("A gift from the gods...?", "Or is it?")
  GamePlaySound("mods/anvil_of_destiny/audio/anvil_of_destiny.snd", "fanfare", x + 4, y - 10)
else
  EntityRemoveFromParent(result_entity_id)
  EZWand(result_entity_id):PlaceAt(x + 4, y - 10)
  if config_anvil_reusable then
    EntityAddComponent2(result_entity_id, "LuaComponent", {
      script_item_picked_up = "mods/anvil_of_destiny/files/entities/anvil/result_pickup.lua",
      execute_every_n_frame = -1,
    })
  end
  GamePrintImportant("A gift from the gods", "")
  GamePlaySound("mods/anvil_of_destiny/audio/anvil_of_destiny.snd", "fanfare", x + 4, y - 10)
end
