----------------------------------------------------------------------
--[[
  Author: Alexander Wilkinson
  Type: Game Object
  Description: Image and text for credits
]]
----------------------------------------------------------------------

local CreditsCard = ...

function CreditsCard:onInitialize()
  -- Called when the game object is constructed
  self.visible = false

  self.titleFont = love.graphics.newFont("Data/Fonts/KenPixel Mini Square.ttf", 40)
  self.nameFont = love.graphics.newFont("Data/Fonts/KenPixel Mini Square.ttf", 32)
end

function CreditsCard:onUpdate(dt)
  -- Called every frame
end

function CreditsCard:drawHUD()
  -- Draw Credits
  love.graphics.setColor(255, 255, 255, self.color.a)

  local srcHeight = love.graphics.getHeight()
  local srcWidth = love.graphics.getWidth()

  local titleX = 440
  local nameX = titleX + 80

  -- Created By
  love.graphics.setFont(self.titleFont)
  love.graphics.printf("Created By", 0, 40, 1200, "center")

  -- Alexander Wilkinson
  love.graphics.setFont(self.nameFont)
  love.graphics.printf("Alexander Wilkinson", 0, 110, 1200, "center")

  -- Wesley Pesetti
  love.graphics.printf("Wesley Pesetti", 0, 150, 1200, "center")

  -- Rhen Niles
  love.graphics.printf("Rhen Niles", 0, 190, 1200, "center")

  -- Corbin Mcbride
  love.graphics.printf("Corbin Mcbride", 0, 230, 1200, "center")

  -- Sound From
  love.graphics.setFont(self.titleFont)
  love.graphics.printf("Sound From", 0, 340, 1200, "center")

  love.graphics.setFont(self.nameFont)
  love.graphics.printf("Kenney - www.kenney.nl", 0, 400, 1200, "center")

  -- Music
  love.graphics.setFont(self.titleFont)
  love.graphics.printf("Music From", 0, 480, 1200, "center")

  love.graphics.setNewFont(16)

  love.graphics.printf("Machinations by Kevin MacLeod", 140, 550, 1200, "left")
  love.graphics.printf("Link: https://incompetech.filmmusic.io/song/4011-machinations", 140, 574, 1200, "left")
  love.graphics.printf("License: http://creativecommons.org/licenses/by/4.0/", 140, 598, 1200, "left")

  love.graphics.printf("Lobby Time by Kevin MacLeod", 680, 550, 1200, "left")
  love.graphics.printf("Link: https://incompetech.filmmusic.io/song/3986-lobby-time", 680, 574, 1200, "left")
  love.graphics.printf("License: http://creativecommons.org/licenses/by/4.0/", 680, 598, 1200, "left")

  -- Press Any Key to Continue
  love.graphics.setColor(200, 200, 200, self.color.a)
  love.graphics.setFont(DefaultFont)
  love.graphics.printf("Press any key to continue...",
    0,
    love.graphics.getHeight() / 2 + 315,
    1280,
    "center")
end

function CreditsCard:onDestroy()
  -- Called when the object is destroyed
end
    