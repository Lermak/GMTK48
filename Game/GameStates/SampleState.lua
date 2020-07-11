----------------------------------------------------------------------
--[[
  Author:
  Type: Game State
  Description:
]]
----------------------------------------------------------------------

SampleState = {}

function SampleState:init()
  -- Called once, and only once, before entering the state the first time. See Gamestate.switch().
  GameObject("Cable", Vector2D(0, 0), Vector2D(2,2))
end

function SampleState:enter(previous, ...)
  -- Called every time when entering the state. See Gamestate.switch().
  ConnectBoards(Boards[2], 1, Boards[5], 1)
  ConnectBoards(Boards[3], 1, Boards[1], 1)
  ConnectBoards(Boards[4], 1, Boards[5], 2)
  ConnectBoards(Boards[5], 1, Boards[1], 2)

  GetAllConnections()
end

function SampleState:update()

end

function SampleState:draw()
  -- Draw on the screen. Called every frame.
end

function SampleState:leave()
  -- Called when leaving a state. See Gamestate.switch() and Gamestate.push().
end
