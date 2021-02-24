entities.particle = entity:constructor({
  size = 1,
  speed = 1,
  frames = 60,
  frame = 0,
  layer = -1,
  vx = 0,
  vy = space.speed,
  persist = true,
  schemes = {{7,6,5}, {8,2,4}},
  scheme = 1,

  init = function(self)
    self.color = self.schemes[self.scheme][1]
  end,

  update = function(self)
    self:move()
    self.frame += 1
    if (self.frame > self.frames * .33) self.color = self.schemes[self.scheme][2]
    if (self.frame > self.frames * .66) self.color = self.schemes[self.scheme][3]
    if (self.frame >= self.frames) self:destroy()
  end,

  draw = function(self)
    circfill(self.x, self.y, self.size, self.color)
  end
})