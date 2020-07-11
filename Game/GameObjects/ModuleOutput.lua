----------------------------------------------------------------------
--[[
  Author: Corbin McBride
  Type: Game Object
  Description:
]]
----------------------------------------------------------------------

local ModuleOutput = ...

function ModuleOutput:onInitialize(moduleId, idx, iconPos)
  -- Called when the game object is constructed
  self.color = Color(128, 0, 0)
  self.scale.x = 38
  self.scale.y = 38
  self:setImage("ModuleAssets/WireSlot.png")
  
  self.pivot.x = 0.5
  self.pivot.y = 0.5
  self.defaultColor = self.color

  self.icon = nil

  self.moduleIdx = moduleId
  self.nodeType = "output"
  self.nodeIdx = AddNode(self.nodeType, moduleId, idx)

  self.isConnected = false
  self.wireEnd = nil

  self.iconPos = iconPos
  
  self:setupIconScreen()
  self:setupIcon()
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
  --if self.board.outputs[self.port] ~= nil then
  --  if self.icon == nil then
  --    self.icon = GameObject("ResourceIcon", self.board.outputs[self.port], Color(255,0,0))
  --  else
  --    self.icon:onInitialize(self.board.outputs[self.port], Color(255,0,0))
  --  end
  --  self.icon.zOrder = self.zOrder + 2
  --  self.icon.visible = true
  --  self.icon.position = self.iconScreen.position
  --elseif self.icon ~= nil then
  --  self.icon.visible = false
  --end
end

function ModuleOutput:onUpdate(dt)
  --if true then return end

  -- Called every frame
  self:setupIcon()
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
          self.wireEnd.position = self.position
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
    if love.mouse.isRightClick() and IsOutputUsed(self.board, self.port) then
      for k,v in pairs(GetAllConnections()) do
        if v[3] == self.board and v[4] == self.port then
          DisconnectBoards(v[1], v[2])
        end
      end
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
    