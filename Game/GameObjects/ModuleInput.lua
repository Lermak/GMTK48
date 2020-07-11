----------------------------------------------------------------------
--[[
  Author: Corbin McBride
  Type: Game Object
  Description:
]]
----------------------------------------------------------------------

local ModuleInput = ...

function ModuleInput:onInitialize(color, b, p)
  -- Called when the game object is constructed
  self.color = color
  self:setImage("ModuleInput.png")
  
  self.pivot.x = 0.5
  self.pivot.y = 0.5
  self.defaultColor = self.color

  self.board = b
  self.port = p
end

function ModuleInput:onUpdate(dt)
  -- Called every frame
  local mx, my = MainCamera:mousePosition()
  local l = (self.position - Vector2D(mx, my)):len()
  if l < 0.5 then
    self:onHover()
    if love.mouse.isLeftClick() and Cursor.inBoard ~= self.board and IsInputUsed(self.board, self.port) == false and Cursor.outBoard ~= self.board and Cursor.inBoard == nil then
      Cursor.inBoard = self.board
      Cursor.inPort = self.port
      CheckCursorPlacement(self)
    end
    if love.mouse.isRightClick() and IsInputUsed(self.board, self.port) then
      DisconnectBoards(self.board, self.port)
    end
  else
    self:onNotHover()
  end

end

function ModuleInput:onHover()
  self.color = Color(0,255,0)
end

function ModuleInput:onNotHover()
  self.color = self.defaultColor
end

function ModuleInput:onDestroy()
  -- Called when the object is destroyed
end
    