local purf = {}

local function deletestartspace(str)
  return (str:gsub("^%s+", ""))
end

local function splitVariable(input)
    local name, value = input:match("(.-) (.*)")
    return {(name or input), (value or "")}
end

function purf.loadFile(filename, isLove)
  local itfunc
  if isLove then
    itfunc = love.filesystem.lines
  else
    itfunc = io.lines
  end
  local t = {}
  for line in itfunc(filename) do
    local s = deletestartspace(line)
    table.insert(t, s)
  end
  return t
end

function purf.toTable(t)
  local r = {}
  local currsec = nil
  local nests = {}
  local currnested = r
  for i, v in ipairs(t) do
    if not currsec then
      if string.sub(v, 1, 1) == "#" then
        currsec = string.sub(v, 2, -3)
        r[currsec] = r[currsec] or {}
        currnested = r[currsec]
      end
    else
      if v == "}" then
        currsec = nil
      else
        if string.sub(v, 1, 1) == "*" then
          table.insert(nests, "LIST"..string.sub(v, 2, -3))
          if #nests >= 1 then
            local y = string.sub(v, 2, -3)
            currnested[y] = currnested[y] or {____type = "list"}
          else
            local y = string.sub(v, 2, -3)
            r[currsec][y] = r[currsec][y] or {____type = "list"}
            currnested = r[currsec][y]
          end
        else
          local y = splitVariable(v)
          currnested[y[1]] = y[2]
        end
      end
    end
  end
  return r
end

return purf