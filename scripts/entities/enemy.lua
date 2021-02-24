entities.enemy = entity:constructor({
  type = "enemy",
  exclusive = false,

  health = 1,
  iframes = 0,
  max_iframes = 5,
  sprite = 48,

  hitbox = {
    x = 2,
    y = 2,
    width = 12,
    height = 12
  },

  update = function(self)
    self.iframes = mid(0, self.iframes - 1, self.max_iframes)
    if (player.control) self:attack()
    self:move_and_collide(function(other, axis)
      if other == player then
        other:hit(self)
      elseif other.solid then
        if (axis == "x") self.vx *= -1
        if (axis == "y") self.vy *= -1
      end
    end)
  end,

  attack = function(self)
  end,

  draw = function(self)
    sspr((self.sprite % 16) * 8, (self.sprite \ 16) * 8, 16, 16, self.x, self.y + sin(t() * 2) * 2, 16, 16 - sin(t() * 2) * 2)
  end,

  on_hit = function(self)
    if self.iframes == 0 then
      sfx(24 - min(self.health, 3))
      self:flash(5)
      self.health -= 1
      self.iframes = self.max_iframes

      if self.health == 0 then
        self:destroy()
      end
    end
  end,

  destroy = function(self)
    for i = 1, 5 do
      entities.particle:new({
        size = rnd(3),
        x = self.x + 4 + rnd(8),
        y = self.y + 4 + rnd(8),
        vx = rnd(3) - 1.5,
        vy = -0.5 - rnd(1),
        scheme = 2,
      })
    end

    del(enemies, self)
    entity.destroy(self)
  end
})