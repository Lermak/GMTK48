----------------------------------------------------------------------
--[[
  Author: Alex Wilkinson
  Type: Game State
  Description: The state that has the main menu
]]
----------------------------------------------------------------------

MenuState = {}

function MenuState:init()
  -- Called once, and only once, before entering the state the first time. See Gamestate.switch().
  wwise.postEvent("Music")
end

function MenuState:enter(previous, ...)
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

  self.title = GameObject("TitleCard")

  self.credits = GameObject("CreditsCard")
  self.credits.color.a = 0
  self.menu = true
  self.exiting = false

  
  wwise.postEvent("Intro_Music")
  --local id = wwise.postEvent("Play_MenuMusic")
  --print(wwise.getEventId(id))
  --print(wwise.getSourceTime(id))
  --wwise.seekEvent(id, 100)
end

function MenuState:update()
  -- Update the game state. Called every frame.
  if self.finishCo then
    self.finishCo:resume()
  end

  if self.exiting then return end

  if love.keyboard.isTriggered('c') and self.title.color.a == 1 then
    -- Goto credits screen

    self.finishCo = makeCoroutine(function()
      overTime(1, function(p)
        p = Easing.OutQuad(p,0,1,1)
        
        self.title.color.a = (1 - p)
        self.credits.color.a = p
      end)

      while not love.keyboard.isAnyKeyDown() and not love.keyboard.isDown('c') do
        coroutine.yield()
      end

      overTime(1, function(p)
        p = Easing.OutQuad(p,0,1,1)
        
        self.title.color.a = p
        self.credits.color.a = (1 - p)
      end)

      self.finishCo = nil
    end)
  end

  if self.title.color.a == 1 and love.keyboard.isAnyKeyDown() and not love.keyboard.isDown('c')then
    -- Goto game
    self.exiting = true
    self.finishCo = makeCoroutine(function()
      local curFade = Fade
      overTime(1, function(p)
        p = Easing.OutQuad(p,0,1,1)
        Fade = 1-p
        
      end)
  
      ShowHowToPlay = true
      Gamestate.switch(SampleState)
      self.finishCo = nil
    end)  
  end
  --it gets set to 255 somewhere?
  if self.title.color.a == 255 then self.title.color.a = 1 end
end

function MenuState:draw()
  -- Draw on the screen. Called every frame.
end

function MenuState:leave()
  -- Called when leaving a state. See Gamestate.switch() and Gamestate.push().
  _G.GameObjectList = {}
  _G.GameObjectInitList = {}
  
end
    