entities.bubble = entities.enemy:constructor({
  attack = function(self)
    self.vx = 0
    self.vy = 0
    self.y += sin(t()) / 4

    if player.health > 0 and player.control then
      self.vx = self.x == player.x and 0 or sgn(player.x - self.x) / 2
      self.vy = self.y == player.y and 0 or sgn(player.y - self.y) / 2
    end
  end,

  draw = function(self)
    circfill(self.x + 8, self.y + 8, 7, 0)
    circ(self.x + 4, self.y + 4, 1, 7)
    circ(self.x + 8, self.y + 8, 7, 8)
  end
})