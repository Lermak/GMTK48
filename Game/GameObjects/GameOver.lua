----------------------------------------------------------------------
--[[
  Author:
  Type: Game Object
  Description:
]]
----------------------------------------------------------------------

local GameOver = ...

function GameOver:onInitialize()
  -- Called when the game object is constructed
  

  self.zOrder = 10

  self.failiures = 0
end

function GameOver:onUpdate(dt)
  -- Called every frame
  if self.failiures >= 4 then
    --end the game here
    Gamestate.switch(GameOverState)
  end
end

function GameOver:onDestroy()
  -- Called when the object is destroyed
end

function GameOver:onDraw()
  local t = ""

  for i = 1, self.failiures do
    t = t.."X"
  end

  love.graphics.setColor(0,0,0,255)

  love.graphics.printf(t, 700, 200, 900, "left", 0, 3, 3, 0.5 * 200, 0)
end
    