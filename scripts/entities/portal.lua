entities.portal = entity:constructor({
  type = "portal",

  solid = false,
  layer = 35,
  y = -8,
  offset = 0,
  direction = "down",

  hitbox = {
    x = 16,
    y = 8,
    width = 96,
    height = 10
  },

  draw = function(self)
    local x, y, offset = self.x, self.y, self.offset
    local overlay_y = self.direction == "down" and -4 or 4

    ovalfill(x, y - offset + 9, x + 127, y + 6 + offset, 0)
    transparent(function()
      for i = 0, 2 do
        oval(x, y + i - offset + 9, x + 127, y + 6 - i + offset, 7 - i)
      end
    end)

    rectfill(x, y + overlay_y, x + 127, y + 12 + overlay_y, 0)
  end
})