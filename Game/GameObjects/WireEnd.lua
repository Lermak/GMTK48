
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
  
  self.pivot.x = 0.5
  self.pivot.y = 0.5
end

function WireEnd:onUpdate(dt)
  -- Called every frame
end

function WireEnd:onDestroy()
  -- Called when the object is destroyed
end
    