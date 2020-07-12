----------------------------------------------------------------------
--[[
  Author:
  Type: Game State
  Description:
]]
----------------------------------------------------------------------

SampleState = { 
  
}
  local y1 = 360
  local y2 = 180
  local y3 = 0
  local y4 = -180
  local y = {y1, y2, y3, y4}
  
  local x1 = -640
  local x2 = -384
  local x3 = -128
  local x4 =  128
  local x5  = 384
  local x = {x1, x2, x3, x4, x5}

function setTutOne()
  Modules = {
    GameObject("Module", "Producer", {x = x2, y = y2},{ resource = "Star" }),

    GameObject("Module", "Ship System", {x = x4, y = y2},{ resource = "Star" }),
  }
end

function setTutTwo()
  Modules = {
    GameObject("Module", "Producer", {x = x2, y = y1},{ resource = "Star" }),
    GameObject("Module", "Producer", {x = x4, y = y1},{ resource = "Star" }),

    GameObject("Module", "Combiner", {x = x3, y = y2}),

    GameObject("Module", "Ship System", {x = x3, y = y3},{ resource = "Crab" }),
  }
end

  

function setLevel()
  Modules = {
    GameObject("Module", "Producer", {x = -640, y = y}, { resource = "Star" }),
    GameObject("Module", "Producer", {x = -384, y = y}, { resource = "Crab" }),
    GameObject("Module", "Producer", {x = -128, y = y}, { resource = "Electricity" }),
    GameObject("Module", "Producer", {x = 128, y = y},  { resource = "Fire" }),
    GameObject("Module", "Producer", {x = 384, y = y},  { resource = "Star" }),
    
    GameObject("Module", "Empty", {x = -640, y = y2}),
    GameObject("Module", "Combiner", {x = -384, y = y2}),
    GameObject("Module", "Separator", {x = -128, y = y2}),
    GameObject("Module", "Combiner", {x = 128, y = y2}),
    GameObject("Module", "Empty", {x = 384, y = y2}),
    
    GameObject("Module", "Doubler", {x = -640, y = y3}),
    GameObject("Module", "Converter", {x = -384, y = y3}),
    GameObject("Module", "Doubler", {x = -128, y = y3}),
    GameObject("Module", "Empty", {x = 128, y = y3}),
    GameObject("Module", "Empty", {x = 384, y = y3}),
    }
end

function SampleState:init()
  -- Called once, and only once, before entering the state the first time. See Gamestate.switch().
  self.cableState = 0
end

function SampleState:enter(previous, ...)
  -- Called every time when entering the state. See Gamestate.switch().
  setLevel()
  --setTutOne()
end

function SampleState:update()  
  SolveGraph()
end

function SampleState:draw()
  -- Draw on the screen. Called every frame.
end

function SampleState:leave()
  -- Called when leaving a state. See Gamestate.switch() and Gamestate.push().
end
