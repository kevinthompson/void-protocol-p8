player = entity:new({
  type = "player",
  persist = true,

  -- position
  x = 52,
  y = 144,
  layer = 50,

  -- movement
  control = false,
  vx = 0,
  vy = 0,
  accel = 0.25,
  friction = 0.1,
  max_speed = 2.5,

  -- collision
  hitbox = {
    x = 6,
    y = 4,
    width = 11,
    height = 12,
  },

  -- health
  max_health = 3,
  max_iframes = 60,

  -- projectile
  projectile_speed = -4,
  projectile_kickback = 1.4,

  init = function(self)
    self.health = self.max_health
    self.iframes = 0
    self.disabled_at = t()
    self.animation_ended_at = t()
    self:spawn_projectile()
  end,

  update = function(self)
    if self.control then
      if btnp(5) and #dialog.dialog_queue == 0 then
        self:fire_projectile()
      end

      self:handle_input()
    else
      if not self.animations.x then
        local timestamp = self.animation_ended_at or self.disabled_at
        self.x += timestamp and cos((t() - timestamp)/3) * .25 or 0
      end

      self.y += self.animation_ended_at and cos((t() - self.animation_ended_at)/4) * .1 or 0
    end

    if self.projectile then
      self.projectile.x = self.x + 8
      self.projectile.y = self.y
    end

    self:move_and_collide(function(other, axis)
      if other.type == "portal" then
        other:hit(self)
      elseif other.type == "enemy" then
        self:hit()
      elseif other.solid then
        if (axis == "x") self.vx = 0
        if (axis == "y") self.vy = 0
      end
    end)

    self.iframes = mid(0, self.iframes - 1, self.max_iframes)
  end,

  draw = function(self)
    local x = self.x
    local y = self.y

    if self.iframes % 4 == 0 then
      if self.projectile then
        if self.projectile.eggplant then
          palt(15, false)
          pal(15, 3)
          pal(14,4)
          pal(9,2)
        elseif self.projectile.charged then
          pal(9,6)
          pal(14,8)
        else
          pal(9,6)
          pal(14,7)
        end

        sspr(36, 2, 8, 11, x + 8, y)

        set_palette()
      end

      pal(14, self.projectile and 6 or 7)
      spr(1, x, y, 3, 3)
      pal(14,8)

      transparent(function()
        oval(x + 9, y + 18, x + 14, y + 21, 7)
      end)
    end
  end,

  hit = function(self, other)
    if self.iframes == 0 then
      screen:flash(8, 3)
      screen:shake(.25)
      self.health -= 1
      self.iframes = self.max_iframes
      sfx(24)
    end
  end,

  fire_projectile = function(self)
    if self.projectile then
      sfx(10)
      self.projectile.persist = false
      self.projectile.vy = self.projectile_speed
      self.projectile.player = nil
      self.projectile = nil
      self.vy += self.projectile_kickback
      screen:shake(0.1)
    else
      sfx(9)
    end
  end,

  enable = function(self)
    self.control = true
    self.disabled_at = nil
  end,

  disable = function(self)
    self.disabled_at = t()
    self.control = false
    self.vx = 0
    self.vy = 0
  end,

  handle_input = function(self)
    local vx, vy, accel, friction, max_speed = self.vx, self.vy, self.accel, self.friction, self.max_speed

    if btn(0) then
      vx = vx > 0 and -accel or vx - accel
    elseif btn(1) then
      vx = vx < 0 and accel or vx + accel
    elseif vx != 0 then
      vx += min(abs(vx), friction) * -sgn(vx)
    end

    if btn(2) then
      vy = vy > 0 and -accel or vy - accel
    elseif btn(3) then
      vy = vy < 0 and accel or vy + accel
    elseif vy != 0 then
      vy += min(abs(vy), friction) * -sgn(vy)
    end

    self.vx = mid(-max_speed, vx, max_speed)
    self.vy = mid(-max_speed, vy, max_speed)
  end,

  spawn_projectile = function(self)
    if not self.projectile then
      self.projectile = entities.projectile:new({
        x = self.x + 8,
        y = self.y
      })
      self.projectile.player = self
    end
  end,

  pickup = function(self, projectile)
    sfx(8)
    self.projectile = projectile
    projectile.persist = true
    projectile.floating = false
    projectile.player = self
  end
})