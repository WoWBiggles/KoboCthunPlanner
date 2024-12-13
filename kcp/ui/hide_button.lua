KCP.UI.HideButton = {}

function KCP.UI.HideButton.attach_to(frame)
  local button = CreateFrame("Button", nil, frame)
  button:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
  button:SetHeight(32)
  button:SetWidth(32)
  button:SetNormalTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Up")
  button:SetHighlightTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Highlight")
  button:SetPushedTexture("Interface\\Buttons\\UI-Panel-MinimizeButton-Down")

  button:SetScript("OnLoad", function()
    button:RegisterForClicks("AnyUp")
  end)

  button:SetScript( "OnClick", function()
    frame:Hide()
  end)
end
