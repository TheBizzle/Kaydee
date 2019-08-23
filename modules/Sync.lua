local exists  = Brazier.Array.exists
local foldl   = Brazier.Array.foldl
local forEach = Brazier.Array.forEach
local map     = Brazier.Array.map
local toTable = Brazier.Array.toTable

local pipeline = Brazier.Function.pipeline

-- (String, String, String, String) => Unit
function Kaydee.handleDBUpdate(messagePrefix, message, distType, senderName)

  local decoded         = LibDeflate:DecodeForWoWAddonChannel(message)
  local decompressed    = LibDeflate:DecompressDeflate(decoded)
  local _, deserialized = Kaydee:Deserialize(decompressed)

  local _, encounters = Kaydee:Deserialize(LibDeflate:DecompressDeflate(deserialized.encounters))
  local _, guidToName = Kaydee:Deserialize(LibDeflate:DecompressDeflate(deserialized.guidToName))

  local function encounterToKey(e)
    return              e.winnerID                     .. "_"
        ..              e.loserID                      .. "_"
        ..              e.killingBlow.damageSourceID   .. "_"
        ..              e.killingBlow.damageAmount     .. "_"
        .. table.concat(e.killingBlow.damageModifiers, ",")
  end

  local encountersDB = Kaydee.getEncounters()
  local guidToName   = Kaydee.getGUIDToName()

  -- Some things are absolute, and some are not.
  -- The timestamp is not absolute.  They can differ
  -- a bit.  So we allow about 10 seconds of mismatch.
  -- --TheBizzle (8/20/19)
  local function anyTemporallyNearby(db, e)
    return exists(
      function(encounter)
        return math.abs(encounter.timestamp - e.timestamp) < 10
      end
    )(db)
  end

  local encounterSet =
    pipeline(
      map(encounterToKey)
    , map(function(key) return { key, true } end)
    , toTable
    )(encountersDB)

  local addNews =
    function(encounter)
      if not (
           encounterSet[encounterToKey(encounter)] and
           anyTemporallyNearby(encountersDB, encounter)
         ) then
          Kaydee.putEncounter(encounter)
          Kaydee.addToOverlord(Kaydee.allEncounters, encounter.winnerID, encounter)
          Kaydee.addToOverlord(Kaydee.allEncounters, encounter. loserID, encounter)
      end
    end

  forEach(addNews)(encounters)

  for guid, name in pairs(guidToName) do
    Kaydee.putGUIDToName(guid, name)
  end

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
