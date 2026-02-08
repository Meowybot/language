local meowy = {}
meowy.loadedlines = {}
meowy.reservedstrings = {
["if"] = true,
["?"] = true,
["define"] = true,
["while"] = true,
["true"] = true,
["false"] = true,
["return"] = true,
["break"] = true
}

meowy.funcs = {}

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

function meowy.toLua(codepiece, isString)
  local nests = 1
  local nestids = {"main"}
  local luafunc = ""
  for li, line in ipairs(codepiece) do
    if not meowy.reservedstrings[line[1]] then
      luafunc = luafunc .. line[1] .. "("
      if #line >= 2 then
        for i = 2, #line do
          luafunc = luafunc .. line[i] .. ", "
        end
      end
      luafunc = luafunc .. [[)
]]
    end
  end
end