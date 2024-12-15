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

  -- Copy dots into a temp table, then sort by descending location.
  local dots_sorted_by_location = {}
  for i, dot in pairs(KCP.UI.Dot.all) do
    dots_sorted_by_location[i] = {}
    dots_sorted_by_location[i].location = dot.location
    dots_sorted_by_location[i].name = dot.name
    dots_sorted_by_location[i].member = dot.member
  end
  table.sort(dots_sorted_by_location, function(a, b) return a.location > b.location end)

  -- Loop through all dots, and assign raid marks based on location on the map.
  -- Because we sorted in descending order, this should result in the player
  -- closest to the melee position getting the mark in each segment.
  for i, dot in pairs(dots_sorted_by_location) do
    if (dot.member) then
      local marker_number = math.floor((dot.location - 1) / 5) + 1
      SetRaidTarget(dot.name, marker_number)
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
