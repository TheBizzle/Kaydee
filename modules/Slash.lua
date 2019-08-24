local L10N = KaydeeUF.L10N

local forEach = Brazier.Array.forEach

local helpLines =
  { "Kaydee"
  , "- autosync disable"
  , "- autosync enable"
  , "- help"
  , "- history"
  , "- sync"
  }

-- () => Unit
function Kaydee:SlashKaydee(input)

  local _, _, command, args = string.find(input, "%s*(%w+%s?%w*)%s?(.*)")

  if command == "" or command == nil or command == "help" then
    forEach(print)(helpLines)
  elseif command == "autosync disable" then
    Kaydee.db.profile.syncIsEnabled = false
  elseif command == "autosync enable" then
    Kaydee.db.profile.syncIsEnabled = true
  elseif command == "history" then
    Kaydee.toggleHistory()
  elseif command == "sync" then
    Kaydee.syncWithBuddies()
  else
    print(L10N["Unknown command"] .. ": " .. command)
  end

end
