# TODOs

## Persistent Data

  * Sort by timestamp
  * Use LibDeflate:CompressForWowChannel

## Sharable Data

  * C_ChatInfo.SendAddonMessage
  * ShowFriends(), GetNumFriends(), GetFriendInfo(index)
  * FRIENDLIST_UPDATE (many things, including friend coming online; adding a friend)
  * GetGuildInfo(unit), GetGuildInfoText(), GetGuildRosterInfo(index), GuildInfo(), GuildRoster(), IsInGuild()
  * ```
self:SetAllPoints(GuildMicroButton)
self:RegisterEvent("GUILD_ROSTER_UPDATE")
self:RegisterEvent("CHAT_MSG_SYSTEM");
self:RegisterEvent("PLAYER_ENTERING_WORLD");
self.friendon  = gsub(gsub(ERR_FRIEND_ONLINE_SS,"[%^%$%(%)%%%.%[%]%*%+%-%?]","%%%1"),"%%%%s",".+")
self.mergebug  = gsub(gsub(ERR_CHAT_PLAYER_NOT_FOUND_S, "[%^%$%(%)%%%.%[%]%*%+%-%?]","%%%1"),"%%%%s",".+")
if (event == "CHAT_MSG_SYSTEM") then
  local system_msg=...
  if ((strmatch(system_msg, self.friendon) ~= system_msg) and
      (strmatch(system_msg, self.friendoff) ~= system_msg) and
      (strmatch(system_msg, self.mergebug) ~= system_msg)) then
    return
  end
elseif (event == "PLAYER_ENTERING_WORLD") then
```

## Friends' Data

  * ShowFriends(), GetNumFriends(), GetFriendInfo(index)
  * FRIENDLIST_UPDATE (many things, including friend coming online; adding a friend)
  * GetGuildInfo(unit), GetGuildInfoText(), GetGuildRosterInfo(index), GuildInfo(), GuildRoster(), IsInGuild()
  * Limit it to no more to no more than 20 bins/lines, including your own

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
