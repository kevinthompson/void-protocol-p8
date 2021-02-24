entities.gate_with_button = entities.gate:constructor({
  init = function(self)
    entities.gate.init(self)

    self.button = entities.button:new({
      layer = 63,
      x = self.right_door.x + 36,
      y = self.y + 10,
    })
  end,

  update = function(self)
    entities.gate.update(self)

    self.button.x = self.right_door.x + 36
    self.button.y = self.y + 10
  end,

  on_destroy = function(self)
    entities.gate.on_destroy(self)

    self.button:destroy()
  end,
})