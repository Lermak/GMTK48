----------------------------------------------------------------------
--[[
  Author:
  Type: Game Object
  Description:
]]
----------------------------------------------------------------------
local Cable = ...

function Cable:onInitialize(p0, p1)
  -- Called when the game object is constructed
  self.p0 = p0
  self.p1 = p1

  local dist = (p0 - p1):len()
  local tension = 0.5
  local slumpFactor = 1.0
  local slump = Vector2D();
  slump.y = (1.0 - tension) * (slumpFactor - 1.0 * dist);
  local controlPoint = slump + ((p0 + p1) / 2);
  
  local cx = controlPoint.x
  local cy = controlPoint.y
  local cp1 = Vector2D(p0.x + 2.0/3.0*(cx - p0.x), p0.y + 2.0/3.0*(cy - p0.y))
  local cp2 = Vector2D(p1.x + 2.0/3.0*(cx - p1.x), p1.y + 2.0/3.0*(cy - p1.y))

  local g = tove.newGraphics(nil, 1024)
  g:setLineWidth(0.05)
  g:moveTo(p0.x, p0.y)
  g:curveTo(cp1.x, cp1.y, cp2.x, cp2.y, p1.x, p1.y)
  g:setLineColor(255, 0, 0, 255)
  g:stroke()
  g:setDisplay("mesh")
  self.cableMesh = g
end

function Cable:onUpdate(dt)
  -- Called every frame
end

function Cable:draw()
  love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
  self.cableMesh:draw()
end

function Cable:onDestroy()
  -- Called when the object is destroyed
end
    
