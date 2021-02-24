scenes.title = object:new({
  init = function(self)
    level_id = 1
    menu_items = {}
    menu_item = 1
    breach_destabilized = false

    if (not player.projectile) player:spawn_projectile()
    player.health = player.max_health
    player:disable()
    player:animate({ x = 52, y = 68 }, 60, easeoutovershoot)
    space:animate({ speed = 0.5 }, 30, easeinquad)
    space.particles = false

    entities.gate_with_button:new({
      y = previous_scene != scenes.credits and -32 or -8
    }):animate({ y = -8 }, 30, easeoutquad)

    add(menu_items, {
      "start game",
      function()
        if tutorial_complete then
          music(player.projectile.charged and 7 or 1, 500)
          start_time = t()
          load_scene "transition"
        else
          load_scene "tutorial"
        end
      end
    })

    if tutorial_complete then
      add(menu_items, {
        "tutorial",
        function()
          load_scene "tutorial"
        end
      })
    end

    add(menu_items, {
      "credits",
      function()
        load_scene "credits"
      end
    })
  end,

  update = function(self)
    local items = menu_items
    local selected = menu_item

    if btnp(5) then
      menu_items[menu_item][2]()
    end

    if btnp(2) and menu_item > 1 then
      menu_item -= 1
      sfx(11)
    end

    if btnp(3) and menu_item < #menu_items then
      menu_item += 1
      sfx(12)
    end
  end,

  draw = function(self)
    spr(192, 38, 20, 6, 2)
    spr(224, 7, 40, 16, 2)

    for i = 0, #menu_items - 1 do
      local item = menu_items[i + 1]
      local selected = i + 1 == menu_item
      local y = 112 - (#menu_items / 2 * 8) + 8 * i
      print_centered(item[1], y, selected and 7 or 5)

      if selected then
        spr(11, 64 - ceil(#item[1] / 2) * 5 - 4, y)
        spr(11, 64 + ceil(#item[1] / 2) * 5 - 5, y, 1, 1, true)
      end
    end
  end
})