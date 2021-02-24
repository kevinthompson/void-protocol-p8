scenes.transition = object:new({
  init = function(self)
    local exit_gate_class

    if previous_scene != scenes.title then
      for e in all(entity.pool) do
        if e.type == "projectile" and e != player.projectile then
          e:animate({ y = 132 }, 30, linear, function()
            e:destroy()
          end)
        end
      end
    end

    player:disable()
    space:animate({ speed = 5 }, 30, easeinquad)
    space:spawn_streaks()

    if previous_scene == scenes.tutorial
    or previous_scene == scenes.title then
      exit_gate_class = "gate_with_button"
    else
      exit_gate_class = "gate"
    end

    gate = entities[exit_gate_class]:new({ is_open = previous_scene != scenes.title })
    if (previous_scene == scenes.title) gate:open()
    gate:animate({ y = 144 }, 30, easeoutquad)

    if player.y < 32 then
      player:animate({ x = 52, y = 88 }, 60, easeinoutquad)
    else
      player:animate({ x = 52, y = 48 }, 20, easeinoutquad, function()
        player:animate({ x = 52, y = 88 }, 30, easeinoutquad)
      end)
    end

    local prefixes = { "alpha", "beta", "charlie", "delta" }
    local level_name = "sector "..prefixes[level_id]

    if level_id > #levels[world] then
      level_name = "breach"
      crossfade_music(17)
    end

    level_text = entities.level_text:new({ text = level_name })
    level_text:animate({ height = 16 }, 15, easeoutquad)

    wait(90, function()
      level_text:animate({ height = 0 }, 15, easeoutquad, function()
        load_scene(level_id > #levels[world] and "breach" or "level")
      end)
    end)
  end,
})