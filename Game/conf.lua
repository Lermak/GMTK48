function love.conf(t)
  local publish = false

  if not publish then
    t.console = true
  end

  t.window.vsync = false
  
  t.window.width = 1280 -- The window width (number)
  t.window.height = 720 -- The window height (number)
  
  t.window.title = "LD 47" -- The window title
  t.window.borderless = false -- Remove all border visuals from the window (boolean)
  t.window.resizable = false -- Let the window be user-resizable (boolean)
  t.window.icon = "Data/Images/Icon.png" -- Filepath to an image to use as the window's icon (string)
end