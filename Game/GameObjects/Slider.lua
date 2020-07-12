----------------------------------------------------------------------
--[[
  Author: Rhen Niles
  Type: Game Object
  Description: A number selector from 0-3
]]
----------------------------------------------------------------------

local Slider = ...

function Slider:onInitialize(x,y)
  -- Called when the game object is constructed
  
  self:setImage("ModuleAssets/SlideRail.png")
  
  self.scale.x = 100
  self.scale.y = 38

  self.zOrder = 1

  self.pivot.x = 0.5
  self.pivot.y = 0.5

  self.position.x = x
  self.position.y = y

  self.knob = GameObject("SliderKnob", self.position.x, self.position.y)

  self.knob.minX = self.position.x - (self.scale.x/2 - self.knob.scale.x/2) - 1
  self.knob.maxX = self.position.x + (self.scale.x/2 - self.knob.scale.x/2) + 1

  self.value = 0
end

function Slider:getCurrentValue()
  return math.floor(((self.knob.position.x - self.position.x) / (self.scale.x/2 - self.knob.scale.x/2)) + 2)
end

function Slider:onUpdate(dt)
  -- Called every frame
  print(self:getCurrentValue())

end

function Slider:onDestroy()
  -- Called when the object is destroyed
end
    