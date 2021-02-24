space = entity:new({
  layer = -1,
  speed = 0.5,
  particle_pool = {},
  particles = false,
  persist = true,

  init = function(self)
    for i=1,15 do
      entities.star:new()
    end
  end,

  update = function(self)
    if self.particles and #self.particle_pool < 20 then
      for i = #self.particle_pool, 20 do
        self:spawn_particle()
      end
    end
  end,

  spawn_streaks = function(self)
    for i = 1, 6 do
      entity:new({
        layer = 45,

        init = function(self)
          self:reset_values()
        end,

        update = function(self)
          self.y += self.speed

          if (self.y - 96 > 128) then
            if current_scene != scenes.transition then
              self:destroy()
            else
              self:reset_values()
            end
          end
        end,

        draw = function(self)
          transparent(function()
            rectfill(self.x, self.y, self.x + self.width, self.y - 96, 7)
          end)
        end,

        reset_values = function(self)
          self.x = 8 + rnd(112)
          self.y = 0 - rnd(128)
          self.speed = 8 + rnd(8)
          self.width = rnd({0,1})
        end
      })
    end
  end,

  spawn_particle = function(self, y)
    add(self.particle_pool, entities.particle:new({
      x = rnd(128),
      y = rnd(32) - 16,
      size = rnd({0,1}),
      vy = rnd(2) * self.speed,
      frames = flr(rnd(240)),
      scheme = breach and 2 or 1,

      on_destroy = function(self)
        del(space.particle_pool, self)
      end
    }))
  end,

  draw = function()
    if breach_destabilized then
      rectfill(0,0,128,128, 8)
    end
  end
})