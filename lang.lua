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

function meowy.loadfile(filename, isLove)
  print("loading file")
  local itfunc
  if isLove then
    itfunc = love.filesystem.lines
  else
    itfunc = io.lines
  end
  for line in itfunc(filename) do
  end
end