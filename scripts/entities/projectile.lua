entities.projectile = entity:constructor({
  persist = true,

  type = "projectile",
  vx = 0,
  vy = 0,

  float_speed = 1.5,

  sprite = 4,
  rotation = 1,
  layer = 40,

  floating = false,

  on_pickup = noop,

  hitbox = {
    x = -1,
    y = -1,
    width = 10,
    height = 10,
  },

  update = function(self)
    if self.player then
      self.floating = false
    end

    if self.eggplant or self.floating then
      self.rotation = t() * 0.5
    else
      self.rotation = 1
    end

    self:move_and_collide(function(other, axis)
      if current_scene == scenes.tutorial
      and other.type == "target"
      and not self.floating then
        self.floating = true
        self.vy = self.float_speed
        self.vx = -self.float_speed
        other:hit(self)
      elseif other.type == "player" then
        if self.floating and other.control and not other.projectile then
          player:pickup(self)
          self.floating = false
          self.vx = 0
          self.vy = 0
          self:on_pickup()
        end
      else
        if (other.solid or (not self.floating and other.type == "enemy" and not self.player)) then
          self:deflect(other, axis)
          self.floating = true
          other:hit(self)
        elseif not self.floating then
          other:hit(self)
          self.floating = true
        end
      end
    end)
  end,

  draw = function(self)
    local x, y = self.x, self.y

    if not self.player then
      if self.eggplant then
        mapr(x + 4, y + 4, self.rotation, 3, 0, 2)

        if self.floating then
          transparent(function()
            circ(x + 4, y + 4, 12, 7)
          end)
        end
      else
        if self.charged then
          pal(9,2)
          pal(14,8)
        else
          pal(9,6)
          pal(14,7)
        end

        if self.floating then
          transparent(function()
            circ(x + 4, y + 4, 8, 7)
          end)

          mapr(x + 4, y + 4, self.rotation, 0, 0, 2)
        else
          sspr(36, 2, 8, 11, x, y)
        end
      end
    end

    set_palette()
  end,

  deflect = function(self, other, axis)
    if axis == "y" then
      if not self.floating then
        local offset = (self.x + self.hitbox.x + (self.hitbox.width / 2)) - (other.x + other.hitbox.x + (other.hitbox.width / 2))
        self.vx = abs(offset) < 2 and 0 or sgn(offset) * self.float_speed
      end

      self.vy = sgn(self.vy) * -self.float_speed
    else
      self.vx *= -1
    end
  end,

  on_destroy = function(self)
    if (self.player) self.player.projectile = nil
  end,

  convert_to_eggplant = function(self)
    self.float_speed = 0.25
    self.eggplant = true
    self.vx = self.float_speed
    self.vy = self.float_speed
    self.floating = true
  end
})