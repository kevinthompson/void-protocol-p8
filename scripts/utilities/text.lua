function print_centered(str, y, c)
  y = y or 64
  c = c or 7
  local x = 64-flr((#str * 4) / 2)
  print(str, x, y, c)
end

function pad(string, length)
  local string = tostr(string)
  local string_length = #string
  for i=1, length - string_length do
    string = "0" .. string
  end

  return string
end