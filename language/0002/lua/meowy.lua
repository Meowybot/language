local meowy

meowy.reserved = {}

function meowy.reserved['define'](line, luas, d)
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
end


meowy.funcs = {}


meowy.specialFuncs = {}


meowy.specialWords = {}

return meowy