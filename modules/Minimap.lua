-- (LibIconDB.Tooltip) => Unit
local function handleMinimapTooltip(tooltip)
  tooltip:SetText("Kaydee")
  tooltip:Show()
end

-- (Table, String) => Unit
local function handleClick(self, button)
  if button == "LeftButton" then
    Kaydee.toggleHistory()
  end
end

local ldbConfig =
  {
    type = "data source",
    text = "KaydeeIcon",
    icon = "Interface\\Icons\\Ability_Warrior_Revenge",
    OnTooltipShow = handleMinimapTooltip,
    OnClick = handleClick,
  }

Kaydee.ldb = LibStub("LibDataBroker-1.1"):NewDataObject("KaydeeIcon", ldbConfig)

Kaydee.icon = LibStub("LibDBIcon-1.0")
