entities.button = entity:constructor({
  type = "button",
  solid = true,
  layer = 63,

  hitbox = {
    x = 0,
    y = 0,
    width = 24,
    height = 6,
  },

  init = function(self)
    local this = self

    self.target = entities.target:new({
      x = self.x + 4,
      y = self.y + 5,
      on_hit = function(self)
        self:flash(5)
        this:on_hit()
        sfx(21)
      end
    })
  end,

  update = function(self)
    self.target.x = self.x + 4
    self.target.y = self.y + 5
  end,

  draw = function(self)
    spr(6, self.x, self.y, 3, 1)
  end,

  on_destroy = function(self)
    self.target:destroy()
  end
})