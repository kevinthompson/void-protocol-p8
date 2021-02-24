timers = object:new({
	pool = {},

  new = function(self, frames, callback)
    local coroutine = cocreate(function()
      for i = frames, 0, -1 do
        i -= 1
        yield()
      end

      callback()
    end)

    add(self.pool, coroutine)
  end,

  update = function(self)
    for coroutine in all(self.pool) do
      if costatus(coroutine) != "dead" then
        coresume(coroutine)
      else
        del(self.pool, coroutine)
      end
    end
  end
})