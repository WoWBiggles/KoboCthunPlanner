KCP.LIB.Group = {}
KCP.LIB.Group.__index = KCP.LIB.Group

-- Initializer
function KCP.LIB.Group.create(number)
  local self = {}

  setmetatable(self, KCP.LIB.Group)

  self.number = number
  self.members = {}

  return self
end

function KCP.LIB.Group:add_member(member)
  if(member:is_available() == false) then return false end

  if(member:is_melee()) then
    self:handle_melee(member)
  elseif(member:is_range()) then
    self:handle_range(member)
  elseif(member:is_heal()) then
    self:handle_heal(member)
  end
end

-- @private

-- 1st row > 2nd row > 3rd row
function KCP.LIB.Group:handle_melee(member)
  self:set_member(member, { 1, 5, 2, 3, 4 })
end

-- 3rd row > 2nd row > 1st row
function KCP.LIB.Group:handle_range(member)
  self:set_member(member, { 3, 4, 5, 2, 1 })
end

-- 2nd row > 3rd row > 1st row
function KCP.LIB.Group:handle_heal(member)
  self:set_member(member, { 2, 5, 3, 4, 1 })
end

-- @note 1st row: position == 1
--       2nd row: position == 5 or position == 3
--       3rd row: position == 2 or position == 4
function KCP.LIB.Group:set_member(member, order)
  for i = 1, 5 do
    local position = order[i]
    if(self.members[position] == nil) then
      self.members[position] = member
      return true
    end
  end
end
