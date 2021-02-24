scenes.credits = object:new({
  init = function(self)
    player:animate({ x = 52, y = 76 }, 60, easeoutovershoot)
    entities.gate_with_button:new()
  end,

  update = function(self)
    if btnp(5) then
      load_scene "title"
    end
  end,

  draw = function(self)
    local credits = {
      { "art code sfx", "@kevinthompson" },
      { "music", "@gruber_music" }
    }

    local offset = 0
    local origin = 48 - ((#credits - 1) * 24)

    for credit in all(credits) do
      print_centered(credit[1], origin + offset, 5)
      print_centered(credit[2], origin + offset + 8, 7)
      offset += 24
    end

    print_centered("/    /", 24, 6)
    print_centered("return to title", 108, 7)
    spr(11, 24, 108)
    spr(11, 95, 108, 1, 1, true)
  end,
})