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

  Boards[1].outputs = Resources
  --ConnectBoards(Boards[2], 1, Boards[5], 1)
  --ConnectBoards(Boards[3], 1, Boards[1], 1)
  --ConnectBoards(Boards[4], 1, Boards[5], 2)
  --ConnectBoards(Boards[5], 1, Boards[1], 2)
  Boards[4]:performOperation()

  local y = 360
  GameObject("Module", "Combiner", {x = -640, y = y})
  GameObject("Module", "Combiner", {x = -384, y = y})
  GameObject("Module", "Combiner", {x = -128, y = y})
  GameObject("Module", "Combiner", {x = 128, y = y})
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

  --GameObject("Module", "Doubler", {x = -1, y = -3})
  --GameObject("Module", "Ship System", {x = 5, y = -3})
  --GameObject("Module", "Ship System", {x = 5, y = 1})

  GetAllConnections()
end

function SampleState:update()  
  if love.keyboard.isTriggered("space") then
    if Boards[2].inputs[1] == nil then
      print("Connecting!")
      ConnectBoards(Boards[2], 1, Boards[5], 1)
    else
      print("Disconnecting!")
      DisconnectBoards(Boards[2],1)
    end
    GetAllConnections()
  end
end

function SampleState:draw()
  -- Draw on the screen. Called every frame.
end

function SampleState:leave()
  -- Called when leaving a state. See Gamestate.switch() and Gamestate.push().
end
