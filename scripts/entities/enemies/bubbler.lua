entities.bubbler = entities.enemy:constructor({
  health = 3,
  bubble_timer = 180,
  exclusive = true,
  vx = 0.5,
  vy = 0.5,
  sprite = 80,
  bubbles = {},

  init = function(self)
    self.bubbles = {}
  end,

  attack = function(self)
    if self.bubble_timer <= 0 and player.health > 0 then
      if #self.bubbles < 3 then
        local bubbler = self
        local bubble = entities.bubble:new({
          x = self.x,
          y = self.y,

          on_destroy = function(self)
            del(bubbler.bubbles, self)
          end
        })

        add(enemies, bubble)
        add(self.bubbles, bubble)
      end

      self.bubble_timer = 180
    else
      self.bubble_timer -= 1
    end
  end,
})