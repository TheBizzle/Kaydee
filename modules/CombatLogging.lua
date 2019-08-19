local L10N = KaydeeUF.L10N

-- (Encounter) => Unit
local function saveEncounter(encounter)

  table.insert(Kaydee.db.profile.encounters, encounter)
  table.insert(Kaydee.myEncounters, encounter)

  if encounter.winnerID ~= UnitGUID("player") then
    Kaydee.addToOverlord(Kaydee.allEncounters, encounter.winnerID, encounter)
  end

  if encounter.loserID ~= UnitGUID("player") then
    Kaydee.addToOverlord(Kaydee.allEncounters, encounter.loserID, encounter)
  end

end

-- (Table[_, _], String) => Unit
local function handleCombatLogEvent(self, event)

  if event == "COMBAT_LOG_EVENT_UNFILTERED" then

    local timestamp, combatEvent = CombatLogGetCurrentEventInfo()

    if Kaydee.endsWith(combatEvent, "_DAMAGE") then

      local _, _, isHidingCaster
          , sourceGUID, sourceName, sourceFlags, sourceRaidFlags
          , destGUID, destName, destFlags, destRaidFlags = CombatLogGetCurrentEventInfo()

      local isPVP =
        (Kaydee.trim(sourceGUID) ~= "") and
        (Kaydee.trim(  destGUID) ~= "") and
        (GetPlayerInfoByGUID(sourceGUID) ~= nil) and
        (GetPlayerInfoByGUID(  destGUID) ~= nil)

      if isPVP then

        local damageAmount, overkillAmount, school
            , resistedAmount, blockedAmount, absorbedAmount, wasACrit

        local abilityName = nil

        if combatEvent == "SWING_DAMAGE" then

          _, _, _, _, _, _, _, _, _, _, _
          , damageAmount, overkillAmount, school
          , resistedAmount, blockedAmount, absorbedAmount, wasACrit = CombatLogGetCurrentEventInfo()

          abilityID = -665

        else

          _, _, _, _, _, _, _, _, _, _, _
          , spellID, spellName, spellSchool
          , damageAmount, overkillAmount, school
          , resistedAmount, blockedAmount, absorbedAmount, wasACrit = CombatLogGetCurrentEventInfo()

          abilityID = spellID

        end

        if overkillAmount >= 0 then

          local damageModifiers = {}

          if wasACrit then
            table.insert(damageModifiers, "crit")
          end

          if blockedAmount ~= nil then
            table.insert(damageModifiers, "block")
          end

          if absorbedAmount ~= nil then
            table.insert(damageModifiers, "absorb")
          end

          if resistedAmount ~= nil then
            table.insert(damageModifiers, "resist")
          end

          local killingBlow =
            { damageSourceID  = abilityID
            , damageAmount    = damageAmount
            , damageModifiers = damageModifiers
            }

          local encounter  =
            { winnerID    = sourceGUID
            , loserID     = destGUID
            , locationID  = C_Map.GetBestMapForUnit("player")
            , timestamp   = timestamp
            , killingBlow = killingBlow
            }

          saveEncounter(encounter)

        end

      end

    end

  end

end


local frame = CreateFrame("Frame")
frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
frame:SetScript("OnEvent", handleCombatLogEvent)
