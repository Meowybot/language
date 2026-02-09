local meowy = {}
meowy.reservedstrings = {
["if"] = true,
["?"] = true,
["define"] = true,
["}"] = true,
["while"] = true,
["]"] = true,
["true"] = true,
["false"] = true,
["return"] = true,
["break"] = true,
["var"] = true,
["local"] = true,
["arr"] = true,
["dic"] = true
}

meowy.funcs = {}

function meowy.funcs['print'](...)
  local s = ""
  for i, v in ipairs({...}) do
    s = s .. v .. "  "
  end
  print(s)
end

function meowy.funcs['add'](a, b)
  return a+b
end

function meowy.funcs['sub'](a, b)
  return a-b
end

function meowy.funcs['mul'](a, b)
  return a*b
end

function meowy.funcs['div'](a, b)
  return a/b
end

meowy.vars = {}
meowy.tab = {}
meowy.tab.arr = {}
meowy.tab.dic = {}
meowy.uf = {}
meowy.lf = {}

function meowy.loadfile(filename, isLove)
  local codepiece = {}
  print("loading file")
  local itfunc
  if isLove then
    itfunc = love.filesystem.lines
  else
    itfunc = io.lines
  end
  local i = 1
  for line in itfunc(filename) do
    codepiece[i] = {}
    for word in string.gmatch(line, "%S+") do
      table.insert(codepiece[i], word)
    end
    i = i + 1
  end
  return codepiece
end

function meowy.toLF(line)
  local luas = ""
  if meowy.uf[line[1]] then
    luas = luas .. "meowy.uf['" .. line[1] .. "']("
  elseif meowy.lf[line[1]] then
    luas = luas .. "meowy.lf['" .. line[1] .. "']("
  else
    luas = luas .. "meowy.funcs['" .. line[1] .. "']("
  end
  if #line >= 2 then
    local hasP = false
    local PaCaI = 1
    local PaCaS = 0
    for i = 2, #line do
      if hasP then
        if string.sub(line[i], -1, -1) == ")" then
          PaCaI = i
        end
      else
        if string.sub(line[i], 1, 1) == "(" then
          hasP = true
          PaCaS = i
        end
      end
      if not hasP then
        luas = luas .. line[i]
        if i ~= #line then
          luas = luas .. ", "
        end
      end
    end
    if hasP then
      local t = {}
      t[1] = string.sub(line[PaCaS], 2, -1)
      for i = PaCaS + 1, PaCaI - 1 do
        table.insert(t, line[i])
      end
      table.insert(t, string.sub(line[PaCaI], 1, -2)
      luas = luas .. meowy.toLF(t)
      if PaCaI ~= #line then
        luas = luas .. ", "
      end
    end
    if hasP then
      if #line > PaCaI then
        for i = PaCaI + 1, #line do
          luas = luas .. line[i]
          if i ~= #line then
            luas = luas .. ", "
          end
        end
      end
    end
  end
  luas = luas .. ")"
  return luas
end

function meowy.toLua(codepiece, isString)
  local nests = 1
  local nestids = {"main"}
  local luafunc = ""
  for li, line in ipairs(codepiece) do
    if not meowy.reservedstrings[line[1]] then
      luafunc = luafunc .. meowy.toLF(line) .. "\n"
    else
      if line[1] == "define" then
        luafunc = luafunc .. "function meowy.uf['" .. line[2] .. "']("
        if #line >= 4 then
          for i = 3, #line - 1 do
            luafunc = luafunc .. line[i]
            if i ~= #line - 1 then
              luafunc = luafunc .. ", "
            end
          end
        end
        luafunc = luafunc .. ")" .. "\n"
        nests = nests + 1
        table.insert(nestids, "def")
      elseif line[1] == "}" then
        if nestids[#nestids] == "def" then
          nests = nests - 1
          nestids[#nestids] = nil
        end
        luafunc = luafunc .. "end" .. "\n"
      elseif line[1] == "if" then
        luafunc = luafunc .. "if "
        if string.sub(line[2], 1, 1) == "(" then
          if (#line - 1) == 2 then
            luafunc = luafunc .. meowy.toLF({string.sub(line[2], 2, -2)})
          elseif (#line - 1) == 3 then
            luafunc = luafunc .. meowy.toLF({string.sub(line[2], 2, -1), string.sub(line[3], 1, -2)})
          else
            local subl = {}
            subl[1] = string.sub(line[2], 2, -1)
            for i = 3, #line - 2 do
              table.insert(subl, line[i])
            end
            table.insert(subl, string.sub(line[#line - 1], 1, -2))
            luafunc = luafunc .. meowy.toLF(subl)
          end
        else
          if #line >= 4 then
            error("Parentheses not opened at Meowy file, line " .. li .. ".")
          else
            luafunc = luafunc .. line[2]
          end
        end
        luafunc = luafunc .. " then"
      elseif line[1] == "?" then
      end
    end
  end
end