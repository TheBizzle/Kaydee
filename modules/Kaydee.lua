local L10N = KaydeeUF.L10N

local append      = Brazier.Array.append
local foldl       = Brazier.Array.foldl
local flattenDeep = Brazier.Array.flattenDeep
local forEach     = Brazier.Array.forEach
local map         = Brazier.Array.map
local toTable     = Brazier.Array.toTable

local pipeline    = Brazier.Function.pipeline

local values      = Brazier.Table.values

-- type GUID       = String
-- type MapID      = Number
-- type UnitString = String

-- type Modifier     = "crit"|"resist"|"block"|"absorb"
-- type KillingBlow  = { damageSourceID: Number, damageAmount: Number, damageModifiers: Array[Modifier] }
-- type Encounter    = { winnerID: GUID, loserID: GUID, locationID: MapID, timestamp: Number, killingBlow: KillingBlow }
-- type Bundle       = { version: String, combats = Array[Encounter] }
-- type Bin          = { subjectName: String, wins: Number, losses: Number }

-- () => Array[GUID]
local function guidsICareAbout()

  local myGUIDs = { UnitGUID("player") }

  local friendGUIDs = {}
  for i = 1, GetNumFriends(), 1 do
    local guid = (select(9, GetFriendInfo(i)))
    table.insert(friendGUIDs, guid)
  end

  local guildGUIDs = {}
  if IsInGuild() then
    GuildRoster()
    for j = 1, GetNumGuildMembers(), 1 do
      local guid = (select(17, GetGuildRosterInfo(j)))
      table.insert(guildGUIDs, guid)
    end
  end

  return
    pipeline(
      flattenDeep
    , map(function(x) return { x, true } end)
    , toTable
    )({ myGUIDs, friendGUIDs, guildGUIDs })

end

-- (GUID) => Array[Encounter]
local function myCaredEncountersWith(guid)

  local myGUID = UnitGUID("player")
  local cares  = guidsICareAbout()

  local aggregateCares =
    function(acc, encounter)
      if cares[encounter.winnerID] or cares[encounter.loserID] then
        return append(encounter)(acc)
      else
        return acc
      end
    end

  return foldl(aggregateCares)({})(Kaydee.allEncounters[guid] or {})

end

-- (GUID, Array[Encounter]) => Array[Bin]
local function encountersToBins(guid, encounters)

  local bins = {}

  local populateBinWith =
    function(encounter)

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

      if guid == encounter.loserID then
        bins[id].wins = bins[id].wins + 1
      else
        bins[id].losses = bins[id].losses + 1
      end

    end

  forEach(populateBinWith)(encounters)

  return values(bins)

end

-- (Array[Bin]) => Array[Bin]
local function organize(bins)

  local myName    = Kaydee.getNameByGUID(UnitGUID("player"))
  local myBin     = nil
  local otherBins = {}

  forEach(
    function(bin)
      if bin.subjectName == myName then
        myBin = bin
      else
        table.insert(otherBins, bin)
      end
    end
  )(bins)

  local function sortFunc(a, b)
    return (a.wins + a.losses) > (b.wins + b.losses)
  end

  table.sort(otherBins, sortFunc)
  table.insert(otherBins, 1, myBin)

  local out = {}
  for i = 1, math.min(20, getn(otherBins)), 1 do
    table.insert(out, otherBins[i])
  end

  return out

end

-- (Bin) => String
local function binToString(bin)
  return bin.subjectName .. ": " .. bin.wins .. "/" .. bin.losses
end

-- (GameTooltip) => Unit
local function handleTooltip(self)
  local unit = select(2, self:GetUnit())
  if unit ~= nil then
    local guid = UnitGUID(unit)
    if UnitIsPlayer(unit) then
      local encounters = myCaredEncountersWith(guid)
      local bins       = encountersToBins(guid, encounters)
      local filBins    = organize(bins)
      pipeline(map(binToString), forEach(function(x) self:AddLine(x) end))(filBins)
    end
  end
end

GameTooltip:HookScript("OnTooltipSetUnit", handleTooltip)
