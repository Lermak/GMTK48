
----------------------------------------------------------------------
--[[
  Author: Rhen Niles
  Type: Game Object
  Description: draws the wire end image
]]
----------------------------------------------------------------------

local WireEnd = ...

function WireEnd:onInitialize()
  -- Called when the game object is constructed
  self:setImage("WireEnd.png")
  
  self.scale.x = 38
  self.scale.y = 38

  self.pivot.x = 0.5
  self.pivot.y = 0.5
  self.zOrder = 10
  self.myNode = nil
  self.dragged = false
end

function WireEnd:setupIcon(node)
  if node ~= nil and node.value ~= nil and node.value ~= "" then
    if self.icon == nil then
      self.icon = GameObject("ResourceIcon", node.value, Color(0,0,255))
    else
      self.icon:onInitialize(node.value, Color(0,0,255))
    end
    
    self.icon.zOrder = self.zOrder + 15
    self.icon.visible = true
    self.icon.position = self.position 
  elseif self.icon ~= nil then
    self.icon.visible = false
  end
end

function WireEnd:onUpdate(dt)
  if self.myNode then
    self:setupIcon(NODE_LIST[self.myNode.nodeIdx])
  else
    self:setupIcon(nil)
  end


  -- Called every frame
  if self.dragged then
    self.zOrder = 210
    self.position = Vector2D(MainCamera:mousePosition())
  else
    self.zOrder = 110
  end
end

function WireEnd:onDestroy()
  -- Called when the object is destroyed
end
    