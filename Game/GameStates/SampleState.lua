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
  self.cableState = 0
end

function SampleState:enter(previous, ...)
  -- Called every time when entering the state. See Gamestate.switch().
  ConnectBoards(Boards[2], 1, Boards[1], 2)
  ConnectBoards(Boards[3], 1, Boards[2], 1)
  ConnectBoards(Boards[4], 1, Boards[3], 1)
  UpdateBoards()
  GetAllConnections()
end

function SampleState:update()
  if love.mouse.isLeftClick() then
    if self.cableState == 0 then
      --if self.cable then self.cable:destroy() end
      self.cable = GameObject("Cable", Vector2D(MainCamera:mousePosition()), Vector2D(MainCamera:mousePosition()))
      self.cableState = 1
    elseif self.cableState == 1 then
      self.cable.temporary = false
      self.cableState = 0
      self.cable:rebuild()
    end
  end

  if love.mouse.isRightClick() then
    self.cable:drop("p1")
  end 

  if self.cableState == 1 then
    self.cable.p1 = Vector2D(MainCamera:mousePosition())
    self.cable:rebuild()
  end

  if love.keyboard.isTriggered('1') then
    if Boards[2].inputs[1] == nil then
      ConnectBoards(Boards[2], 1, Boards[1], 1)
    else
      DisconnectBoards(Boards[2],1)
    end
  end
end

function SampleState:draw()
  -- Draw on the screen. Called every frame.
end

function SampleState:leave()
  -- Called when leaving a state. See Gamestate.switch() and Gamestate.push().
end
