KCP.UI.CthunFrame = {}
KCP.UI.CthunFrame.__index = KCP.UI.CthunFrame

KCP.UI.CthunFrame.Default_Width = 534
KCP.UI.CthunFrame.Default_Height = 534

local useNewBackdrop = false

local backdrop = {
  bgFile = "Interface\\AddOns\\KoboCthunPlanner\\Images\\CThun_Positioning.tga",
  edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
  tile = false,
  edgeSize = 32,
  insets = {
    left = 12,
    right = 12,
    top = 12,
    bottom = 12
  }
}

if(useNewBackdrop) then
  backdrop["bgFile"] = nil
end

-- Create Main Frame
function KCP.UI.CthunFrame.create()
  local self = {}

  setmetatable(self, KCP.UI.CthunFrame)

  self.tiles = {}
  self.frame = nil
  self.resize_area = nil

  self.frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
  self.frame:Hide()
  self.frame:EnableMouse(true)
  self.frame:SetMovable(true)
  self.frame:SetFrameStrata("FULLSCREEN")
  self.frame:SetHeight(KCP.UI.CthunFrame.Default_Height)
  self.frame:SetWidth(KCP.UI.CthunFrame.Default_Width)
  self.frame:SetScale(1)
  self.frame:SetPoint("CENTER", 0, 0)
  self.frame:SetBackdrop(backdrop)
  self.frame:SetAlpha(1.00)
  self.frame.x = self.frame:GetLeft()
  self.frame.y = (self.frame:GetTop() - self.frame:GetHeight())

  if(useNewBackdrop) then self:add_map_textures() end

  -- @todo Replace w/ AceEvent
  self.frame:RegisterEvent("GROUP_JOINED")
  self.frame:RegisterEvent("GROUP_ROSTER_UPDATE")
  self.frame:SetScript("OnEvent", KCP.LIB.Events.handle)

  self.frame:SetScript("OnEnter", function()
    KCP.UI.Cursor.set_current()
  end)
  self.frame:SetScript("OnMouseDown", function(_, _)
    KCP.UI.DotSwap:reset()
  end)

  self.frame:SetResizable(true)
  self.frame:SetResizeBounds(KCP.UI.CthunFrame.Default_Width / 2.0, KCP.UI.CthunFrame.Default_Height / 2.0, KCP.UI.CthunFrame.Default_Width * 1.5, KCP.UI.CthunFrame.Default_Height * 1.5)

  self.resize_area = KCP.UI.ResizeArea.attach_to(self.frame)

  KCP.UI.OpacitySlider.attach_to(self.frame)
  KCP.UI.BackdropOpacitySlider.attach_to(self.frame)
  KCP.UI.Header.attach_to(self.frame)
  KCP.UI.HideButton.attach_to(self.frame)
  KCP.UI.ShareButton.attach_to(self.frame)

  return self
end

function KCP.UI.CthunFrame:show()
  self.frame:Show()
  KCP.grid:refresh()
  self:resize()
end

function KCP.UI.CthunFrame:hide()
  self.frame:Hide()
end

-- Reset Position and scale
function KCP.UI.CthunFrame:reset()
  self.frame:SetHeight(KCP.UI.CthunFrame.Default_Height)
  self.frame:SetWidth(KCP.UI.CthunFrame.Default_Width)
  self.frame:SetScale(1)
  self.frame:ClearAllPoints();
  self.frame:SetPoint("CENTER", 0, 0)
end

-- Resize given frame
function KCP.UI.CthunFrame:resize()
  local scale = self.frame:GetWidth() / KCP.UI.CthunFrame.Default_Width
  local childrens = {self.frame:GetChildren()}

  for _, child in pairs(childrens) do
    if child ~= self.resize_area then
      child:SetScale(scale)
    end
  end

  for _, tile in pairs(self.tiles) do
    tile:SetScale(scale)
  end

  self.frame:SetHeight(KCP.UI.CthunFrame.Default_Height * scale)
end

-- private

function KCP.UI.CthunFrame:add_map_textures()
  self:create_map_texture(
    "3_7","TopRight", -10, -10,
    0.0, 4/6, 1/6, 1.0,
    12/6, 12/6
  )

  self:create_map_texture(
    "3_6","TopLeft", 10, -10,
    4/6, 1.0, 1/6, 1.0,
    12/6, 12/6
  )

  self:create_map_texture(
    "3_10","BottomLeft", 10, 10,
    4/6, 1.0, 0.0, 1/6,
    12/6, 12/6
  )

  self:create_map_texture(
    "3_11","BottomRight", -10, 10,
    0.0, 4/6, 0.0, 1/6,
    12/6, 12/6
  )
end

function KCP.UI.CthunFrame:create_map_texture(
  texture, position, ox, oy, left, right, top, bottom, scale
)
  local path = "Interface\\WorldMap\\AhnQiraj\\AhnQiraj" .. texture
  local width = (KCP.UI.CthunFrame.Default_Width / 2.0 * (right - left) * scale) - 10
  local height = (KCP.UI.CthunFrame.Default_Height / 2.0 * (bottom - top) * scale) - 10

  local tile = KCP.UI.append_partial_texture(
    self.frame,
    path,
    position,
    width,
    height,
    ox,
    oy,
    left,
    right,
    top,
    bottom
  )

  table.insert(self.tiles, tile)
end
