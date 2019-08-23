local L10N = KaydeeUF.L10N

local forEach = Brazier.Array.forEach

local helpLines =
  { "Kaydee"
  , "- help"
  , "- sync"
  }

-- () => Unit
function Kaydee:SlashKaydee(input)

  local _, _, command, args = string.find(input, "%s*(%w+)%s?(.*)")

  if command == "" or command == nil or command == "help" then
    forEach(print)(helpLines)
  elseif command == "sync" then
    Kaydee.syncWithBuddies()
  elseif command == "history" then
    Kaydee.toggleHistory()
  else
    print(L10N["Unknown command"] .. ": " .. command)
  end

end
