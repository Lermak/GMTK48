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
end

function Board:cascade()
  for k,v in pairs(Boards) do
    for x,y in pairs(v.inputs) do
      if y.board == self then
        v:performOperation()
      end
    end
  end
end

function Board:onUpdate(dt)
  -- Called every frame
end

function Board:onDestroy()
  -- Called when the object is destroyed
end
    