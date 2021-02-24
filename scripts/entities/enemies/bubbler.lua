entities.bubbler = entities.enemy:constructor({
  health = 3,
  bubble_timer = 180,
  exclusive = true,
  vx = 0.5,
  vy = 0.5,
  sprite = 80,

  attack = function(self)
    if self.bubble_timer <= 0 and player.health > 0 then
      add(enemies, entities.bubble:new({ 
        x = self.x, 
        y = self.y,
      }))
      
      self.bubble_timer = 180
    else
      self.bubble_timer -= 1
    end
  end,
})