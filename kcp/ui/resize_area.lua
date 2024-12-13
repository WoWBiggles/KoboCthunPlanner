KCP.UI.ResizeArea = {}

-- Attach Resize Area
function KCP.UI.ResizeArea.attach_to(parent)
  local resize_frame = CreateFrame("Frame", nil, parent)
  resize_frame:SetPoint("BottomRight", parent, "BottomRight", -8, 7)
  resize_frame:SetWidth(32)
  resize_frame:SetHeight(32)
  resize_frame:SetFrameLevel(parent:GetFrameLevel() + 7)
  resize_frame:EnableMouse(true)

  local resizetexture = resize_frame:CreateTexture(nil, "Artwork")
  resizetexture:SetPoint("TopLeft", resize_frame, "TopLeft", 0, 0)
  resizetexture:SetWidth(32)
  resizetexture:SetHeight(32)
  resizetexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
  resizetexture:SetVertexColor(0, 0, 0)

  resize_frame:SetScript("OnEnter", function()
    resizetexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    resizetexture:SetVertexColor(1, 1, 1)
  end)

  resize_frame:SetScript("OnLeave", function()
    resizetexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    resizetexture:SetVertexColor(0, 0, 0)
  end)

  resize_frame:SetScript("OnMouseDown", function(_, button)
    if button == "RightButton" then
      parent:SetWidth(KCP.UI.CthunFrame.Default_Width)
      parent:SetHeight(KCP.UI.CthunFrame.Default_Height)
    else
      resizetexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
      parent:StartSizing("Right")
    end
  end)

  resize_frame:SetScript("OnMouseUp", function(self)
    local x, y = GetCursorPosition()
    local fx = self:GetLeft() * self:GetEffectiveScale()
    local fy = self:GetBottom() * self:GetEffectiveScale()
    if x >= fx and x <= (fx + self:GetWidth()) and y >= fy and y <= (fy + self:GetHeight()) then
      resizetexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
    else
      resizetexture:SetTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    end
    parent:StopMovingOrSizing()
  end)

  local scrollframe = CreateFrame("ScrollFrame", nil, parent)
  scrollframe:SetWidth(KCP.UI.CthunFrame.Default_Width)
  scrollframe:SetHeight(KCP.UI.CthunFrame.Default_Height)
  scrollframe:SetPoint("Topleft", parent, "Topleft", 0, 0)

  parent:SetScript("OnSizeChanged", function()
    KCP.frame:resize()
  end)

  return resize_frame
end
