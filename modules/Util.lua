-- [K, V] @ (Table[K, V]) => Array[V]
function Kaydee.tableValues(t)
  local out = {}
  for k, v in pairs(t) do
    table.insert(out, v)
  end
  return out
end

-- [Key, Value] @ (Table[Key, Array[Value]], Key, Value) => Unit
function Kaydee.addToOverlord(overlord, key, value)
  if overlord[key] ~= nil then
    table.insert(overlord[key], value)
  else
    overlord[key] = { value }
  end
end

-- (String) => String
function Kaydee.trim(str)
  return str:gsub("^%s*(.-)%s*$", "%1")
end

-- [T] @ (Array[T], T) => Boolean
function Kaydee.contains(haystack, needle)
  for i, x in ipairs(haystack) do
    if x == needle then
      return true
    end
  end
  return false
end

-- (String, String) => Boolean
function Kaydee.endsWith(str, suffix)
   return suffix == "" or str:sub(-#suffix) == suffix
end

-- (GUID) => String?
function Kaydee.getNameByGUID(guid)
  if GetPlayerInfoByGUID(guid) ~= nil then
    _, _, _, _, _, name, server = GetPlayerInfoByGUID(guid)
    return name
  else
    return nil
  end
end
