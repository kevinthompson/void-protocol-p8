function log(any, overwrite)
  printh(tostr(any), logfile or "log", overwrite)
end

_tostr = tostr

function tostr(any, prefix)
  prefix = prefix or ""

  if type(any) == "table" then
    local str="{"
    local add_comma=false

    for k,v in pairs(any) do
      str=str..(add_comma and "," or "")
      str=str.."\n  "..prefix..k.." = "..tostr(v, "  ")
      add_comma=true
    end

    return str.."\n"..prefix.."}"
  else
    return _tostr(any)
  end
end