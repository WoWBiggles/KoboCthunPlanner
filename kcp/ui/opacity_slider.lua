KCP.UI.OpacitySlider = {}

function KCP.UI.OpacitySlider.attach_to(parent)
  local slider = CreateFrame("Slider", nil, parent, "OptionsSliderTemplate")
  slider:SetPoint("BottomLeft", parent, "BottomLeft", 20, 20)
  slider:SetMinMaxValues(0.05, 1.00)
  slider:SetValue(1.00)
  slider:SetValueStep(0.05)

  slider["Low"]:SetText("5%")
  slider["High"]:SetText("100%")
  slider["Text"]:SetText("Opacity")

  slider:SetScript("OnValueChanged", function()
    local value = slider:GetValue()
    parent:SetAlpha(value)
  end)
end

KCP.UI.BackdropOpacitySlider = {}

function KCP.UI.BackdropOpacitySlider.attach_to(parent)
  local slider = CreateFrame("Slider", nil, parent, "OptionsSliderTemplate")
  slider:SetPoint("BottomLeft", parent, "BottomLeft", 20, 50)
  slider:SetMinMaxValues(0.05, 1.00)
  slider:SetValue(1.00)
  slider:SetValueStep(0.05)

  slider["Low"]:SetText("5%")
  slider["High"]:SetText("100%")
  slider["Text"]:SetText("Background Opacity")

  slider:SetScript("OnValueChanged", function()
    local value = slider:GetValue()
    parent:SetBackdropColor(1, 1, 1, value)
  end)
end
