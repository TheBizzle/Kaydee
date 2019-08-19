-- á | \195\161
-- ó | \195\179
-- ú | \195\186

if GetLocale() ~= "esMX" and GetLocale() ~= "esES" then return end

local L10N =
  {
    ["Unknown command"] = "Comando desconocido"
  }

KaydeeUF = select(2, ...)
KaydeeUF.L10N  = setmetatable(L10N, { __index = KaydeeUF.L10N })
