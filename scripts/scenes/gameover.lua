scenes.gameover = object:new({
  init = function(self)
    crossfade_music(15)
    player:disable()
    player.iframes = 60
    player:animate({ y = 144 }, 60, linear, function()
      if (player.projectile) player.projectile:destroy()
    end)

    input_enabled = false
    level_text = entities.level_text:new { text = "mission failed" }
    level_text:animate({ height = 16 }, 15, easeoutquad)

    wait(120, function()
      input_enabled = true
    end)
  end,

  update = function(self)
    if input_enabled and btnp(5) then
      input_enabled = false
      crossfade_music(0)
      wait(60, function()
        load_scene "title"
      end)
    end
  end,

  draw = function(self)
    if input_enabled then
      print_centered("return to title", 108, 7)
      spr(11, 24, 108)
      spr(11, 95, 108, 1, 1, true)
    end
  end,
})