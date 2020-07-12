----------------------------------------------------------------------
--[[
  Author: Rhen Niles
  Type: Game Object
  Description: Modular Board object
]]
----------------------------------------------------------------------

local Image = ...


function Image:onInitialize(name, position, scale, zOrder)
  self:setImage(name)
  self.position = position
  self.scale = scale
  self.zOrder = zOrder
  self.pivot = Vector2D(0, 0)
end

function Image:onUpdate(dt)
  -- Called every frame
end

function Image:onDestroy()
  -- Called when the object is destroyed
end

function Image:propegatezOrder(dz)
  self.zOrder -= dz
end

function Image:propegatePosition(dv)
  self.position -= dv
end
    
function Image:propegateScale(s)
  self.scale *= s
end