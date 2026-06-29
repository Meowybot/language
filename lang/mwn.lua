local bit = require("bit")

local mwn = {}

mwn.datatypes = {
  ["string"] = function(v)
    return tostring(v)
  end,
  ["number"] = function(v)
    return tonumber(v) or 0
  end,
  ["boolean"] = function(v)
    return v ~= "false"
  end,
  ["color"] = function(v)
    
  end
}

return mwn