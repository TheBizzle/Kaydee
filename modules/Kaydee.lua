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

-- (GUID) => Array[Encounter]
local function myCaredEncountersWith(guid)

  local myGUID     = UnitGUID("player")
  local encounters = {}
  local cares      = guidsICareAbout()

  for i, encounter in ipairs(Kaydee.allEncounters[guid] or {}) do
    if cares[encounter.winnerID] or cares[encounter.loserID] then
      table.insert(encounters, encounter)
    end
  end

  return encounters

end

-- (GUID, Array[Encounter]) => Array[Bin]
local function encountersToBins(guid, encounters)

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
        Kaydee.getGUIDToName()[id] or
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

-- () => Unit
function Kaydee.syncWithBuddies()

  local profile       = Kaydee.db.profile
  local db            = { encounters = profile.encounters, guidToName = profile.guidToName }
  local str           = Kaydee:Serialize(db)
  local compressed, _ = LibDeflate:CompressDeflate(str)
  local encoded       = LibDeflate:EncodeForWoWAddonChannel(compressed)

  if IsInGuild() then
    Kaydee:SendCommMessage("KAYDEE_DB_UPDATE", encoded, "GUILD", nil, "BULK")
  end

  for i = 1, GetNumFriends(), 1 do
    local name, _, _, _, isOnline = GetFriendInfo(i)
    if isOnline then
      Kaydee:SendCommMessage("KAYDEE_DB_UPDATE", encoded, "WHISPER", name, "BULK")
    end
  end

end

C_Timer.NewTicker(30 * 60, Kaydee.syncWithBuddies)

-- (GameTooltip) => Unit
local function handleTooltip(self)
  local unit = select(2, self:GetUnit())
  local guid = UnitGUID(unit)
  if UnitIsPlayer(unit) then
    local encounters = myCaredEncountersWith(guid)
    local bins       = encountersToBins(guid, encounters)
    for i, bin in ipairs(bins) do
      self:AddLine(binToString(bin))
    end
  end
end

GameTooltip:HookScript("OnTooltipSetUnit", handleTooltip)
