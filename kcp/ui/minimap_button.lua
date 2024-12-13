KCP.UI.MinimapButton = {}

-- Create minimap button using LibDBIcon
local miniButton = LibStub("LibDataBroker-1.1"):NewDataObject("KoboCthunPlanner", {
    type = "data source",
    text = "Kobo Cthun Planner",
    icon = "Interface\\ICONS\\Achievement_Boss_CThun",
    OnClick = function(self, btn)
        KCP.frame:show()
    end,
    OnTooltipShow = function(tooltip)
		if not tooltip or not tooltip.AddLine then
			return
		end

		tooltip:AddLine("Kobo Cthun Planner", nil, nil, nil, nil)
	end,
})

local icon = LibStub("LibDBIcon-1.0", true)
icon:Register("KoboCthunPlanner", miniButton, KCP.UI.MinimapButton)
icon:Show("KoboCthunPlanner")
