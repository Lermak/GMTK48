----------------------------------------------------------------------
--[[
  Author: Alex Wilkinson
  Type: Game Object
  Description: Object to display on main menu
]]
----------------------------------------------------------------------

local TitleCard = ...

function TitleCard:onInitialize()
  -- Called when the game object is constructed
  self.visible = false

  self.pivot = Vector2D(0.5, 0.5)

  self.scale.x = 1280
  self.scale.y = 720
  
  self.textFont = love.graphics.newFont("Data/Fonts/KenPixel Mini Square.ttf", 40)
  self.textFont2 = love.graphics.newFont("Data/Fonts/KenPixel Mini Square.ttf", 24)

  self.backImg = ImageManager.getImage("Data/Images/Title/Background.png")
  self.backImgScale = Vector2D(1 / self.backImg:getWidth(), 1 / self.backImg:getHeight())
  
  self.titleImg = ImageManager.getImage("Data/Images/Title/Title.png")
  self.titleImgScale = Vector2D(1 / self.titleImg:getWidth(), 1 / self.titleImg:getHeight())
  self.titleHeightOff = -10

  self.titleFloatCo = makeCoroutine(function()
    overTime(250, function(p)
      self.titleHeightOff = math.sin(p * 360) * 20 - 10
    end)
  end)

  
end

function TitleCard:onUpdate(dt)
  -- Called every frame
  if self.titleFloatCo then self.titleFloatCo:resume() end
end

function TitleCard:drawHUD()
  -- Draw title
  local w = love.graphics.getWidth()
  local h = love.graphics.getHeight()
  local x = w / 2
  local y = h / 2

  -- Draw Background
  love.graphics.setColor(1,1,1,self.color.a)
  love.graphics.draw(self.backImg, x, y, 0, w * self.backImgScale.x, h * self.backImgScale.y, self.pivot.x / math.abs(self.backImgScale.x), self.pivot.y / math.abs(self.backImgScale.y))

  -- Draw Title
  love.graphics.draw(self.titleImg, x, y + self.titleHeightOff, 0, w * self.titleImgScale.x, h * self.titleImgScale.y, self.pivot.x / math.abs(self.titleImgScale.x), self.pivot.y / math.abs(self.titleImgScale.y))
  --drawText("Engineering Chaos", Vector2D(0, 0 + self.titleHeightOff), 1280, 200, nil, Color(0.1, 0.1, 0.1))
  
  local text_pos = 720/2 - 4*720/32
  love.graphics.setFont(self.textFont2)
  love.graphics.setColor(0,0,0,self.color.a)
  love.graphics.printf("You will need the PDF included with your executable\nplease open it before you continue",
    0, y + 64, 1280-48, "center")
    love.graphics.setColor(1,1,1,self.color.a)
  

  -- Draw Text
  local text_pos = 720/2 - 4*720/32
  love.graphics.setFont(self.textFont)
  love.graphics.printf("Press any key to continue...", 0, y + text_pos, 1280,"center")
    

  love.graphics.setFont(self.textFont2)
  love.graphics.printf("Press C for Credits", 0, y + text_pos+32, 1280-48, "right")
end

function TitleCard:onDestroy()
  -- Called when the object is destroyed
end