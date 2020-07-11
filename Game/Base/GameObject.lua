_G.GameObjectList = {}
_G.GameObjectCount = 0

_G.GameObjectInitList = {}

GameObject = {}

DefaultRenderTarget = nil

function GameObject:GameObject(name, ...)
  -- Variable Initialization
  self.id = _G.GameObjectCount

  -- Insert into global table
  _G.GameObjectList[self.id] = self
  _G.GameObjectCount += 1
  
  -- Various variables
  self.name = name
  self.position = Vector2D()
  self.offset = Vector2D()
  self.scale = Vector2D(1, 1)
  self.color = Color(255, 255, 255, 255)
  self.shape = "circle"
  self.rotation = 0
  self.zOrder = 0
  self.pivot = Vector2D(0.5, 1)
  self.lifetime = 0
  self.renderTarget = DefaultRenderTarget
  self.visible = true
  self.faceX = 1
  self.faceY = 1
  self.hasPostInitialized = false
  self.squashAmount = 1.0
  
  self._OnDraw = self.OnDraw
  
  -- Load the special game object information
  if name then
    local f,err = love.filesystem.load("GameObjects/" .. name .. ".lua")
    if not f then love.errhand(err) end
    f(self)
  end

  self:onInitialize(unpack({...}))
end

function GameObject:update(dt)
  if not self.hasPostInitialized then
    self.hasPostInitialized = true
    self:onPostInitialize()
  end

  self.lifetime += dt
  self:onUpdate(dt)
end

function GameObject:draw()
  -- Call object's draw function
  self:onDraw()
end

function GameObject:setImage(name)
  self.image = ImageManager.getImage("Data/Images/" .. name)
  self.imageScale = Vector2D(1 / self.image:getWidth(), -1 / self.image:getHeight())
  self.shape = ""
end

function GameObject:drawMesh()
  -- Set color
  love.graphics.setColor(self.color.r / 255, self.color.g / 255, self.color.b / 255, self.color.a / 255)

  self:coreDraw()
end

function GameObject:coreDraw()
  local x = self.position.x + self.offset.x
  local y = self.position.y + self.offset.y

  local squashScale = Vector2D(self.scale.x, self.scale.y)

  squashScale.x = self.scale.x * self.squashAmount
  squashScale.y = self.scale.y * (1 / self.squashAmount)

  -- Draw image if it's set
  if self.image then
    love.graphics.draw(self.image, x, y, math.rad(self.rotation), self.imageScale.x * squashScale.x * self.faceX, self.imageScale.y * squashScale.y * self.faceY, self.pivot.x / math.abs(self.imageScale.x), self.pivot.y / math.abs(self.imageScale.y))
  -- Otherwise draw the specific shape
  elseif self.shape == "rectangle" then
    love.graphics.draw(_RectangleMesh, x, y, math.rad(self.rotation), squashScale.x, squashScale.y, self.pivot.x, self.pivot.y)
  elseif self.shape == "circle" then
    love.graphics.circle("fill", x, y, squashScale.x * 0.5, 20)
  end
end

function GameObject:destroy()
  if self.id == nil then return end
  
  -- Destroy the object and clean up the game object list
  self:onDestroy()
  _G.GameObjectList[self.id] = nil
  self.id = nil
end

function GameObject:onInitialize()
end

function GameObject:onPostInitialize()
end

function GameObject:onUpdate(dt)
end

function GameObject:onDraw()
  -- Draw mesh of the object
  if self.shader then
    love.graphics.setShader(self.shader)
  end

  self:drawMesh()

  if self.shader then
    love.graphics.setShader()
  end
end

function GameObject:onDestroy()
end

createClass("GameObject", GameObject)