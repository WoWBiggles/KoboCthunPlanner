KCP.LIB.Grid = {}
KCP.LIB.Grid.__index = KCP.LIB.Grid

-- Initializer
function KCP.LIB.Grid.create()
  local self = {}

  setmetatable(self, KCP.LIB.Grid)

  self.groups = {}
  self.populated = false

  return self
end

function KCP.LIB.Grid:set_marks()
  if(self.populated == false) then self:refresh() end

  for group_index, group in pairs(self.groups) do
    local member = group.members[1]

    if (member ~= nil) then
      SetRaidTarget(member.name, group_index)
    end
  end
end

function KCP.LIB.Grid:refresh()
  KCP.UI.Dot.reset_all()

  self.groups = {}
  self:populate()
  self:draw()
end

function KCP.LIB.Grid:populate()
  if not self.populated then
    KCP.submit_event({ type = "REQUEST_SHARE" })
  end

  for raid_index = 1, 40 do
    local member = KCP.LIB.Member.create(raid_index)

    if(member.name == KCP.player_name) then
      KCP.player = member
    end

    self:add_member(member)
  end

  self.populated = true
end

function KCP.LIB.Grid:add_member(member)
  if self.groups[member.subgroup] == nil then
    self.groups[member.subgroup] = KCP.LIB.Group.create(member.subgroup)
  end

  self.groups[member.subgroup]:add_member(member)
end

function KCP.LIB.Grid:draw()
  for group_index, group in pairs(self.groups) do
    for member_index, member in pairs(group.members) do
      local position_index = ((group_index - 1) * 5) + member_index
      KCP.UI.Dot.create_or_update(position_index, member)
    end
  end
end
