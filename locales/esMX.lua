-- á | \195\161
-- ó | \195\179
-- ú | \195\186

if GetLocale() ~= "esMX" and GetLocale() ~= "esES" then return end

local L10N =
  { ["a#"]                   = "un"
  , ["absorbed"]             = "absorbido"
  , ["a crit on"]            = "un crítico con"
  , ["and"]                  = "y"
  , ["Attack (swing)"]       = "Ataque"
  , ["blocked"]              = "obstruido"
  , ["Close"]                = "Cerrar"
  , ["damage#"]              = "puntos de daño"
  , ["defeated_bythem"]      = "derrotó"
  , ["defeated_byyou"]       = "derrotaste"
  , ["No modifiers"]         = "No modificadores"
  , ["Partially"]            = "Parcialmente"
  , ["Rank"]                 = "Rango"
  , ["resisted"]             = "resistido"
  , ["Unknown command"]      = "Comando desconocido"
  , ["with"]                 = "con"
  , ["you_accusative"]       = "te"
  , ["you_nominative"]       = "tú"
  , ["Your History"]         = "Tu historia"
  }

KaydeeUF = select(2, ...)
KaydeeUF.L10N  = setmetatable(L10N, { __index = KaydeeUF.L10N })
