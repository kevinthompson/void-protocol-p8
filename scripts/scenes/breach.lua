scenes.breach = object:new({
  init = function(self)
    space:animate({ speed = 1 }, 30, easeoutquad)

    ending = "basic"
    breach_destabilized = false
    projectile = player.projectile

    gate = entities.gate:new({ y = -32, is_open = true, direction = "up" })
    gate:animate({ y = 120 }, 30, easeoutquad)
    wait(10, function()
      gate:close()
      space.particles = true
      bottom_gate:close()
    end)

    breach = entities.breach:new({ y = -64 })
    breach:animate({ y = 12 }, 60, easeoutquad)
    breach.on_hit = function(breach, other)
      if other == projectile then
        end_time = t()

        breach.on_hit = nil
        projectile.vy = 0
        projectile.floating = false
        projectile:animate({ x = 60, y = breach.y + 20 }, 30, easeoutquad, function()
          projectile.floating = true
        end)
        gate:animate({ y = 132 })

        player:disable()
        player:animate({ x = 52, y = 64 }, 30, easeoutquad)

        if projectile.eggplant then
          self:play_eggplant_ending()
        elseif projectile.charged then
          self:play_charged_ending()
        else
          self:play_basic_ending()
        end
      end
    end

    player:animate({ x = 52, y = 80 }, 30, easeoutquad, function()
      player:enable()
    end)
  end,

  play_basic_ending = function(self)
    say("keep back. the containment cell is powering up.", function()
      flash()

      wait(60, function()
        flash()

        wait(45, function()
          flash()

          for i = 1, 60 do
            timers:new(i * 10, function()
              entities.particle:new({
                layer = 10,
                x = 32 + rnd(64),
                y = 16 + rnd(8),
                scheme = 2,
              }):animate({ x = projectile.x + 4, y = projectile.y + 4 }, 60, easeoutquad)
            end)
          end

          say "the cell is absorbing energy from the breach."
          say("you've almost got this under control!", function()
            flash(8)
            wait(60, function()
              flash(8)
              wait(30, function()
                timers.pool = {}
                space.particles = false
                breach:destroy()
                flash(8)
                crossfade_music(0)
                projectile.charged = true
                projectile.floating = true
                projectile:animate({ x = 60, y = 64 }, 15, linear, function()
                  player:pickup(projectile)
                end)

                say "the breach has been contained. that was easier than expected!"
                say "be sure to dispose of that charged cell someplace safe."
                say("we'll need someone with your experience when the next breach appears.", function()
                  load_scene "win"
                end)
              end)
            end)
          end)
        end)
      end)
    end)
  end,

  play_charged_ending = function(self)
    ending = "charged"

    say "did you just fire a charged containment cell into the breach!?"
    say("that's going to create an unstable reaction...", flash)

    say("the breach could expand and swallow this entire univ... wait...", flash)

    say("the energy from the charged cell is... transmuting the breach...", function()
      flash(2)
    end)

    say("the breach is becoming...", function()
      flash(13)
      breach:destroy()

      entities.projectile:new({
        x = 60,
        y = 8,
        float_speed = 0.5,
        vx = 0.5,
        vy = 0.5,
        eggplant = true,
        floating = true
      })

      projectile.charged = false
      projectile:animate({ x = 60, y = 64 }, 30, easeinquad, function()
        player:pickup(projectile)
      end)
    end)

    say("... an eggplant?", function()
      load_scene "win"
    end)
  end,

  play_eggplant_ending = function(self)
    ending = "eggplant"

    say("what are you doing!? where's the containment cell!?", function()
      flash(8)
    end)

    say("did you really just fire an eggplant into the breach?", function()
      flash(8)

      wait(60, function()
        say "... I... just... what did you think that would do?"
        say("it's over... the breach is destabilizing...", function()
          flash(8)
          player.iframes = 60
          player:animate({ y = 144 }, 60)

          wait(30, function()
            flash(8)
            breach_destabilized = true
            projectile.persist = true
            projectile.float_speed = 0.5
            projectile.vx = 0.5
            projectile.vy = 0.5
            projectile.floating = true

            crossfade_music(15)

            wait(60, function()
              load_scene "win"
            end)
          end)
        end)
      end)
    end)
  end
})