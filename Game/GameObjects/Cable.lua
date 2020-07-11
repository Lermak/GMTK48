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
  self.tension = 0.5
  self.placing = true
  self.dropPointOne = false
  self.dropPointTwo = false
  self:rebuild()
  self.visible = true
end

function Cable:rebuild()
  local p0 = self.p0
  local p1 = self.p1

  local dist = (p0 - p1):len()
  local tension = self.tension
  local slumpFactor = 1.0
  local slump = Vector2D();
  slump.y = (1.0 - tension) * (-dist);

  local controlPoint = slump + ((p0 + p1) / 2);
  
  local cx = controlPoint.x
  local cy = controlPoint.y
  local cp1 = Vector2D(p0.x + 2.0/3.0*(cx - p0.x), p0.y + 2.0/3.0*(cy - p0.y))
  local cp2 = Vector2D(p1.x + 2.0/3.0*(cx - p1.x), p1.y + 2.0/3.0*(cy - p1.y))

  local g = tove.newGraphics(nil, 1024)
  g:setLineWidth(10)
  g:moveTo(p0.x, p0.y)
  g:curveTo(cp1.x, cp1.y, cp2.x, cp2.y, p1.x, p1.y)

  local polyLen = (controlPoint - p0):len() + (controlPoint - p1):len()
  local lineLen = (p1 - p0):len()
  self.bezierLen = ((2 * lineLen + polyLen) / 3)

  local alpha = 1
  if self.placing then
    alpha = 0.75
  end

  g:setLineColor(1, 0, 0, alpha)
  g:stroke()
  g:setDisplay("mesh")
  self.cableMesh = g
end

function Cable:drop(point, isTrue)
  if point == "p0" then
    self.dropPointOne = isTrue
  elseif point == "p1" then
    self.dropPointTwo = isTrue
  end

  self.dropVec = Vector2D(0,0)
  self.initialPoint = self[point]
  self.initialLen = (self.p0 - self.p1):len()
  self.dropBezierLen = self.bezierLen
end

function Cable:onUpdate(dt)
  if self.placing then
    --self.dropPoint = "none"

    --self.p1 = Vector2D(MainCamera:mousePosition())
    self:rebuild()
  end

  if self.dropPointOne == true then
    local point = "p0"
    local otherPoint = "p1"
    
    self:fnDropPoint(point, otherPoint)
  else
    self.tension = 0.5
  end
  
  if self.dropPointTwo == true then
    local point = "p1"
    local otherPoint = "p0"
    
    self:fnDropPoint(point, otherPoint)
  
  else
    self.tension = 0.5
  end

end

function Cable:draw()
  if self.visible then
    love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
    self.cableMesh:draw()
  end
end

function Cable:onDestroy()
  -- Called when the object is destroyed
end
    
function Cable:fnDropPoint(point, otherPoint)


  self.dropVec.y -= dt * 2
  self[point] += self.dropVec

  local lineLen = ((self[point] - self[otherPoint]):len())
  local pullBack = lineLen >= self.dropBezierLen

  if not pullBack then
    local lenDiff = lineLen - self.initialLen
    local v = math.map(lenDiff, -self.initialLen, self.dropBezierLen, 0, 1)
    self.tension = Easing.InOutQuad(v, 0, 1, 1)
    pullBack = self.tension >= 1
  end

  if pullBack then
    local v = (self[otherPoint] - self[point]):normalize()
    self.dropVec += v * self.dropVec:len()
    self.dropVec *= 0.9
    self[point] = self[otherPoint] - v * self.dropBezierLen
  end

  self:rebuild()
end