-- ä | \195\164
-- ü | \195\188

if GetLocale() ~= "deDE" then return end

local L10N =
  {
    ["Unknown command"] = "Unbekannter Befehl"
  }

KaydeeUF = select(2, ...)
KaydeeUF.L10N  = setmetatable(L10N, { __index = KaydeeUF.L10N })
