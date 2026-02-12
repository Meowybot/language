local meowy

meowy.uf = {}

meowy.reserved = {}

function meowy.reserved['define'](line, d)
  local luas = ""
  luas = luas .. line[2] .. " = function("
  if #line > 3 then
    for i = 3, #line - 1 do
      luas = luas .. line[i]
      if i < #line - 1 then
        luas = luas .. ", "
      end
    end
  end
  luas = luas .. ")" .. "\n"
  return luas
end

function meowy.reserved['}'](line, d)
  local luas = ""
  luas = luas .. "end" .. "\n"
  return luas
end


meowy.funcs = {}


meowy.specialFuncs = {}


meowy.specialWords = {}

meowy.specialWords["true"] = "true"
meowy.specialWords["false"] = "false"


function meowy.loadFile(filename, isLove)
  local itfunc = io.lines
  if isLove then
    itfunc = love.filesystem.lines
  end
  local t = {}
  for line in itfunc(filename) do
    local l = {}
    for word in string.gmatch(line, "%S+") do
      table.insert(l, word)
    end
    table.insert(t, l)
  end
  return t
end

function meowy.toLuaArg(arg)
  if tonumber(arg) then
    return arg
  elseif string.sub(arg, 1, 1) == '"' then
    return arg
  elseif meowy.specialWords[arg] then
    return meowy.specialWords[arg]
  else
    return "nil"
  end
end

function meowy.toLuaFunc(line, d)
  local luas = ""
  if not d.onlyargs then
    if meowy.uf[line[1]] then
      luas = luas .. "meowy.uf['" .. line[1] .. "']("
    elseif meowy.specialFuncs[line[1]] then
      return meowy.specialFuncs[line[1]](line, {})
    else
      luas = luas .. "meowy.funcs['" .. line[1] .. "']("
    end
  end
  local isNested = false
  local NestStart = 0
  local NestEnd = 0
  local NestAmount = 0
  local hasstring = false
  local currstrig = ""
  for i = 2, #line do
    if not isNested then
      if string.sub(line[i], 1, 1) == "(" then
        isNested = true
        NestStart = i
        NestAmount = 1
        if string.sub(line[i], -1, -1) == ")" then
          NestEnd = i
          NestAmount = 0
          break
        end
      else
        --make the code do silly stuff
      end
    else
      if string.sub(line[i], -1, -1) == ")" then
        NestAmount=NestAmount - 1
        if NestAmount == 0 then
          NestEnd = i
          break
        else
          local j = 1
          local stillend = false
          while NestAmount > 0 do
            if string.sub(line[i], -j, -j) == ")" then
              NestAmount = NestAmount - 1
              if NestAmount == 0 then
                NestEnd = i
                stillend = true
                break
              end
            else
              break
            end
            j = j + 1
          end
          if stillend then
            break
          end
        end
      elseif string.sub(line[i], 1, 1 == "(" and NestAmount > 0 then
        NestAmount = NestAmount + 1
      end
    end
  end
  if isNested then
    local newlinr = {}
    if NestStart == NestEnd then
      table.insert(newlinr, string.sub(line[NestStart], 2, -2))
    elseif NestEnd - Neststart == 1 then
      newlinr[1] = string.sub(line[NestStart], 2, -1)
      newlinr[2] = string.sub(line[NestEnd], 1, -2)
    else
      newlinr[1] = string.sub(line[NestStart], 2, -1)
      for i = NestStart + 1, NestEnd - 1 do
        table.insert(newlinr, line[i])
      end
      table.insert(newlinr, string.sub(line[NestEnd], 1, -2))
    end
    luas = luas .. meowy.toLuaFunc(newlinr, {})
    if NestEnd ~= #line then
      luas = luas .. ", "
      local newnewlinr = {}
      newnewlinr[1] = line[1]
      for i = NestEnd + 1, #line do
        table.insert(newnewlinr, line[i])
      end
      luas = luas .. meowy.toLuaFunc(newnewlinr, {onlyargs = true})
    end
  end
  luas = luas .. ")" .. "\n"
  return luas
end

function meowy.toLua(t)
  local luas = ""
  for li, line in ipairs(t) do
    if meowy.reserved[line[1]] then
      luas = luas .. meowy.reserved[line[1]](line, {})
    else
      luas = luas .. meowy.toLuaFunc(line, {})
    end
  end
end

return meowy