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
  --GameObject("Cable", Vector2D(0, 0), Vector2D(2,2))
end

function SampleState:enter(previous, ...)
  -- Called every time when entering the state. See Gamestate.switch().

  Boards[1].outputs = Resources
  --ConnectBoards(Boards[2], 1, Boards[5], 1)
  --ConnectBoards(Boards[3], 1, Boards[1], 1)
  --ConnectBoards(Boards[4], 1, Boards[5], 2)
  --ConnectBoards(Boards[5], 1, Boards[1], 2)
  Boards[4]:performOperation()


  local o = GameObject("ModuleOutput", Color(0,0,0), Boards[1], 1)
  o.position.x = 6
  local i = GameObject("ModuleInput", Color(0,0,0), Boards[5], 1)


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
