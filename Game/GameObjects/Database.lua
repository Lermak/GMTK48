Resources = {
  "Blue",
  "Green"
}

Boards = {
  GameObject("Board", {}, {}, 
  function(self) 
    if self.inNodes[1] == Resources[1] then 
      self.outNodes[1] = Resources[2] 
      print("blue to green")
    end 
  end),--convert blue to green
  GameObject("Board", {Boards[1]}, {}, 
  function(self) 
    if self.inNodes[1] == Resources[2] then 
      self.outNodes[1] = Resources[1] 
      print("green to blue")
    end 
  end),--convert green to blue
  GameObject("Board", {}, {}, 
  function(self) 
    if self.inNodes[1] ~= nil then self.outNodes[1] = self.inNodes[1] 
      self.outNodes[2] = self.inNodes[1] 
      self.outNodes[3] = self.inNodes[1] 
      print("Split! " + self.inNodes[1]) 
    end 
  end) -- Splitter
}

function UpdateBoards()
  for i in pairs(Boards) do
    i:performOperation()
  end
end

function ConnectBoards(b1, b2, o, i)
  b2[i] = b1[o]
end

function DisconnectInput(b1, i)
  b1[i] = nil
end

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
  self:performOperation() = op
end

function Board:onUpdate(dt)
  -- Called every frame
end

function Board:onDestroy()
  -- Called when the object is destroyed
end
    