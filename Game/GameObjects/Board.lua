----------------------------------------------------------------------
--[[
  Author: Rhen Niles
  Type: Game Object
  Description: Modular Board object
]]
----------------------------------------------------------------------

local Board = ...


function Board:onInitialize(n, op)
  -- Called when the game object is constructed
  self.outputs = {}
  self.inputs = {}
  self.name = n
  self.performOperation = op
  self.inputs = {}
  for k,v in pairs(self.inputs) do
    local mi = GameObject("ModuleInput", Color(255,255,255))
    mi.position.x = -1
    mi.position.y = i
    
    self.inputs[i] = mi
  end
  
end

function Board:onUpdate(dt)
  -- Called every frame
end

function Board:onDestroy()
  -- Called when the object is destroyed
end
    