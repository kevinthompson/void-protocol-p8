scenes.tutorial = object:new({
  step = 1,
  complete = false,
  exit_warning_displayed = false,

  init = function(self)
    tutorial_complete = false
    gate = entities.gate_with_button:new()
    self:step_one()
  end,

  draw = function(self)
    if not player.control and not tutorial_complete then
      line(1,0,126,0,7)
      line(0,1,0,126,7)
      line(127,1,127,126,7)
      line(1,127,126,127,7)
    end
  end,

  step_one = function(self)
    self.projectile = player.projectile

    player:animate({ x = 52, y = 64 }, 30, easeoutquad)
    say "hostile entities have opened a breach in the delta quadrant."
    say("you're going to have to seal it.", function()
      gate.button.on_hit = function()
        gate:open()
        gate.button.on_hit = noop
        self:step_two()
      end
    end)

    say "these slip gates will help you move quickly between sectors."
    say("line your ship up with the gate control and hit the ❎ button...", function()
      player:enable()
    end)
  end,

  step_two = function(self)
    player:disable()
    player:animate({ x = 96, y = 64 }, 30, easeoutquad)
    say("perfect! the gate's open... grab your void cell and get moving.", function()
      player:enable()

      gate.portal.on_hit = function(portal, other)
        if other == player then
          if not player.projectile then
            if not self.exit_warning_displayed then
              say "if you leave without a void cell the whole mission is over..."
              self.exit_warning_displayed = true
            end
          elseif tutorial_complete then
            gate.portal.on_hit = noop
            player.health = 3
            start_time = t()
            load_scene "transition"
          end
        end
      end

      self.projectile.on_pickup = function()
        self:step_three()
        self.projectile.on_pickup = noop
      end
    end)
  end,

  step_three = function(self)
    player:disable()
    player:animate({ x = 52, y = 64 }, 90, easeoutovershoot)

    say "your void containment cell isn't charged yet, so it's virtually indestructible."
    say "you can use it to clear a path if anything gets in your way."
    say("just don't lose it... we're going to need it to seal the breach.", function()
      music(-1, 4000)

      enemy = entities.bubble:new({
        x = 64,
        y = -64,

        on_destroy = function()
          self:step_four()
        end,
      })

      enemy:animate({ x = 56, y = 24 }, 90, easeoutovershoot, function()
        gate:close()
      end)

      space:animate({ speed = 1 }, 90)
      music(1)
    end)

    say "heads up! one of the entities made it through. the gate's locking down."
    say "that gate wont open again until you clear the area."
    say("take out that entity and head into the gate!", function()
      player:animate({ x = 52, y = 88 }, 30, easeoutquad, function()
        enemy:move()
        player:enable()
      end)
    end)
  end,

  step_four = function(self)
    dset(0, 1)
    tutorial_complete = true
    gate:open()
  end,

  unload = function(self)
    gate:destroy()
  end
})