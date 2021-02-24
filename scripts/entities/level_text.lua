entities.level_text = entity:constructor({
  y = 24,
  height = 0,
  text = "sector alpha-1",
  layer = 70,

  draw = function(self)
    local y = self.y + 8 - (self.height / 2)
    rect(0, y, 128, y + self.height, 6)
    rectfill(0, y + 1, 128, y + self.height - 1, 7)
    if (self.height >= 4) rect(-1, y + 2, 129, y + self.height - 2, 0)
    if (self.height >= 12) print_centered(self.text, y + 6, 0)
  end
})