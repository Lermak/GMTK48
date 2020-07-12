----------------------------------------------------------------------
--[[
  Author: Rhen Niles
  Type: Game Object
  Description: kob for slider object
]]
----------------------------------------------------------------------

local SliderKnob = ...

function SliderKnob:onInitialize()
  -- Called when the game object is constructed
  
  self:setImage("ModuleAssets/SlideSwitch.png")
  
  self.scale.x = 38
  self.scale.y = 38

  self.pivot.x = 0.5
  self.pivot.y = 0.5

  self.minX = 0
  self.maxX = 0
end

function SliderKnob:onUpdate(dt)
  -- Called every frame
  local mx, my = MainCamera:mousePosition()
  local l = (self.position - Vector2D(mx, my)):len()
  if l < self.scale.x then
    if love.mouse.isDown(1) and Cursor.wireEnd == nil then
      self.position.x = mx
      if self.position.x < self.minX then
        self.position.x = self.minX
      elseif self.position.x > self.maxX then
        self.position.x = self.maxX
      end
    end
  end
end

function SliderKnob:onDestroy()
  -- Called when the object is destroyed
end
    