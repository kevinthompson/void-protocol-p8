entities.breach = entity:constructor({
  type = "breach",
  x = 32,
  y = 12,

  hitbox = {
    x = 0,
    y = 0,
    width = 64,
    height = 48,
  },

  draw = function(self)
    spr(102, self.x + rnd(2), self.y + rnd(2), 8, 6)
  end,

  on_destroy = function(self)
    breach = nil

    for i = 1, 60 do
      entities.particle:new({
        x = self.x + rnd(64),
        y = self.y + rnd(48),
        size = rnd({0,1}),
        vx = rnd(4) - 2,
        vy = rnd(4),
        frames = flr(rnd(240)),
        scheme = 2
      })
    end
  end
})