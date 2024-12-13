KCP.UI.ShareButton = {}

function KCP.UI.ShareButton.attach_to(frame)
  local button = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
  button:SetPoint("TOPLEFT", frame, "TOPLEFT", 12, -12)
  button:SetHeight(24)
  button:SetWidth(64)
  button:SetText("Update")

  button:SetScript("OnLoad", function()
    button:RegisterForClicks("AnyUp")
  end)

  button:SetScript("OnClick", function()
    if IsInGroup() then
      if UnitIsGroupLeader("player") then
        KCP.alert("Sharing positions with raid")
        KCP.submit_event({ type = "SHARE" })
        KCP.UI.Dot.share_positions()
      else
        KCP.alert("Requesting positions from raid leader")
        KCP.submit_event({ type = "REQUEST_SHARE" })
      end
    else
      KCP.alert("You need to be in a raid to use this command.")
    end
  end)
end
