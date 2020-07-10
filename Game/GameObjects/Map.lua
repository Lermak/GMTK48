----------------------------------------------------------------------
--[[
  Author: Alexander Wilkinson
  Type: Game Object
  Description: OBject that holds the loaded tile map
]]
----------------------------------------------------------------------

local Map = ...

function Map:onInitialize(name)
  self.shape = nil
  self.zOrder = -10
  self.map = TiledMap(name)
end

function Map:onUpdate(dt)
end

function Map:onDraw()
  self.map:draw()
end

function Map:onDestroy()
end
