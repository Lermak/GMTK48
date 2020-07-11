Resources = {
  "Green",
  "Red"
}
Boards = {
  GameObject("Board", "Resources", function(self)end),
  GameObject("Board", "b1", function(self)
    if self.inputs[1] ~= nil then
      if self.inputs[1].board.outputs[self.inputs[1].port] == Resources[1] then
        self.outputs[1] = Resources[1]
      else
        self.outputs[1] = nil
      end
      self:cascade()
    end
  end),
  GameObject("Board", "b2", function(self)
    if self.inputs[1] ~= nil then
      if self.inputs[1].board.outputs[self.inputs[1].port] == Resources[1] then
        self.outputs[1] = Resources[2]
      else
        self.outputs[1] = nil     
      end
      self:cascade()
    end   
  end),
  GameObject("Board", "b3", function(self)
    if self.inputs[1] ~= nil and self.inputs[1].board.outputs[self.inputs[1].port] == Resources[2] then
      print("yes")
    else
      print("no")
    end
  end),
  GameObject("Board", "ThreeSplitter", function(self)
    local r = self.inputs[1].board.outputs[self.inputs[1].port]
    if self.inputs[1] ~= nil and r ~= nil then
      self.outputs[1] = r
      self.outputs[2] = r
      self.outputs[3] = r
    else
      self.outputs[1] = nil
      self.outputs[2] = nil
      self.outputs[3] = nil
    end
  end),
}

Boards[1].outputs = Resources

function UpdateBoards()
  for k,v in pairs(Boards) do
    v:performOperation()
  end
end

function ConnectBoards(b1, i, b2, o)
  if b1.inputs[i] == nil then
    b1.inputs[i] = {board = b2, port = o}
    b1:performOperation()    
  end
end

function DisconnectBoards(b, i)
  b.inputs[i] = nil
end

function GetAllConnections()
  local t = {}
  for k,v in pairs(Boards) do
    for x,y in pairs(v.inputs) do
      t[#t + 1] = {v, x, y.board, y.port}
      print(v.name .. " input " .. x .. " to " .. y.board.name .. " output " .. y.port)
    end
  end
  return t
end