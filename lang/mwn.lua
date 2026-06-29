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
    local u = tonumber("0x"..v)
    local c
    local a
    if u > 0xFFFFFF then
      c = bit.rshift(bit.band(u, 0xFFFFFF00), 8)
      a = bit.band(u, 0xFF)
    else
      c = u
      a = 0xFF
    end
    return {
      __type = "color",
      r = 0
    }
  end
}

return mwn