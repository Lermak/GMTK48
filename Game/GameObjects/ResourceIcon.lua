
----------------------------------------------------------------------
--[[
  Author: Rhen Niles
  Type: Game Object
  Description: draws an image of a specified color
]]
----------------------------------------------------------------------

local ResourceIcon = ...

function ResourceIcon:onInitialize(file, color)
  -- Called when the game object is constructed
  self.color = color
  self:setImage("Icons/"..file..".png")
  
  self.scale.x = 32
  self.scale.y = 32
  self.pivot.x = 0.5
  self.pivot.y = 0.5
  self.visible = false
end

function ResourceIcon:onUpdate(dt)
  -- Called every frame
end

function ResourceIcon:onDestroy()
  -- Called when the object is destroyed
end

function ResourceIcon:propegatezOrder(dz)
  self.zOrder -= dz
end

function ResourceIcon:propegatePosition(dv)
  self.position -= dv
end
    
function ResourceIcon:propegateScale(s)
  self.scale *= s
end