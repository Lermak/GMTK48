
----------------------------------------------------------------------
--[[
  Author: Rhen Niles
  Type: Game Object
  Description: draws a container for resource icons
]]
----------------------------------------------------------------------

local IconScreen = ...

function IconScreen:onInitialize(scale)
  -- Called when the game object is constructed
  self.scale.x = scale
  self.scale.y = scale
  self:setImage("ModuleAssets/IconScreen.png")
  
  self.pivot.x = 0.5
  self.pivot.y = 0.5
end

function IconScreen:onUpdate(dt)
  -- Called every frame
end

function IconScreen:onDestroy()
  -- Called when the object is destroyed
end
    

function IconScreen:propegatezOrder(dz)
  self.zOrder -= dz
end

function IconScreen:propegatePosition(dv)
  self.position -= dv
end

function IconScreen:propegateScale(s)
  self.scale *= s
end