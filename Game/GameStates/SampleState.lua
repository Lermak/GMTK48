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
  ConnectBoards(Boards[2], 1, Boards[1], 2)
  ConnectBoards(Boards[3], 1, Boards[2], 1)
  ConnectBoards(Boards[4], 1, Boards[3], 1)
  UpdateBoards()
  GetAllConnections()
  print("enter sample state")
end

function SampleState:update()
  if love.keyboard.isTriggered("space") then
    print("1!")
    if Boards[2].inputs[1] == nil then
      ConnectBoards(Boards[2], 1, Boards[1], 1)
      print("Connect!")
    else
      DisconnectBoards(Boards[2],1)
      print("Disconnect!")
    end
  end
end

function SampleState:draw()
  -- Draw on the screen. Called every frame.
end

function SampleState:leave()
  -- Called when leaving a state. See Gamestate.switch() and Gamestate.push().
end
