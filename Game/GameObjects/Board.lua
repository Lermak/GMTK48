----------------------------------------------------------------------
--[[
  Author: Rhen Niles
  Type: Game Object
  Description: Modular Board object
]]
----------------------------------------------------------------------

local Board = ...


function Board:onInitialize(i, o, op)
  -- Called when the game object is constructed
  self.inNodes = i
  self.outNodes = o 
  self.performOperation = op
end

function Board:onUpdate(dt)
  -- Called every frame
end

function Board:onDestroy()
  -- Called when the object is destroyed
end
    