----------------------------------------------------------------------
--[[
  Author: Corbin McBride
  Type: Game Object
  Description:
]]
----------------------------------------------------------------------

local ModuleOutput = ...

function ModuleOutput:onInitialize(b, p, iconPos)
  -- Called when the game object is constructed
  self.color = Color(128, 0, 0)
  self.scale.x = 38
  self.scale.y = 38
  self:setImage("ModuleAssets/WireSlot.png")
  
  self.pivot.x = 0.5
  self.pivot.y = 0.5
  self.defaultColor = self.color

  self.icon = nil

  self.board = b
  self.port = p

  self.iconPos = iconPos
  
  self:setupIconScreen()
  self:setupIcon()
  self:setupWireEnd()
end

function ModuleOutput:setupWireEnd()
  if self.wireEnd == nil then
    self.wireEnd = GameObject("WireEnd")
    self.wireEnd.visible = false
  end
  self.wireEnd.position.x = self.position.x
  self.wireEnd.position.y = self.position.y
  self.wireEnd.zOrder = self.zOrder + 1
end

function ModuleOutput:setupIconScreen()
  if self.iconScreen == nil then
    self.iconScreen = GameObject("IconScreen")
  end
  self.iconScreen.position.x = self.position.x + self.iconPos.x
  self.iconScreen.position.y = self.position.y + self.iconPos.y
  self.iconScreen.zOrder = self.zOrder + 1
end

function ModuleOutput:setupIcon()
  if self.board.outputs[self.port] ~= nil then
    if self.icon == nil then
      self.icon = GameObject("ResourceIcon", self.board.outputs[self.port], Color(255,0,0))
    else
      self.icon:onInitialize(self.board.outputs[self.port], Color(255,0,0))
    end
    self.icon.zOrder = self.zOrder + 2
    self.icon.visible = true
    self.icon.position = self.iconScreen.position
  elseif self.icon ~= nil then
    self.icon.visible = false
  end
end

function ModuleOutput:onUpdate(dt)
  -- Called every frame
  self:setupIcon()
  if IsOutputUsed(self.board, self.port) == false and (Cursor.outBoard == self.board and Cursor.outPort == self.port) == false then
    self.wireEnd.visible = false
  else
    self.wireEnd.visible = true
  end
  local mx, my = MainCamera:mousePosition()
  local l = (self.position - Vector2D(mx, my)):len()
  if l < self.scale.x then
    self:onHover()
    if love.mouse.isLeftClick() and Cursor.outBoard ~= self.board and IsOutputUsed(self.board, self.port) == false and Cursor.outBoard == nil then
      self.wireEnd.visible = true
      Cursor.outBoard = self.board
      Cursor.outPort = self.port
      CheckCursorPlacement(self)
    end
    if love.mouse.isRightClick() and IsOutputUsed(self.board, self.port) then
      for k,v in pairs(GetAllConnections()) do
        if v[3] == self.board and v[4] == self.port then
          DisconnectBoards(v[1], v[2])
        end
      end

      self.cable:destroy()
    end
  else
    self:onNotHover()
  end
end

function ModuleOutput:drawIcon()
  if self.board[self.port] ~= nil then
    
  end
end

function ModuleOutput:onHover()
  if CursorHasOutput() then return end

  self.color = Color(255,0,0)
end

function ModuleOutput:onNotHover()
  self.color = self.defaultColor
end

function ModuleOutput:onDestroy()
  -- Called when the object is destroyed
end
    