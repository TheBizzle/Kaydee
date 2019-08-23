local L10N =
  { ["a#"]                   = "a"
  , ["absorbed"]             = "absorbed"
  , ["a crit on"]            = "a crit on"
  , ["and"]                  = "and"
  , ["Attack (swing)"]       = "Attack (swing)"
  , ["blocked"]              = "blocked"
  , ["Close"]                = "Close"
  , ["damage#"]              = "damage"
  , ["defeated_bythem"]      = "defeated"
  , ["defeated_byyou"]       = "defeated"
  , ["No modifiers"]         = "No modifiers"
  , ["Partially"]            = "Partially"
  , ["Rank"]                 = "Rank"
  , ["resisted"]             = "resisted"
  , ["Unknown command"]      = "Unknown command"
  , ["with"]                 = "with"
  , ["you_accusative"]       = "you"
  , ["you_nominative"]       = "you"
  , ["Your History"]         = "Your History"
  }

KaydeeUF = select(2, ...)
KaydeeUF.L10N  = setmetatable(L10N, { __index = KaydeeUF.L10N })
