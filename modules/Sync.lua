-- (String, String, String, String) => Unit
local function handleDBUpdate(messagePrefix, message, distType, senderName)

  local decoded         = LibDeflate:DecodeForWoWAddonChannel(message)
  local decompressed    = LibDeflate:DecompressDeflate(decoded)
  local _, deserialized = Kaydee:Deserialize(decompressed)

  local _, encounters = Kaydee:Deserialize(LibDeflate:DecompressDeflate(deserialized.encounters))
  local _, guidToName = Kaydee:Deserialize(LibDeflate:DecompressDeflate(deserialized.guidToName))

  local function dumpArr(arr)
    local acc = ""
    for i, x in ipairs(arr) do
      acc = acc .. x
      if i ~= getn(arr) then
        acc = acc .. ","
      end
    end
    return acc
  end

  local function encounterToKey(e)
    return         e.winnerID                     .. "_"
        ..         e.loserID                      .. "_"
        ..         e.killingBlow.damageSourceID   .. "_"
        ..         e.killingBlow.damageAmount     .. "_"
        .. dumpArr(e.killingBlow.damageModifiers)
  end

  local encountersDB = Kaydee.getEncounters()
  local guidToName   = Kaydee.getGUIDToName()

  local function anyTemporallyNearby(db, e)
    for i, encounter in ipairs(db) do
      if math.abs(encounter.timestamp - e.timestamp) < 10 then
        return true
      end
    end
    return false
  end

  local encounterSet = {}
  for i, encounter in ipairs(encountersDB) do
    encounterSet[encounterToKey(encounter)] = true
  end

  -- Some things are absolute, and some are not.
  -- The timestamp is not absolute.  They can differ
  -- a bit.  So we allow about 10 seconds of mismatch.
  -- --TheBizzle (8/20/19)
  for i, encounter in ipairs(encounters) do
    if not (
         encounterSet[encounterToKey(encounter)] and
         anyTemporallyNearby(encountersDB, encounter)
       ) then
        Kaydee.putEncounter(encounter)
        Kaydee.addToOverlord(Kaydee.allEncounters, encounter.winnerID, encounter)
        Kaydee.addToOverlord(Kaydee.allEncounters, encounter.loserID, encounter)
    end
  end

  for guid, name in pairs(guidToName) do
    guidToName[guid] = name
  end

end

Kaydee:RegisterComm("KAYDEE_DB_UPDATE", handleDBUpdate)

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
