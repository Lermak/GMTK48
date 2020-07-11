
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

function WireEnd:onUpdate(dt)
  -- Called every frame
  if self.dragged then
    self.position = Vector2D(MainCamera:mousePosition())
  end
end

function WireEnd:onDestroy()
  -- Called when the object is destroyed
end
    