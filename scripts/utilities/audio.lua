crossfade_music = function(song, duration)
  duration = duration or 500
  factor = duration / 1000

  music(-1, duration)
  wait(factor * 60, function()
    music(song, duration / 2)
  end)
end