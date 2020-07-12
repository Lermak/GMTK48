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
  self.zOrder = -5
  self.pivot = Vector2D(0, 0)
end

function Image:onUpdate(dt)
  -- Called every frame
end

function Image:onDestroy()
  -- Called when the object is destroyed
end
    