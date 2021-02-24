dialog = entity:new({
  persist = true,
  x = 8,
  y = 103,
  color = 7,
  max_chars_per_line = 27,
  max_lines = 3,
  dialog_queue = {},
  blinking_counter = 0,
  layer = 100,

  reset = function(self)
    self.animation_loop = nil
    self.pause_dialog = false
    self.current_line_count = 1
    self.current_message = ''
    self.dialog_queue = {}
  end,

  queue = function(self, message, callback)
    callback = callback or function() end
    add(self.dialog_queue, { message = message, callback = callback })

    if (#self.dialog_queue == 1) then
      self:trigger(
        self.dialog_queue[1].message,
        self.dialog_queue[1].callback
      )
    end
  end,

  trigger = function(self, message, callback)
    self.callback = callback
    self.current_message = ''
    self.messages_by_line = nil
    self.animation_loop = nil
    self.current_line_in_table = 1
    self.current_line_count = 1
    self.pause_dialog = false
    self:format_message(message)
    self.animation_loop = cocreate(self.animate_text)
  end,

  format_message = function(self, message)
    local total_msg = {}
    local word = ''
    local letter = ''
    local current_line_msg = ''

    for i = 1, #message do
      -- get the current letter add
      letter = sub(message, i, i)

      -- keep track of the current word
      word ..= letter

      -- if it's a space or the end of the message,
      -- determine whether we need to continue the current message
      -- or start it on a new line
      if letter == ' ' or i == #message then
        -- get the potential line length if this word were to be added
        local line_length = #current_line_msg + #word
        -- if this would overflow the dialog width
        if line_length > self.max_chars_per_line then
          -- add our current line to the total message table
          add(total_msg, current_line_msg)
          -- and start a new line with this word
          current_line_msg = word
        else
          -- otherwise, continue adding to the current line
          current_line_msg ..= word
        end

        -- if this is the last letter and it didn't overflow
        -- the dialog width, then go ahead and add it
        if i == #message then
          add(total_msg, current_line_msg)
        end

        -- reset the word since we've written
        -- a full word to the current message
        word = ''
      end
    end

    self.messages_by_line = total_msg
  end,

  animate_text = function(self)
    -- for each line, write it out letter by letter
    -- if we each the max lines, pause the coroutine
    -- wait for input in update before proceeding
    for k, line in pairs(self.messages_by_line) do
      self.current_line_in_table = k
      for i = 1, #line do
        self.current_message ..= sub(line, i, i)

        -- press btn 5 to skip to the end of the current passage
        -- otherwise, print 1 character per frame
        -- with sfx about every 5 frames
        if (not btnp(5)) then
          if (i % 5 == 0) sfx(0)
          yield()
        end
      end

      self.current_message ..= '\n'
      self.current_line_count += 1

      if ((self.current_line_count > self.max_lines) or (self.current_line_in_table == #self.messages_by_line)) then
        self.pause_dialog = true
        self.blinking_counter = 30
        yield()
      end
    end
  end,

  shift = function (t)
    local n=#t
    for i = 1, n do
      if i < n then
        t[i] = t[i + 1]
      else
        t[i] = nil
      end
    end
  end,

  -- helper function to add delay in coroutines
  delay = function(frames)
    for i = 1, frames do
      yield()
    end
  end,

  update = function(self)
    if (self.animation_loop and costatus(self.animation_loop) != 'dead') then
      if (not self.pause_dialog) then
        coresume(self.animation_loop, self)
      else
        if btnp(5) then
          self:progress_dialog()
        end
      end
    elseif (self.animation_loop and self.current_message) then
      self.animation_loop = nil
    end

    if (not self.animation_loop and #self.dialog_queue > 0) then
      self.shift(self.dialog_queue, 1)
      if (#self.dialog_queue > 0) then
        self:trigger(
          self.dialog_queue[1].message,
          self.dialog_queue[1].callback
        )
        coresume(self.animation_loop, self)
      end
    end

    self.blinking_counter += 1
    if self.blinking_counter > 60 then self.blinking_counter = 0 end
  end,

  draw = function(self)
    local screen_width = 128

    -- display message
    if (self.current_message and self.current_message != "") then
      rectfill(self.x - 4, self.y - 4, screen_width - 5, screen_width - 5, 0)
      rect(self.x - 4, self.y - 4, screen_width - 5, screen_width - 5, 7)
      print(self.current_message, self.x, self.y, self.color)
    end

    -- draw blinking cursor at the bottom right
    if (self.pause_dialog) then
      if self.blinking_counter > 30 then
        if (self.current_line_in_table == #self.messages_by_line) then
          for x = -1, 1 do
            for y = -1, 1 do
              ? "❎", screen_width - 14 + x, screen_width - 7 + y, 0
            end
          end

          ? "❎", screen_width - 14, screen_width - 7 , 7
        else
          -- draw arrow
          line(screen_width - 13, screen_width - 5, screen_width - 7,screen_width - 5, 0)
          line(screen_width - 12, screen_width - 6, screen_width - 8,screen_width - 6, 7)
          line(screen_width - 11, screen_width - 5, screen_width - 9,screen_width - 5, 7)
          line(screen_width - 10, screen_width - 4, screen_width - 10,screen_width - 4, 7)
        end
      end
    end
  end,

  progress_dialog = function(self)
    self.pause_dialog = false
    self.current_line_count = 1
    self.current_message = ''
    if(self.callback) self.callback()
  end
})