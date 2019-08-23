-- ä | \195\164
-- ü | \195\188
-- ß | \195\159

if GetLocale() ~= "deDE" then return end

local L10N =
  { ["a#"]                   = "einem"
  , ["absorbed"]             = "absorbiert"
  , ["a crit on"]            = "einem Krit bei"
  , ["and"]                  = "und"
  , ["Attack (swing)"]       = "Angriff"
  , ["blocked"]              = "verstopft"
  , ["Close"]                = "Schlie\195\159en"
  , ["damage#"]              = "Schadenpunkte"
  , ["defeated_bythem"]      = "besiegte"
  , ["defeated_byyou"]       = "besiegtest"
  , ["No modifiers"]         = "Keine Modifikatoren"
  , ["Partially"]            = "Teilweise"
  , ["Rank"]                 = "Rang"
  , ["resisted"]             = "resistiert"
  , ["Unknown command"]      = "Unbekannter Befehl"
  , ["with"]                 = "mit"
  , ["you_accusative"]       = "dich"
  , ["you_nominative"]       = "du"
  , ["Your History"]         = "Deine Geschichte"
  }

KaydeeUF = select(2, ...)
KaydeeUF.L10N  = setmetatable(L10N, { __index = KaydeeUF.L10N })
