entities.target = entity:constructor({
  type = "target",
  solid = true,
  layer = 4,

  hitbox = {
    x = 0,
    y = 0,
    width = 16,
    height = 6,
  },

  draw = function(self)
    spr(9, self.x, self.y, 2, 1)
  end,
})