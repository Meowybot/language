local meowy

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


function meowy.toLuaFunc(line, d)
  --please help
return meowy