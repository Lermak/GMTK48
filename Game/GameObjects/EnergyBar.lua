----------------------------------------------------------------------
--[[
  Author: Rhen
  Type: Game Object
  Description: Shows how charged a system is
]]
----------------------------------------------------------------------

local EnergyBar = ...

function EnergyBar:onInitialize()
  -- Called when the game object is constructed
  self:setImage("ModuleAssets/EnergyBar.png")
  
  self.scale.x = 76
  self.scale.y = 38

  self.zOrder = 100

  self.pivot.x = 0
  self.pivot.y = 0

  self.position.x = -640
  self.position.y = 0

  self.need = 10
  self.has = 0
end

function EnergyBar:onUpdate(dt)
  -- Called every frame
  self.has = self.has + dt
  if self.has > self.need then
    self.has = self.need
  end
end

function EnergyBar:isFinished()
  return self.has >= self.need
end

function EnergyBar:onDestroy()
  -- Called when the object is destroyed
end

function EnergyBar:onDraw()
  print(love.graphics.getWidth())
  love.graphics.setScissor(self.position.x + love.graphics.getWidth( )/2, self.position.y - self.image:getHeight() + love.graphics.getHeight( )/2, self.image:getWidth() * self.has/self.need, self.image:getHeight())
  love.graphics.draw(self.image, self.position.x, self.position.y)
  love.graphics.setScissor() -- disable the clipping
end
    