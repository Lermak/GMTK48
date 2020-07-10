----------------------------------------------------------------------
--[[
  Author: Corbin McBride
  Type: Game Object
  Description:
]]
----------------------------------------------------------------------

local Module = ...

function Module:onInitialize(position)
  -- Called when the game object is constructed
  --this is for the module
  self.shape = "rectangle"
  self.scale.x = 4.0
  self.scale.y = 4.0
  self.pivot.x = 0.5
  self.pivot.y = 0.5
  self.position = position
  self.input = GameObject("ModuleInput", Color(255, 0, 0))
  self.input.zOrder = 1
  self.output = GameObject("ModuleOutput", Color(0,255,0))
  self.output.zOrder = 1
  
end

function Module:onUpdate(dt)
  -- Called every frame
  self.input.position.x = self.position.x + 1
  self.input.position.y = self.position.y - 0.5

  self.output.position.x = self.position.x - 1
  self.output.position.y = self.position.y - 0.5
  
end

function Module:onDestroy()
  -- Called when the object is destroyed
end
    