----------------------------------------------------------------------
--[[
  Author: Rhen
  Type: Game Object
  Description: Shows how charged a system is
]]
----------------------------------------------------------------------

local EnergyBar = ...

function EnergyBar:onInitialize(m)
  -- Called when the game object is constructed
  self:setImage("ModuleAssets/EnergyBar.png")
  
  self.scale.x = 76
  self.scale.y = 38

  self.zOrder = 100

  self.pivot.x = 0
  self.pivot.y = 0

  self.position.x = -500
  self.position.y = 100

  self.module = m

  self.need = 1
  self.has = 0
end

function EnergyBar:onUpdate(dt) 
  -- Called every frame
  if NODE_LIST[self.module.input[1].nodeIdx] and NODE_LIST[self.module.input[1].nodeIdx].value == self.module.params.resource then
    self.has = self.has + dt
  end
  if self.has > self.need then
    self.has = self.need
    self.module:clear()
    Gamestate.current().systemCooldown -= 0.5
  end
end

function EnergyBar:isFinished()
  return self.has >= self.need
end

function EnergyBar:onDestroy()
  -- Called when the object is destroyed
end

function EnergyBar:onDraw()
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(love.graphics.newImage("Data/Images/ModuleAssets/EnergyBarBackground.png"), self.position.x, self.position.y)
  love.graphics.setScissor(self.position.x + love.graphics.getWidth( )/2, love.graphics.getHeight( )/2 - self.position.y - self.image:getHeight(), self.image:getWidth() * self.has/self.need, self.image:getHeight())
  love.graphics.draw(self.image, self.position.x, self.position.y)
  love.graphics.setScissor() -- disable the clipping
  love.graphics.draw(love.graphics.newImage("Data/Images/ModuleAssets/EnergyBarCage.png"), self.position.x, self.position.y)
end

function EnergyBar:propegatezOrder(dz)
  self.zOrder -= dz
end

function EnergyBar:propegatePosition(dv)
  self.position -= dv
end

function EnergyBar:propegateScale(s)
  self.scale *= s
end