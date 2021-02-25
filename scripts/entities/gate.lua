entities.gate = entity:constructor({
  door_animation_frames = 15,
  y = -8,
  effects = true,
  is_open = false,
  layer = 62,

  init = function(self)
    local gate = self

    self.left_door = self.left_door or entity:new({
      x = self.is_open and -80 or -32,
      y = self.y,
      layer = 60,
      solid = true,
      hitbox = {
        x = 0,
        y = 0,
        width = 96,
        height = 16,
      },

      draw = function(self)
        spr(36, self.x, self.y, 12, 2)
        set_palette()
      end
    })

    self.right_door = self.right_door or self.left_door:new({
      x = self.is_open and 110 or 62,
      layer = 61,

      draw = function(self)
        spr(36, self.x, self.y, 12, 2)
      end
    })

    self.portal = entities.portal:new({
      y = self.y,

      direction = self.direction,
      offset = self.is_open and 10 or 0
    })
  end,

  update = function(self)
    self.portal.y = self.y
    self.left_door.y = self.y
    self.right_door.y = self.y
  end,

  draw = function(self)
    local x, y = self.right_door.x, self.right_door.y

    for i = 1, player.max_health do
      local offset = (i - 1) * 6
      spr(player.health >= i and 15 or 14, x + 64 - player.max_health * 6 + offset, y)
    end

    spr(12, x + 56 - player.max_health * 6, y)
  end,

  open = function(self)
    if not self.is_open then
      space.particles = true

      if self.effects then
        screen:shake(0.1)
        sfx(19)
      end

      self.is_open = true
      self.portal:animate({ offset = 10 }, self.door_animation_frames, easeoutquad)
      self.left_door:animate({ x = -80 }, self.door_animation_frames, easeoutquad)
      self.right_door:animate({ x = 112 }, self.door_animation_frames, easeoutquad)
    end
  end,

  close = function(self)
    if self.is_open then
      if (self.effects) sfx(19)
      self.is_open = false
      self.portal:animate({ offset = 0 }, self.door_animation_frames, easeinquad)
      self.left_door:animate({ x = -32 }, self.door_animation_frames, easeinquad)
      self.right_door:animate({ x = 62 }, self.door_animation_frames, easeinquad, function()
        if self.effects then
          screen:shake(0.15)
          sfx(20)
        end
      end)
    end
  end,

  on_destroy = function(self)
    self.portal:destroy()
    self.left_door:destroy()
    self.right_door:destroy()
  end
})