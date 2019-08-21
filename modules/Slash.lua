local L10N = KaydeeUF.L10N

local helpLines =
  { "Kaydee"
  , "- help"
  , "- sync"
  }

-- () => Unit
function Kaydee:SlashKaydee(input)

  local _, _, command, args = string.find(input, "%s*(%w+)%s?(.*)")

  if command == "" or command == nil or command == "help" then
    for i, line in ipairs(helpLines) do
      print(line)
    end
  elseif command == "sync" then
    Kaydee.syncWithBuddies()
  else
    print(L10N["Unknown command"] .. ": " .. command)
  end

end
