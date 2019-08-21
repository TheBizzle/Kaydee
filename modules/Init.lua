Kaydee = LibStub("AceAddon-3.0"):NewAddon("Kaydee", "AceComm-3.0", "AceConsole-3.0", "AceSerializer-3.0")
LibDeflate = LibStub:GetLibrary("LibDeflate")

Kaydee.myEncounters  = {} -- Array[Encounter]
Kaydee.allEncounters = {} -- Table[GUID, Array[Encounter]]

local encountersDB
local guidToNameDB

-- () => Unit
function Kaydee:OnInitialize()

  local emptyTable, _ = LibDeflate:CompressDeflate(Kaydee:Serialize({}))

  self.db = LibStub("AceDB-3.0"):New("KaydeeDB", {
    profile = {
      encounters = emptyTable
    , guidToName = emptyTable
    },
  })

  _, encountersDB = Kaydee:Deserialize(LibDeflate:DecompressDeflate(self.db.profile.encounters))
  _, guidToNameDB = Kaydee:Deserialize(LibDeflate:DecompressDeflate(self.db.profile.guidToName))

  local myGUID = UnitGUID("player")

  for i, encounter in ipairs(Kaydee.getEncounters()) do

    if encounter.winnerID == myGUID or encounter.loserID == myGUID then
      table.insert(Kaydee.myEncounters, encounter)
    end

    if encounter.winnerID ~= myGUID then
      Kaydee.addToOverlord(Kaydee.allEncounters, encounter.winnerID, encounter)
    end

    if encounter.loserID ~= myGUID then
      Kaydee.addToOverlord(Kaydee.allEncounters, encounter.loserID, encounter)
    end

  end

  self:RegisterChatCommand("kaydee", "SlashKaydee")

end

-- () => Array[Encounter]
function Kaydee.getEncounters()
  return encountersDB
end

-- (Encounter) => Unit
function Kaydee.putEncounter(encounter)
  table.insert(encountersDB, encounter)
end

-- () => Table[GUID, String]
function Kaydee.getGUIDToName()
  return guidToNameDB
end

-- (GUID, String) => Unit
function Kaydee.putGUIDToName(guid, name)
  guidToNameDB[guid] = name
end

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
        table.insert(encountersDB, encounter)
        Kaydee.addToOverlord(Kaydee.allEncounters, encounter.winnerID, encounter)
        Kaydee.addToOverlord(Kaydee.allEncounters, encounter.loserID, encounter)
    end
  end

  for guid, name in pairs(guidToName) do
    guidToNameDB[guid] = name
  end

end

Kaydee:RegisterComm("KAYDEE_DB_UPDATE", handleDBUpdate)

-- (Table[_, _], String) => Unit
local function handleLogout(self, event)
  if event == "PLAYER_LOGOUT" then
    Kaydee.db.profile.encounters = LibDeflate:CompressDeflate(Kaydee:Serialize(encountersDB))
    Kaydee.db.profile.guidToName = LibDeflate:CompressDeflate(Kaydee:Serialize(guidToNameDB))
  end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGOUT")
frame:SetScript("OnEvent", handleLogout)
