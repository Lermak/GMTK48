----------------------------------------------------------------------
--[[
  Author: Corbin McBride
  Type: Game Object
  Description:
]]
----------------------------------------------------------------------

local ModuleSocket = ...

function ModuleSocket:onInitialize(type, moduleId, idx, paramTable)
  -- Called when the game object is constructed
  self.nodeType = type
  if type == "input" then
    self.color = Color(0, 128, 0)
    self.hoverColor = Color(0, 255, 0)
    self.iconPos = Vector2D(0,0)
  else
    self.iconPos = paramTable["iconPos"]
    self.iconScale = paramTable["imgScale"]
    self:setupIconScreen()
    self.color = Color(128, 0, 0)
    self.hoverColor = Color(255, 0, 0)
  end

  self.scale.x = 38
  self.scale.y = 38
  self:setImage("ModuleAssets/WireSlot.png")
  
  self.pivot.x = 0.5
  self.pivot.y = 0.5
  self.defaultColor = self.color

  self.zOrder = 10

  self.icon = nil

  self.moduleIdx = moduleId
  self.nodeIdx = AddNode(self.nodeType, moduleId, idx)

  self.isConnected = false
  self.wireEnd = nil
end

function ModuleSocket:setupIconScreen()
  if self.iconScreen == nil then
    self.iconScreen = GameObject("IconScreen", self.iconScale)
  end
  self.iconScreen.position.x = self.position.x + self.iconPos.x
  self.iconScreen.position.y = self.position.y + self.iconPos.y
  self.iconScreen.zOrder = self.zOrder + 1
end

function ModuleSocket:setupIcon()
  local node = NODE_LIST[self.nodeIdx]

  if node.value ~= nil and node.value ~= "" then
    if self.icon == nil then
      self.icon = GameObject("ResourceIcon", node.value, Color(0,0,255))
    else
      self.icon:onInitialize(node.value, Color(0,0,255))
    end
    
    self.icon.zOrder = self.zOrder + 2
    self.icon.visible = true
    self.icon.position = self.position + self.iconPos
  elseif self.icon ~= nil then
    self.icon.visible = false
  end
end

function ModuleSocket:onUpdate(dt)
  if self.nodeType == "output" then
    self:setupIcon()
  end

  local mx, my = MainCamera:mousePosition()
  local l = (self.position - Vector2D(mx, my)):len()
  if l < self.scale.x then
    self:onHover()
    if love.mouse.isLeftClick() then
      if self.isConnected == false and Cursor.wireEnd == nil then
        self.isConnected = true
        local w = GameObject("WireCoupling")

        self.wireEnd = w.wireEnds[1]
        self.wireEnd.myNode = self
        w.wireEnds[1].position = self.position
        
        Cursor.wireEnd = w.wireEnds[2]
        w.wireEnds[2].position = Vector2D(MainCamera:mousePosition())
        w.wireEnds[2].dragged = true
        w:attachCable()
      end
    end
  else
    self:onNotHover()
  end
end

function ModuleSocket:onHover()
  if CursorHasInput() then return end

  self.color = self.hoverColor
end

function ModuleSocket:onNotHover()
  self.color = self.defaultColor
end

function ModuleSocket:onDestroy()
  -- Called when the object is destroyed
end