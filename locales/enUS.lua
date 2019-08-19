local L10N =
  { ["Attack/Swing"]         = "Attack/Swing"
  , ["Rank"]                 = "Rank"
  , ["Unknown command"]      = "Unknown command"
  , ["Unknown outcome type"] = "Unknown outcome type"
  }

KaydeeUF = select(2, ...)
KaydeeUF.L10N  = setmetatable(L10N, { __index = KaydeeUF.L10N })
