screen = entity:new({
  persist = true,
  offset = 0,
  layer = 100,

  init = function()
    entities.wall:new({ x = -8 })
    entities.wall:new({ x = 128 })
    entities.wall:new({ hitbox = { x = 0, y = -8, width = 128, height = 7 }})
    entities.wall:new({ hitbox = { x = 0, y = 128, width = 128, height = 7 }})
  end,

  update = function(self)
    local fade = 0.95

    self.offset *= fade
    if self.offset<0.05 then
      self.offset=0
    end

    if (flash_frames > 0) flash_frames -= 1
  end,

  draw = function(self)
    local offset_x = (16 - rnd(32)) * self.offset
    local offset_y = (16 - rnd(32)) * self.offset

    camera(offset_x,offset_y)

    if flash_frames > 0 then
      cls(flash_color)
    end
  end,

  flash = function(self, color, frames)
    flash_frames = frames or 5
    flash_color = color or 7
  end,

  shake = function(self, amount)
    self.offset = mid(0, self.offset + amount, 1)
  end
})