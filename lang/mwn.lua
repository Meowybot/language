local bit = require("bit")

local mwn = {}

mwn.datatypes = {
  to,
  from,
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
      r = (bit.rshift(bit.band(c, 0xFF0000), 16))/255,
      g = (bit.rshift(bit.band(c, 0xFF00), 8))/255,
      b = (bit.band(c, 0xFF))/255,
      a = a/255
    }
  end
}

return mwn