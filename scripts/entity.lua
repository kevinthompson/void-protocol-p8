entity = object:new({
	pool = {},
	animations = {},
	persist = false,

  type = "entity",
	solid = false,
	layer = 0,
	x = 0,
	y = 0,

	vx = 0,
	vy = 0,

	width = 0,
	height = 0,

	hitbox = nil,
	flash_frames = 0,

	new = function(self, table)
		local new_entity = self:constructor(table)
		new_entity.animations = {}
		new_entity:init()

		add(self.pool, new_entity)

		return new_entity
	end,

	destroy = function(self)
		if (self.on_destroy) self:on_destroy()
		del(entity.pool, self)
	end,

	on_destroy = noop,

	all = function(method)
		for entity in all(entity.pool) do
			entity["_"..method](entity)
		end
	end,

	_update = function(self)
		for key, animation in pairs(self.animations) do
			if animation then
				self[key] = animation.value

				if animation.done then
					self.animations[key] = nil
				end
			end
		end

		self:update()
	end,

	_draw = function(self)
		self:with_flash(function()
			self:draw()
		end)
	end,

	hit = function(self, other)
		self:on_hit(other)
	end,

	on_hit = noop,

	flash = function(self, frames)
		self.flash_frames = frames
	end,

	with_flash = function(self, func)
    if self.flash_frames > 0 then
      for i=0,15 do
        pal(i,7)
      end

      self.flash_frames -= 1
    end

		func()

    set_palette()
	end,

	// animation

	animate = function(self, attributes, frames, easing, callback)
		self.animation_ended_at = nil

		for key, value in pairs(attributes) do
			local func = callback

			self.animations[key] = animation:new(self[key], value, frames, easing, function()
				if (func) func()
				self.animation_ended_at = t()
			end)

			callback = noop
		end
	end,

	// movement

	collide = function(self, other)
		if (not self.hitbox or not other.hitbox) return false

		return other.x + other.hitbox.x < self.x + self.hitbox.x + self.hitbox.width - 1
		and other.x + other.hitbox.x + other.hitbox.width - 1 > self.x + self.hitbox.x
		and other.y + other.hitbox.y < self.y + self.hitbox.y + self.hitbox.height - 1
		and other.y + other.hitbox.y + other.hitbox.height > self.y + self.hitbox.y
	end,

	move = function(self)
		local angle = atan2(self.vx, self.vy)
    local nvx = cos(angle) * abs(self.vx)
    local nvy = sin(angle) * abs(self.vy)

		self.x += nvx
		self.y += nvy
	end,

	move_and_collide = function(self, callback)
		if (not self.hitbox) return

		callback = callback or noop

		local angle = atan2(self.vx, self.vy)
    local nvx = cos(angle) * abs(self.vx)
    local nvy = sin(angle) * abs(self.vy)

    if nvx != 0 or nvy != 0 then
      local steps = ceil(max(abs(nvx), abs(nvy)))
      local step = 1/steps

      for i = 1, steps do
        local ox = self.x
        local oy = self.y

        if nvx != 0 then
          self.x += nvx * step

          for other in all(entity.pool) do
            if other != self and self:collide(other) then
							callback(other, "x")

              if other.solid then
                self.x = ox
                nvx = 0
              end
            end
          end
        end

        if nvy != 0 then
          self.y += nvy * step

          for other in all(entity.pool) do
            if other != self and self:collide(other) then
							callback(other, "y")

              if other.solid then
                self.y = oy
                nvy = 0
              end
            end
          end
        end

        if (nvx == 0 and nvy == 0) break
      end
    end
	end
})