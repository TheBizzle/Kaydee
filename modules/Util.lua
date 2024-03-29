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
