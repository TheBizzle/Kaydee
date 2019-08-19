Kaydee = LibStub("AceAddon-3.0"):NewAddon("Kaydee", "AceConsole-3.0")

Kaydee.myEncounters  = {} -- Array[Encounter]
Kaydee.allEncounters = {} -- Table[GUID, Array[Encounter]]

-- () => Unit
function Kaydee:OnInitialize()

  self.db = LibStub("AceDB-3.0"):New("KaydeeDB", {
    profile = {
      encounters = {}
    },
  })

  local myGUID = UnitGUID("player")

  for i, encounter in ipairs(self.db.profile.encounters) do

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
