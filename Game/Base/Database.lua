Resources = {
  "Blue",
  "Green"
}

Connections = {
  
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
    end 
  end),--convert blue to green
  GameObject("Board", {}, {}, 
  function(self) 
    if self.inNodes[1] == Resources[2] then 
      self.outNodes[1] = Resources[1] 
    end 
  end),--convert green to blue
  CreateSplitter(3),-- Splitter
  GameObject("Board", {}, {}, 
  function (self)      
    if self.inNodes[1] == Resources[1] and self.inNodes[2] == Resources[1] then
      print("Yay")
    end
  end)--ship system
}

function UpdateBoards()
  for i,v in pairs(Boards) do
    v:performOperation()
  end
end

function ConnectBoards(b1, o, b2, i)
  b2.inNodes[i] = b1.outNodes[o]
  Connections[Connections.len] = {b2.inNodes[i], b1.outNodes[o]}
end

function DisconnectInput(b1, i)
  b1[i] = nil
  for k,v in Connections do
    if v[1] == b1 then
      Connections[k] = nil
    end
  end
end