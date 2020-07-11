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
  self.scale.x = 38
  self.scale.y = 38
  self:setImage("ModuleAssets/WireSlot.png")
  
  self.pivot.x = 0.5
  self.pivot.y = 0.5
  self.defaultColor = self.color

  self.icon = nil

  self.isConnected = false
  self.wireEnd = nil

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
    self.icon.position = self.position
  elseif self.icon ~= nil then
    self.icon.visible = false
  end
end

function ModuleInput:onUpdate(dt)
  -- Called every frame
  if IsInputUsed(self.board, self.port) == false and (Cursor.inBoard == self.board and Cursor.inPort == self.port) == false then
    if self.icon ~= nil then
      self.icon.visible = false
    end
  else
    self:setupIcon()
  end
  local mx, my = MainCamera:mousePosition()
  local l = (self.position - Vector2D(mx, my)):len()
  if l < self.scale.x then
    self:onHover()
    if love.mouse.isLeftClick() then
      if self.isConnected == false then
        self.isConnected = true
        if Cursor.wireEnd == nil then
          local w = GameObject("WireCoupling")

          self.wireEnd = w.wireEnds[1]
          self.wireEnd.myNode = self
          w.wireEnds[1].position = self.position
          
          Cursor.wireEnd = w.wireEnds[2]
          w.wireEnds[2].dragged = true
        else
          self.wireEnd = Cursor.wireEnd
          self.wireEnd.dragged = false
          Cursor.wireEnd = nil
        end
      elseif Cursor.wireEnd == nil then
        self.isConnected = false
        Cursor.wireEnd = self.wireEnd
        Cursor.wireEnd.dragged = true
        Cursor.wireEnd.myNode = nil
        self.wireEnd = nil
      end
      Cursor.outBoard = self.board
      Cursor.outPort = self.port
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
    