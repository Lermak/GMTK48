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

end

function SampleState:update()
  if love.keypressed('1') then
    ConnectBoards(Boards[1], 1, Boards[2], 1)
    print("1")
  end
  if love.keypressed('2') then
    ConnectBoards(Boards[2], 1, Boards[3], 1)
  end
  if love.keypressed('3') then
    ConnectBoards(Boards[3], 1, Boards[4], 1)
  end
  if love.keypressed('4') then
    ConnectBoards(Boards[4], 1, Boards[5], 1)
  end
  if love.keypressed('5') then
    ConnectBoards(Boards[4], 2, Boards[5], 2)
  end
  UpdateBoards()
end

function SampleState:draw()
  -- Draw on the screen. Called every frame.
end

function SampleState:leave()
  -- Called when leaving a state. See Gamestate.switch() and Gamestate.push().
end
