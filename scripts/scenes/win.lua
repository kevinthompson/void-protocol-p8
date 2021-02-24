scenes.win = object:new({
  init = function(self)
    player:disable()
    if (ending != "eggplant") then
      player:animate({ x = 52, y = 72 }, 60, easeoutquad)
    else
      projectile.persist = false
    end

    input_enabled = false
    display_time = false

    local word = "contained"
    if (ending == "charged") word = "transmuted"
    if (ending == "eggplant") word = "destabilized"

    level_text = entities.level_text:new({ text = "breach " .. word .. "!" })
    level_text:animate({ height = 24 }, 15, easeoutquad, function()
      display_time = true
    end)

    wait(120, function()
      input_enabled = true
    end)
  end,

  update = function(self)
    if input_enabled and btnp(5) then
      load_scene "title"
      if (ending == "eggplant") then
        crossfade_music(0)
      end
    end
  end,

  draw = function(self)
    if input_enabled then
      if ending == "eggplant" then
        pal(8,7)
        pal(2,5)
      end

      print_centered("return to title", 108, 7)
      spr(11, 24, 108)
      spr(11, 95, 108, 1, 1, true)

      set_palette()
    end

    if display_time then
      local total_time = end_time - start_time
      local minutes = total_time \ 60
      local seconds = flr(total_time % 60)
      local ms = flr((total_time % 1) * 1000)
      print_centered("total time: " .. pad(minutes, 2) .. ":" .. pad(seconds, 2) .. "." .. pad(ms, 3), 34, 5)
    end
  end,
})