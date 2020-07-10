ImageManager = {}

function ImageManager.getImage(name)
  if ImageManager[name] then return ImageManager[name] end
  
  ImageManager[name] = love.graphics.newImage(name)
  return ImageManager[name]
end


--Image Class
Image = {}

function Image:Image(name, useSize)
  self.image = ImageManager.getImage("Data/Images/" .. name)
  self.imageScale = Vector2D(1 / self.image:getWidth(), -1 / self.image:getHeight())

  self.position = Vector2D(0,0)
  self.scale = Vector2D(1,1)
  self.rotation = 0
  self.faceX = 1
  self.faceY = 1
  self.pivot = Vector2D(0.5, 0.5)
  self.color = Color(255,255,255,255)

  if useSize then
    self.scale = Vector2D(self.image:getWidth(), self.image:getHeight())
  end
end

function Image:draw()
  local x = self.position.x
  local y = self.position.y
  local hudFix = 1
  if DrawingHUD then
    hudFix = -1
  end

  love.graphics.setColor(self.color:unpack())
  love.graphics.draw(self.image, x, y, math.rad(self.rotation), self.imageScale.x * self.scale.x * self.faceX, hudFix * self.imageScale.y * self.scale.y * self.faceY, self.pivot.x / math.abs(self.imageScale.x), self.pivot.y / math.abs(self.imageScale.y))
end


createClass("Image", Image)