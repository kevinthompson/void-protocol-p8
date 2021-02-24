function set_menu_items(items)
  items = items or {}

  for i=1,5 do
    menuitem(i)
  end

  for item in all(items) do
    menuitem(item[1], item[2], item[3])
  end

  menuitem(5, debug and "debug off" or "debug on", function()
    debug = not debug
    set_menu_items(items)
  end)
end