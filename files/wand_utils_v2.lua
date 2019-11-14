local Wand = {}

function Wand:New(from)
  local o = {}
  setmetatable(o, self)
  self.__index = self

  if type(from) == "number" then
    o.id = from
  elseif type(from) == "string" then
    --o.id = EntityLoad(from)
  elseif from == nil then
    --o.id = createNewEntity
  end

  return o
end

function Wand:AddSpell()
  print(self.hello)
end

return Wand
