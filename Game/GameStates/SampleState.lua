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

  local x = GameObject("TestObject")
  wwise.postEvent("Woosh")
end

function SampleState:enter(previous, ...)
  -- Called every time when entering the state. See Gamestate.switch().
end

function SampleState:update()
end

function SampleState:draw()
  -- Draw on the screen. Called every frame.
end

function SampleState:leave()
  -- Called when leaving a state. See Gamestate.switch() and Gamestate.push().
end
