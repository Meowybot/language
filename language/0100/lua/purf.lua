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
  for i, v in ipairs(t) do
    if not currsec then
      if string.sub(v, 1, 1) == "#" then
        currsec = string.sub(v, 2, -3)
        r[currsec] = r[currsec] or {}
      end
    else
      if v == "}" then
        currsec = nil
      else
        if string.sub(v, 1, 1) == "*" then
          --this
        end
      end
    end
  end
  return r
end

return purf