----------------------------------------------------------------------
--[[
  Author:
  Type: Game State
  Description:
]]
----------------------------------------------------------------------

SampleState = {
  mod1 = GameObject("Module"),
  mod2 = GameObject("Module")
}

function SampleState:init()
  -- Called once, and only once, before entering the state the first time. See Gamestate.switch().
end

function SampleState:enter(previous, ...)
  -- Called every time when entering the state. See Gamestate.switch().
  SampleState.mod1.position.x = -3
  SampleState.mod2.position.x = 3
  ConnectBoards(Boards[1], 1, Boards[2], 1)
  UpdateBoards()
  ConnectBoards(Boards[2], 1, Boards[3], 1)
  UpdateBoards()
  ConnectBoards(Boards[3], 1, Boards[4], 1)
  UpdateBoards()
end

function SampleState:update()
  
end

function SampleState:draw()
  -- Draw on the screen. Called every frame.
end

function SampleState:leave()
  -- Called when leaving a state. See Gamestate.switch() and Gamestate.push().
end
