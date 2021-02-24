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

    if tutorial_complete then
      menu_items = {
        {
          "start game",
          function()
            music(player.projectile.charged and 7 or 1, 500)
            start_time = t()
            load_scene "transition"
          end
        },
        {
          "tutorial",
          function()
            load_scene "tutorial"
          end
        },
        {
          "credits",
          function()
            load_scene "credits"
          end
        }
      }
    else
      menu_items = {
        {
          "press    to start",
          function()
            load_scene "tutorial"
          end
        }
      }
    end
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
        spr(11, 54 - flr((#item[1] * 4) / 2), y)
        spr(11, 65 + flr((#item[1] * 4) / 2), y, 1, 1, true)
      end
    end

    if not tutorial_complete then
      ? "❎", 54, 108, 8
    end
  end
})