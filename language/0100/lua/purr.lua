local purr = {}

--[[
  purr is new version of meowy, now gonna use gmatch and ", " instead of whitespace
  GOOD LANGUAGE
--]]

purr.reser = {}
purr.reser["define"] = function(l)
end

purr.funcs = {}
purr.funcs["print"] = function(...)
  local s = ""
  for _, v in ipairs({...}) do
    s = s .. v .. "  "
  end
  print(s)
end

local function deletestartspace(str)
  return (str:gsub("^%s+", ""))
end

local function splitVariable(input)
    local name, value = input:match("(.-) (.*)")
    return {(name or input), (value or "")}
end

function purr.loadFile(filename, isLove)
  local itfunc
  if isLove then
    itfunc = love.filesystem.lines
  else
    itfunc = io.lines
  end
  local t = {}
  for line in itfunc(filename) do
    local s = deletestartspace(line)
    table.insert(t, splitVariable(s))
  end
  return t
end

function purr.toLuaFunc(l)
end

function purr.toLua(t)
  local luas = ""
  for i, v in ipairs(t) do
    if meowy.reser[v[1]] then
      luas = luas .. purr.reser[v[1]](l)
    else
      luas = luas .. purr.toLuaFunc(v)
    end
  end
  return luas
end

return purr