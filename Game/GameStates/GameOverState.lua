----------------------------------------------------------------------
--[[
  Author: Alex Wilkinson
  Type: Game State
  Description: The state that has the main menu
]]
----------------------------------------------------------------------

GameOverState = {}

function GameOverState:init()
  -- Called once, and only once, before entering the state the first time. See Gamestate.switch().
end

function GameOverState:enter(previous, ...)
  -- Called every time when entering the state. See Gamestate.switch().
  if Fade == 0 then
    self.finishCo = makeCoroutine(function()
      overTime(1, function(p)
        p = Easing.OutQuad(p,0,1,1)
        Fade = 1 * p
      end)
  
      self.finishCo = nil
      
    end)
  end

  self.menu = true
  self.exiting = false

end

function GameOverState:update()
  -- Update the game state. Called every frame.
  if self.finishCo then
    self.finishCo:resume()
  end

  if self.exiting then return end

  if love.keyboard.isAnyKeyDown() then
    -- Goto game
    self.exiting = true
    self.finishCo = makeCoroutine(function()
      local curFade = Fade
      overTime(1, function(p)
        p = Easing.OutQuad(p,0,1,1)
        Fade = 1-p
        
      end)

      Gamestate.switch(MenuState)
      self.finishCo = nil
    end)  
  end
end

function GameOverState:draw()
  -- Draw on the screen. Called every frame.
  love.graphics.setColor(0,0,0,255)
  love.graphics.setFont(love.graphics.newFont("Data/Fonts/KenPixel Mini Square.ttf", 200))
  love.graphics.printf("Game Over", 0, love.graphics:getHeight()/2 - 200, 1280, "center")

  love.graphics.setFont(love.graphics.newFont("Data/Fonts/KenPixel Mini Square.ttf", 50))
  love.graphics.printf("Press any key to go to main menu", 0, love.graphics:getHeight()/2 + 50, 1280, "center")
end

function GameOverState:leave()
  -- Called when leaving a state. See Gamestate.switch() and Gamestate.push().
  _G.GameObjectList = {}
  _G.GameObjectInitList = {}
end
    