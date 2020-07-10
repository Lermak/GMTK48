Resources = {
  "Blue",
  "Green"
}

function CreateSplitter(n)
  local g = GameObject("Board", {}, {}, 
  function(self) 
    if self.inNodes[1] ~= nil then 
      for i = 1, self.num do
        self.outNodes[i] = self.inNodes[1] 
      end
    end 
  end)
  g.num = n
  return g
end

Boards = {
  GameObject("Board", {}, Resources, function(self)end),
  GameObject("Board", {}, {}, 
  function(self) 
    if self.inNodes[1] == Resources[1] then 
      self.outNodes[1] = Resources[2] 
      print("blue to green")
    end 
  end),--convert blue to green
  GameObject("Board", {}, {}, 
  function(self) 
    if self.inNodes[1] == Resources[2] then 
      self.outNodes[1] = Resources[1] 
      print("green to blue")
    end 
  end),--convert green to blue
  CreateSplitter(3)-- Splitter
}

function UpdateBoards()
  for i,v in pairs(Boards) do
    v:performOperation()
  end
end

function ConnectBoards(b1, b2, o, i)
  b2.inNodes[i] = b1.outNodes[o]
end

function DisconnectInput(b1, i)
  b1[i] = nil
end