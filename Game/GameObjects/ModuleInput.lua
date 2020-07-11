----------------------------------------------------------------------
--[[
  Author: Corbin McBride
  Type: Game Object
  Description:
]]
----------------------------------------------------------------------

local ModuleInput = ...

function ModuleInput:onInitialize(b, p)
  -- Called when the game object is constructed
  self.color = Color(0, 128, 0)
  self:setImage("ModuleInput.png")
  
  self.pivot.x = 0.5
  self.pivot.y = 0.5
  self.defaultColor = self.color

  self.icon = nil

  self.board = b
  self.port = p

  self:setupIcon()
end

function ModuleInput:setupIcon()
  if self.board.inputs[self.port] ~= nil and self.board.inputs[self.port].board.outputs[self.board.inputs[self.port].port] ~= nil then
    local v = self.board.inputs[self.port].board.outputs[self.board.inputs[self.port].port]
    if self.icon == nil then
      self.icon = GameObject("ResourceIcon", v, Color(0,255,0))
    else
      self.icon:onInitialize(v, Color(0,255,0))
    end
    self.icon.zOrder = 10
    self.icon.visible = true
    self.icon.position = {x = self.position.x + 1, y = self.position.y}
  elseif self.icon ~= nil then
    self.icon.visible = false
  end
end


function ModuleInput:onUpdate(dt)
  -- Called every frame
  self:setupIcon()
  local mx, my = MainCamera:mousePosition()
  local l = (self.position - Vector2D(mx, my)):len()
  if l < 0.5 then
    self:onHover()
    if love.mouse.isLeftClick() and Cursor.inBoard ~= self.board and IsInputUsed(self.board, self.port) == false and Cursor.inBoard == nil then
      Cursor.inBoard = self.board
      Cursor.inPort = self.port
      CheckCursorPlacement(self)
      self:setupIcon()
    end
    if love.mouse.isRightClick() and IsInputUsed(self.board, self.port) then
      DisconnectBoards(self.board, self.port)
      self.cable:destroy()
      self:setupIcon()
    end
  else
    self:onNotHover()
  end
end

function ModuleInput:onHover()
  if CursorHasInput() then return end

  self.color = Color(0, 255, 0, 255)
end

function ModuleInput:onNotHover()
  self.color = self.defaultColor
end

function ModuleInput:onDestroy()
  -- Called when the object is destroyed
end
    