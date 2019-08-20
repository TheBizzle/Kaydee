Kaydee = LibStub("AceAddon-3.0"):NewAddon("Kaydee", "AceConsole-3.0", "AceSerializer-3.0")
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
  Kaydee.db.profile.encounters = LibDeflate:CompressDeflate(Kaydee:Serialize(encountersDB))
end

-- () => Table[GUID, String]
function Kaydee.getGUIDToName()
  return guidToNameDB
end

-- (GUID, String) => Unit
function Kaydee.putGUIDToName(guid, name)
  guidToNameDB[guid] = name
  Kaydee.db.profile.guidToName = LibDeflate:CompressDeflate(Kaydee:Serialize(guidToNameDB))
end
