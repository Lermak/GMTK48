RenderTarget = {}

function RenderTarget:RenderTarget(width, height, zOrder)
  --Variable Initialization
  self.position = Vector2D(0, 0)
  self.scale = Vector2D(1, 1)
  self.width = width
  self.height = height
  self.alpha = 255
  self.zOrder = zOrder
  
  self.canvas = love.graphics.newCanvas(width, height)
end

function RenderTarget:draw()
  if self.shader then
    love.graphics.setShader(self.shader)
  end
  
  love.graphics.setColor(255, 255, 255, self.alpha)
  love.graphics.draw(self.canvas, self.position.x, -self.position.y, 0, self.scale.x, self.scale.y)
end


createClass("RenderTarget", RenderTarget)