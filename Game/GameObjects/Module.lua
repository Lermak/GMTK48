----------------------------------------------------------------------
--[[
  Author: Corbin McBride
  Type: Game Object
  Description:
]]
----------------------------------------------------------------------

local Module = ...

function Module:onInitialize(img,position, inputs, outputs)
  -- Called when the game object is constructed
  --this is for the module
  self:setImage("ModuleAssets/Frame.png")
  self.scale.x = 4.0
  self.scale.y = 4.0
  self.pivot.x = 0.5
  self.pivot.y = 0.5
  self.position = position
  self.zOrder = -1
  self.input = {}
  self.output = {}
  for k,v in pairs(inputs) do
    self.input[#self.input + 1] = v[1]
    self.input[#self.input].position.x = self.position.x + v[2]
    self.input[#self.input].position.y = self.position.y + v[3]
    self.input[#self.input].zOrder = 1
    self.input[#self.input]:setupWireEnd()
  end

  for k,v in pairs(outputs) do
    self.output[#self.output + 1] = v[1]
    self.output[#self.output].position.x = self.position.x + v[2]
    self.output[#self.output].position.y = self.position.y + v[3]
    self.output[#self.output].zOrder = 1
    self.output[#self.output]:setupIconScreen()
    self.output[#self.output]:setupIcon()
    self.output[#self.output]:setupWireEnd()
  end
end

function Module:onUpdate(dt)
  -- Called every frame  
end

function Module:onDestroy()
  -- Called when the object is destroyed
end
    