----------------------------------------------------------------------
--[[
  Author:
  Type: Pause Screen
  Description:
]]
----------------------------------------------------------------------

local GamePause = ...

function GamePause:initialize()
  -- Called when the game object is constructed
end

function GamePause:update(dt)
  -- Called every frame
  -- return true or false, where false is to stop pausing
  
  
  
  return true
end

function GamePause:draw()
  -- Called every draw step of the frame
  
  -- Draw outline of pause menu
  love.graphics.rectangle("line", love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 200, 400)
end

function GamePause:destroy()
  -- Called when the object is destroyed
end
    