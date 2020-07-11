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
  self:setImage("ModuleAssets/WireSlot.png")
  
  self.pivot.x = 0.5
  self.pivot.y = 0.5
  self.defaultColor = self.color

  self.icon = nil

  self.board = b
  self.port = p
end


function ModuleInput:onUpdate(dt)
  -- Called every frame
  local mx, my = MainCamera:mousePosition()
  local l = (self.position - Vector2D(mx, my)):len()
  if l < 0.5 then
    self:onHover()
    if love.mouse.isLeftClick() and Cursor.inBoard ~= self.board and IsInputUsed(self.board, self.port) == false and Cursor.inBoard == nil then
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
  if CursorHasInput() then return end

  self.color = Color(0, 255, 0, 255)
end

function ModuleInput:onNotHover()
  self.color = self.defaultColor
end

function ModuleInput:onDestroy()
  -- Called when the object is destroyed
end
    