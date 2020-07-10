PauseScreen = {}

function PauseScreen:PauseScreen(name, ...)

  -- Variables
  self.name = name
  
  -- Load up specific pause screen
  local f,err = love.filesystem.load("PauseScreens/" .. name .. ".lua")
  if not f then love.errhand(err) end
  f(self)
  
  -- Initialize the object
  self:initialize(unpack({...}))
end

function PauseScreen:initialize()
end

function PauseScreen:update(dt)
  return false
end

function PauseScreen:draw()
end

function PauseScreen:destroy()
end

createClass("PauseScreen", PauseScreen)