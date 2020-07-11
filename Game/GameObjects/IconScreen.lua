
----------------------------------------------------------------------
--[[
  Author: Rhen Niles
  Type: Game Object
  Description: draws a container for resource icons
]]
----------------------------------------------------------------------

local IconScreen = ...

function IconScreen:onInitialize()
  -- Called when the game object is constructed
  self.scale.x = 40
  self.scale.y = 40
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
    