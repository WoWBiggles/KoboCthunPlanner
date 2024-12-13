-- Experimental
KCP.UI.Dot = {}
KCP.UI.Dot.__index = KCP.UI.Dot

KCP.UI.Dot.all = {}

local default_positions = {
  [1] = {1, 98},       --melee         --
  [2] = {-32, 131},    --healer        -|
  [3] = {-20, 170},    --ranged        -|Group 1
  [4] = {22, 171},     --ranged        -|
  [5] = {34, 132},     --healer/ranged --
  [6] = {67, 71},      -- melee        --
  [7] = {69, 118},     --healer        -|
  [8] = {105, 137},    --ranged        -|Group 2
  [9] = {134, 107},    --ranged        -|
  [10] = {115, 70},    --healer/ranged --
  [11] = {-66, 69},    -- melee        --
  [12] = {-113, 69},   --healer        -|
  [13] = {-132, 106},  --ranged        -|Group 3
  [14] = {-66, 116},   --ranged        -|
  [15] = {-103, 135},  --healer/ranged --
  [16] = {97, 4},      -- melee        --
  [17] = {130, 37},    --healer        -|
  [18] = {169, 24},    --ranged        -|Group 4
  [19] = {170, -17},   --ranged        -|
  [20] = {130, -30},   --healer/ranged --
  [21] = {-93, 2},     -- melee        --
  [22] = {-126, -31},  --healer        -|
  [23] = {-166, -19},  --ranged        -|Group 5
  [24] = {-166, 22},   --ranged        -|
  [25] = {-127, 35},   --healer/ranged --
  [26] = {69, -64},    -- melee        --
  [27] = {117, -64},   --healer        -|
  [28] = {135, -100},  --ranged        -|Group 6
  [29] = {107, -129},  --ranged        -|
  [30] = {70, -110},   --healer/ranged --
  [31] = {-65, -65},   -- melee        --
  [32] = {-65, -112},  --healer        -|
  [33] = {-101, -131}, --ranged        -|Group 7
  [34] = {-130, -102}, --ranged        -|
  [35] = {-112, -66},  --healer/ranged --
  [36] = {3, -92},     -- melee        --
  [37] = {36, -126},   --healer        -|
  [38] = {24, -165},   --ranged        -|Group 8
  [39] = {-18, -165},  --ranged        -|
  [40] = {-30, -126}   --healer/ranged --
}

local current_layout = "default"

function KCP.UI.Dot.init()
  KCP_POSITIONS = KCP_POSITIONS or { default = KCP.copy_table(default_positions) }
end

function KCP.UI.Dot.reset_positions()
  KCP_POSITIONS = { default = KCP.copy_table(default_positions) }
  KCP.UI.Dot.share_positions()
end

function KCP.UI.Dot.share_positions()
  KCP.submit_event({ type = "SHARE_POSITIONS", payload = KCP_POSITIONS[current_layout] })
end

function KCP.UI.Dot.set_positions(new_positions)
  KCP_POSITIONS[current_layout] = new_positions

  for _, dot in pairs(KCP.UI.Dot.all) do
    dot:reload_position()
  end
end

function KCP.UI.Dot.create_or_update(number, member)
  local dot = KCP.UI.Dot.all[number]

  if dot == nil then
    dot = KCP.UI.Dot.create(number, member)
    KCP.UI.Dot.all[number] = dot
  else
    dot:update(number, member)
  end

  dot:refresh()
end


function KCP.UI.Dot.reset_all()
  for i = 1, 40 do
    KCP.UI.Dot.create_or_update(i, nil, nil)
  end
end

-- Initializer
function KCP.UI.Dot.create(number, member)
  local self = {}

  setmetatable(self, KCP.UI.Dot)

  self:update(number, member)
  self:create_frame(KCP.frame.frame)

  return self
end

function KCP.UI.Dot:update(number, member)
  self.number = number
  self.member = member
  self.name = member and member.name
  self.class = member and member.class

  if self.name == nil then self.name = "Empty" end
end

function KCP.UI.Dot.can_interact()
  return (KCP.player:is_leader() or KCP.player:is_assist())
end

function KCP.UI.Dot:create_frame(parent)
  self.button = CreateFrame("Button", nil, parent)

  self.button:EnableMouse(true)
  self.button:SetFrameLevel(self.button:GetFrameLevel() + 3)

  self.button.texture = self.button:CreateTexture(nil, "OVERLAY")
  self.button.texture:SetAllPoints(self.button)

  self:reload_position()
  self:make_interactive()
  self:refresh()
end

function KCP.UI.Dot:reload_position()
  local positions = KCP_POSITIONS[current_layout]

  self:set_position(positions[self.number][1], positions[self.number][2])
end

function KCP.UI.Dot:make_interactive()
  self.button:SetMovable(true)
  self.button:SetScript("OnMouseDown", function(button, mouse_button)
    self:handle_mouse_down(button, mouse_button)
  end)
  self.button:SetScript("OnMouseUp", function(button, mouse_button)
    self:handle_mouse_up(button, mouse_button)
  end)
end

function KCP.UI.Dot:handle_mouse_down(button, mouse_button)
  if(not KCP.UI.Dot.can_interact()) then return false end

  if(button.isMoving) then return false end

  if mouse_button == "RightButton" then
    if(KCP.UI.DotSwap:is_in_progress())  then
      KCP.UI.DotSwap:finish(self)
    else
      if IsAltKeyDown() then
        KCP.UI.Dot.reset_positions()
      else
        KCP.UI.Cursor.set("UI-Cursor-Move")
        KCP.UI.Dot.DragHelper:start(button)
      end
    end
  elseif mouse_button == "LeftButton" then
    if KCP.UI.DotSwap:is_in_progress() then
      KCP.UI.DotSwap:finish(self)
    else
      KCP.UI.DotSwap:start(self)
    end
  end
end

function KCP.UI.Dot:handle_mouse_up(button, mouse_button)
  if mouse_button == "RightButton" and button.isMoving then
    KCP.UI.Dot.DragHelper:stop(self, button)
  end
end

function KCP.UI.Dot:set_position(x, y)
  self.button:ClearAllPoints()
  self.button:SetPoint("CENTER", KCP.frame.frame, "CENTER", x, y)

  KCP_POSITIONS[current_layout][self.number][1] = x
  KCP_POSITIONS[current_layout][self.number][2] = y
end

function KCP.UI.Dot:refresh()
  self:update_texture()
  self:update_tooltip()

  self.button:SetScale(KCP.frame.frame:GetEffectiveScale())
  KCP.frame:resize()
end

function KCP.UI.Dot:update_texture()
  if (self.member == nil) then
    self.button.texture:SetTexture("Interface/Buttons/UI-EmptySlot")
  elseif (not self.member.online) then
    self.button.texture:SetTexture("Interface/ICONS/Ability_Stealth")
  elseif (self.member.isDead) then
    self.button.texture:SetTexture("Interface/ICONS/INV_Misc_QuestionMark")
  else
    local capitalized_class = self.class:gsub("^%l", string.upper)
    self.button.texture:SetTexture("Interface/ICONS/ClassIcon_" .. capitalized_class)
  end

  if (KCP.player_name == self.name) then
    self.button:SetWidth(32)
    self.button:SetHeight(32)
  else
    self.button:SetWidth(16)
    self.button:SetHeight(16)
  end
end

function KCP.UI.Dot:update_tooltip()
  self.button:SetScript("OnEnter", function()
    GameTooltip:SetOwner(self.button, "ANCHOR_RIGHT")
    local tooltip = self.name

    if(KCP.UI.Dot.can_interact()) then
      if(not KCP.UI.Cursor.current) then
        KCP.UI.Cursor.set("Interact")
      end

      if KCP.UI.DotSwap:is_in_progress() then
        tooltip = "LMB: Swap " .. KCP.UI.DotSwap.source.name .. " with " .. self.name
      else
        tooltip = (
          tooltip .. "\n\n" ..
          "LMB: Swap Position" .. "\n" ..
          "RMB (hold): Drag" .. "\n" ..
          "Alt + RMB: Reset all positions"
        )
      end
    end

    GameTooltip:SetText(tooltip)
    GameTooltip:Show()
  end)

  self.button:SetScript("OnLeave", function()
    if(KCP.UI.DotSwap:is_in_progress()) then
      KCP.UI.Cursor.set("Crosshairs")
    else
      KCP.UI.Cursor.set(nil)
    end

    GameTooltip:Hide()
  end)
end

function KCP.UI.Dot:swap_position_with(other_dot)
  local _, _, _, x, y = self.button:GetPoint()
  local _, _, _, other_x, other_y = other_dot.button:GetPoint()

  x = math.floor(x)
  y = math.floor(y)
  other_x = math.floor(other_x)
  other_y = math.floor(other_y)

  self:set_position(other_x, other_y)
  other_dot:set_position(x, y)
end

-- @note DotSwap
KCP.UI.DotSwap = { source = nil }

function KCP.UI.DotSwap:start(source)
  self["source"] = source
  KCP.UI.Cursor.set("Crosshairs")
end

function KCP.UI.DotSwap:finish(target)
  if(self["source"] == target) then return false end

  self["source"]:swap_position_with(target)
  KCP.UI.Dot.share_positions()
  KCP.UI.DotSwap:reset()
end

function KCP.UI.DotSwap:reset()
  KCP.UI.Cursor.set(nil)
  self["source"] = nil
end

function KCP.UI.DotSwap:is_in_progress()
  return (self["source"] ~= nil)
end

-- @note "Immediately upon calling StartMoving(),
--        the frame will be de-anchored from any other frame it was previously anchored to"
-- @read https://wowwiki.fandom.com/wiki/API_Frame_StartMoving
KCP.UI.Dot.DragHelper = {
  start_at_relative = nil,
  start_at_absolute = nil,
  end_at_absolute = nil
}

function KCP.UI.Dot.DragHelper:start(frame)
  self.start_at_relative = KCP.UI.Dot.DragHelper.get_point(frame)
  frame:StartMoving();
  self.start_at_absolute = KCP.UI.Dot.DragHelper.get_point(frame)
  frame.isMoving = true;
end

function KCP.UI.Dot.DragHelper:stop(dot, frame)
  self.end_at_absolute = KCP.UI.Dot.DragHelper.get_point(frame)
  KCP.UI.Cursor.set(nil)
  frame:StopMovingOrSizing();
  frame.isMoving = false;

  local delta = KCP.UI.Dot.DragHelper.get_delta(
    self.start_at_absolute,
    self.end_at_absolute
  )

  local target_x = math.floor(self.start_at_relative.dx - delta.dx)
  local target_y = math.floor(self.start_at_relative.dy - delta.dy)

  dot:set_position(target_x, target_y)
  KCP.UI.Dot.share_positions()
end

function KCP.UI.Dot.DragHelper.get_point(frame)
  local point, relative_to, relative_point, dx, dy = frame:GetPoint()

  return {
    point = point,
    relative_to = relative_to,
    relative_point = relative_point,
    dx = dx,
    dy = dy,
  }
end

function KCP.UI.Dot.DragHelper.get_delta(point, other_point)
  return {
    dx = (point.dx - other_point.dx),
    dy = (point.dy - other_point.dy)
  }
end
