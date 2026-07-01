local bit = require("bit")

local mwn = {}

function mwn.toTable(name)
  
  -- variable initialization
  local t = {}
  local currlinen = 0
  local currsec = nil
  local nests = {}
  nests[0] = "section"
  local nestn = {}
  nestn[0] = "SECTION"
  local nesta = #nests
  
  -- every line, do this:
  for lineu in love.filesystem.lines(name) do
    currlinen = currlinen + 1
    local line = string.gsub(lineu, "^%s+", "")
    local firstchar = string.sub(line,1,1)
    local secndchar = string.sub(line,2,2)
    local lastchar = string.sub(line,-1,-1)
    local midstring = string.sub(line,2,-3)
    
    -- if this aint in a section
    if not currsec then
      
      -- make it be a section
      if firstchar == "#" then
        currsec = midstring
        t[currsec] = t[currsec] or {}
      end
      
      -- if this be in a section
    else
      
      -- section talk end
    end
    
    -- stop doing every line
  end
end

function mwn.toMeowin(t)
end

return mwn