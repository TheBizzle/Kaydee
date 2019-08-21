# TODOs

## History Browser

  * Zone ID to name:
    * C_Map.GetMapInfo(C_Map.GetBestMapForUnit("player"))["name"]
    * OR: C_Map.GetMapInfo(mID)["name"]
  * Spell to name:
    * IF -665: Attack
    * ELSE: local spellName, spellRank = GetSpellInfo(spellID)
      if spellRank ~= nil then
            abilityName = spellName .. "(" .. L10N["Rank"] .. spellRank .. ")"
          else
            abilityName = spellName
          end

## Misc.

  * README
  * Translations
