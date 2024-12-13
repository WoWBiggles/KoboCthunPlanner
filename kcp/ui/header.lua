KCP.UI.Header = {}

function KCP.UI.Header.attach_to(parent)
  local header = CreateFrame("Frame", nil, parent, "BackdropTemplate")
  header:SetPoint("TOP", parent, "TOP", 0, 12)
  header:SetWidth(300)
  header:SetHeight(64)

  header:SetScript("OnMouseDown", function()
    parent:StartMoving("TOPLEFT")
    parent:SetUserPlaced(true)
  end)

  header:SetScript("OnMouseUp", function()
    parent:StopMovingOrSizing()
  end)
end
