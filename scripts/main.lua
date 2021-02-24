poke(0x5f2e,1)
cartdata "kevinthompson_void_protocol_0"
noop = function() end

-- progress
tutorial_complete = dget(0) == 1

-- data structures
scenes = {}
entities = {}

-- initial values
start_time = t()
end_time = t()
flash_frames = 0
flash_color = 7
world = 1

function _init()
  set_palette()
  load_scene "splash"
end

function _update60()
  quick_sort_hp(entity.pool)
  entity.all "update"
  current_scene:update()
  animation:update()
  timers:update()
end

function _draw()
  cls()
  entity.all "draw"
  current_scene:draw()

  --[[
  if debug then
    for e in all (entity.pool) do
      if e.hitbox then
        rect(
          e.x + e.hitbox.x,
          e.y + e.hitbox.y,
          e.x + e.hitbox.x + e.hitbox.width,
          e.y + e.hitbox.y + e.hitbox.height,
          10
        )
      end
    end
  end
  --]]
end

-- helpers

function say(text, callback)
  dialog:queue(text, callback)
end

function load_scene(name)
  next_scene = scenes[name]

  if current_scene != next_scene then
    previous_scene = current_scene

    timers.pool = {}
    dialog:reset()

    if next_scene != scenes.gameover then
      for entity in all(entity.pool) do
        if (not entity.persist) entity:destroy()
      end
    end

    if (current_scene) current_scene.entities = {}
    current_scene = next_scene
    current_scene:init()
  end

  next_scene = nil
end

function flash(color)
  color = color or 7
  screen:shake(0.25)
  screen:flash(color)
  sfx(38)
end

function wait(frames, callback)
  timers:new(frames, callback)
end