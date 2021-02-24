entities.star = entity:constructor({
  layer = -1,
  persist = true,
  color = 5,

  init = function(self)
    self.x = flr(rnd(127))
    self.y = flr(rnd(148) - 20)
    self.speed = rnd(6)
  end,

  update = function(self)
    local mx = player and (player.vx  * .05) or 0
    local my = player and (player.vy * -.1) or 0

    self.x -= mx * self.speed
    self.y += (self.speed * space.speed) + (my * self.speed)

    if self.y > 128 then
      self.x = flr(rnd(127))
      self.y = -20
    end
  end,

  draw = function(self)
    line(
      self.x,
      self.y,
      self.x,
      self.y - flr(self.speed * space.speed / 2),
      self.color
    )
  end
})