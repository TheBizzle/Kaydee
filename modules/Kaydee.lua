local L10N = KaydeeUF.L10N

-- type GUID       = String
-- type MapID      = Number
-- type UnitString = String

-- type Modifier     = "crit"|"resist"|"block"|"absorb"
-- type KillingBlow  = { damageSourceID: Number, damageAmount: Number, damageModifiers: Array[Modifier] }
-- type Encounter    = { winnerID: GUID, loserID: GUID, locationID: MapID, timestamp: Number, killingBlow: KillingBlow }
-- type Bundle       = { version: String, combats = Array[Encounter] }
-- type Bin          = { subjectName: String, wins: Number, losses: Number, draws: Number }

-- () => Array[GUID]
local function guidsICareAbout()
  return { [UnitGUID("player")] = true }
end

-- (UnitString) => Array[Encounter]
local function myEncountersWith(unit)

  local myGUID     = UnitGUID("player")
  local guid       = UnitGUID(unit)
  local encounters = {}
  local cares      = guidsICareAbout()

  for i, encounter in ipairs(Kaydee.allEncounters[guid] or {}) do
    if cares[encounter.winnerID] or cares[encounter.loserID] then
      table.insert(encounters, encounter)
    end
  end

  return encounters

end

-- (UnitString, Array[Encounter]) => Array[Bin]
local function encountersToBins(unit, encounters)

  local guid = UnitGUID(unit)

  local bins = {}

  for i, encounter in ipairs(encounters) do

    local id = nil

    if encounter.winnerID == guid then
      id = encounter.loserID
    elseif encounter.loserID == guid then
      id = encounter.winnerID
    end

    if bins[id] == nil then

      -- If our client hasn't seen the GUID yet,
      -- we can't look up their info --Bizzle (8/19/19)
      local name =
        Kaydee.getNameByGUID(id) or
        Kaydee.db.profile.guidToName[id] or
        id

      bins[id] = { subjectName = name, wins = 0, losses = 0 }

    end

    local bin = bins[id]

    if guid == encounter.loserID then
      bin.wins = bin.wins + 1
    else
      bin.losses = bin.losses + 1
    end

    bins[id] = bin

  end

  return Kaydee.tableValues(bins)

end

-- (Bin) => String
local function binToString(bin)
  return bin.subjectName .. ": " .. bin.wins .. "/" .. bin.losses
end

-- (GameTooltip) => Unit
local function handleTooltip(self)
  local unit = select(2, self:GetUnit())
  if UnitIsPlayer(unit) then
    local encounters = myEncountersWith(unit)
    local bins       = encountersToBins(unit, encounters)
    for i, bin in ipairs(bins) do
      self:AddLine(binToString(bin))
    end
  end
end

GameTooltip:HookScript("OnTooltipSetUnit", handleTooltip)
