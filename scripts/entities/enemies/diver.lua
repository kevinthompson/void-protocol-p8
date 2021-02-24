entities.diver = entities.enemy:constructor({
  mode = "seek",
  health = 2,
  exclusive = true,

  init = function(self)
    self.vx = 0.5 * rnd({ -1, 1 })
    self.oy = self.y
  end,

  attack = function(self)
    if self.mode == "seek" and self.x + 8 > player.x + 4 and self.x + 8 < player.x + 20 then
      self.y += sin(t())
      self.mode = "windup"
      self.vx = 0
      self.vy = -0.2
    elseif self.mode == "windup" and self.y < self.oy - 5 then
      self.mode = "dive"
      self.vy = 4
    elseif self.mode == "dive" and self.y > 104 then
      self.mode = "return"
      self.vy = -1
    elseif self.mode == "return" and self.y <= self.oy then
      self.y = self.oy
      self.vx = 0.5
      self.vy = 0
      self.mode = "seek"
    end
  end,

  on_hit = function(self, other)
    entities.enemy.on_hit(self, other)

    if other.type == "wall" then
      self.vy = -0.5
    end
  end
})