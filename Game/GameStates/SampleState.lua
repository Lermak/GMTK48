----------------------------------------------------------------------
--[[
  Author:
  Type: Game State
  Description:
]]
----------------------------------------------------------------------

SampleState = { 
  
}

function SampleState:init()
  -- Called once, and only once, before entering the state the first time. See Gamestate.switch().
  self.cableState = 0
end

function SampleState:enter(previous, ...)
  -- Called every time when entering the state. See Gamestate.switch().

  local y = 360
  GameObject("Module", "Producer", {x = -640, y = y})
  GameObject("Module", "Producer", {x = -384, y = y})
  GameObject("Module", "Producer", {x = -128, y = y})
  GameObject("Module", "Producer", {x = 128, y = y})
  GameObject("Module", "Combiner", {x = 384, y = y})

  y = 180
  GameObject("Module", "Combiner", {x = -640, y = y})
  GameObject("Module", "Combiner", {x = -384, y = y})
  GameObject("Module", "Combiner", {x = -128, y = y})
  GameObject("Module", "Combiner", {x = 128, y = y})
  GameObject("Module", "Combiner", {x = 384, y = y})

  y = 0
  GameObject("Module", "Combiner", {x = -640, y = y})
  GameObject("Module", "Combiner", {x = -384, y = y})
  GameObject("Module", "Combiner", {x = -128, y = y})
  GameObject("Module", "Combiner", {x = 128, y = y})
  GameObject("Module", "Combiner", {x = 384, y = y})

  y = -180
  GameObject("Module", "Combiner", {x = -640, y = y})
  GameObject("Module", "Combiner", {x = -384, y = y})
  GameObject("Module", "Combiner", {x = -128, y = y})
  GameObject("Module", "Combiner", {x = 128, y = y})
  GameObject("Module", "Combiner", {x = 384, y = y})

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
