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
    GameObject("Module", "Producer", {x = x2, y = y1},{ resource = "Star" }),
    GameObject("Module", "Producer", {x = x4, y = y1},{ resource = "Star" }),

    GameObject("Module", "Combiner", {x = x3, y = y2}),
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
    GameObject("Module", "Producer", {x = x1, y = y1}),
    GameObject("Module", "Producer", {x = x2, y = y1}),
    GameObject("Module", "Producer", {x = x3, y = y1}),
    GameObject("Module", "Producer", {x = x4, y = y1}),
    GameObject("Module", "Combiner", {x = x5, y = y1}),
    
    GameObject("Module", "Combiner", {x = x1, y = y2}),
    GameObject("Module", "Combiner", {x = x2, y = y2}),
    GameObject("Module", "Combiner", {x = x3, y = y2}),
    GameObject("Module", "Combiner", {x = x4, y = y2}),
    GameObject("Module", "Combiner", {x = x5, y = y2}),
    
    GameObject("Module", "Combiner", {x = x1, y = y3}),
    GameObject("Module", "Combiner", {x = x2, y = y3}),
    GameObject("Module", "Combiner", {x = x3, y = y3}),
    GameObject("Module", "Combiner", {x = x4, y = y3}),
    GameObject("Module", "Combiner", {x = x5, y = y3}),
  
    GameObject("Module", "Ship System", {x = x1, y = y4}),
    GameObject("Module", "Ship System", {x = x2, y = y4}),
    GameObject("Module", "Ship System", {x = x3, y = y4}),
    GameObject("Module", "Ship System", {x = x4, y = y4}),
    GameObject("Module", "Ship System", {x = x5, y = y4}),
    }
end

function SampleState:init()
  -- Called once, and only once, before entering the state the first time. See Gamestate.switch().
  self.cableState = 0
end

function SampleState:enter(previous, ...)
  -- Called every time when entering the state. See Gamestate.switch().

  

  --setLevel()
  setTutTwo()
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
