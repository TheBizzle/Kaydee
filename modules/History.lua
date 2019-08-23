local L10N = KaydeeUF.L10N

local append   = Brazier.Array.append
local contains = Brazier.Array.contains
local foldl    = Brazier.Array.foldl
local map      = Brazier.Array.map
local sortBy   = Brazier.Array.sortBy

local pipeline = Brazier.Function.pipeline

local historyLines = {}

-- (KillingBlow) => String
local function getAbilityName(kb)
  if kb.damageSourceID == -665 then
    return "Attack (swing)"
  else
    local spellName, spellRank = GetSpellInfo(kb.damageSourceID)
    if spellRank ~= nil then
      return spellName .. "(" .. L10N["Rank"] .. spellRank .. ")"
    else
      return spellName
    end
  end
end

-- (KillingBlow) => String
local function getCritSnippet(kb)
  if contains("crit")(kb.damageModifiers) then
    return "a crit on "
  else
    return ""
  end
end

-- (KillingBlow) => String
local function getDespiteSnippet(kb)

  local wasResisted = contains("resist")(kb.damageModifiers)
  local wasBlocked  = contains( "block")(kb.damageModifiers)
  local wasAbsorbed = contains("absorb")(kb.damageModifiers)

  local modifiers = {}

  if wasResisted then
    table.insert(modifiers, "resisted")
  end

  if wasBlocked then
    table.insert(modifiers, "blocked")
  end

  if wasAbsorbed then
    table.insert(modifiers, "absorbed")
  end

  if getn(modifiers) == 0 then
    return "No modifiers"
  else
    return "Partially " .. table.concat(modifiers, " and ")
  end

end

-- (GUID) => String
local function getName(guid)
  if guid == UnitGUID("player") then
    return "YOU"
  else
    return Kaydee.getGUIDToName()[guid]
  end
end

-- (Encounter) => String
local function toRow(e)

  local kb             = e.killingBlow
  local abilityName    = getAbilityName(kb)
  local critSnippet    = getCritSnippet(kb)
  local despiteSnippet = getDespiteSnippet(kb)
  local winnerName     = getName(e.winnerID)
  local loserName      = getName(e.loserID)

  local settingRow =
    date("%x", e.timestamp) .. " | " .. date("%X", e.timestamp) .. " | " ..
      C_Map.GetMapInfo(e.locationID)["name"]

  local businessRow =
    winnerName .. " defeated " .. loserName .. " with " ..
      critSnippet .. "a " .. kb.damageAmount .. " damage " .. abilityName

  return settingRow .. "\n" .. businessRow .. "\n" .. despiteSnippet

end

-- () => Unit
function Kaydee.hideHistory()
  KaydeeHistoryFrame:Hide()
end

-- Number => Unit
function Kaydee.scrollHistory(scrollValue)

  local valueCount      = getn(historyLines)
  local maxRowsOnScreen = 6

  KaydeeHistorySlider:SetMinMaxValues(0, math.max(0, valueCount - maxRowsOnScreen))

  for lineNum = 1, maxRowsOnScreen do
    local linePlusOffset = lineNum + math.floor(scrollValue)
    local lineElem       = getglobal("KaydeeHistoryLine" .. lineNum)
    if lineElem ~= nil then
      if linePlusOffset <= valueCount then
        lineElem:SetText(historyLines[linePlusOffset])
        lineElem:Show()
      else
        lineElem:Hide()
      end
    end
  end

end

-- () => Unit
function Kaydee.showHistory()

  historyLines =
    pipeline(
      sortBy(function(x) return -x.timestamp end)
    , map(toRow)
    , foldl(function(acc, x) return append(x)(acc) end)({})
    )(Kaydee.myEncounters)

  KaydeeHistoryFrame:Show()

end

-- () => Unit
function Kaydee.toggleHistory()
  if KaydeeHistoryFrame:IsVisible() then
    Kaydee.hideHistory()
  else
    Kaydee.showHistory()
  end
end
