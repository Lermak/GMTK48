Resources = {
  "Red",
  "Green",
  "Blue"
}
Boards = {
  GameObject("Board", "Resources", function(self)end),
  GameObject("Board", "Continue", function(self)
    if self.inputs[1] ~= nil then
      if self.inputs[1].board.outputs[self.inputs[1].port] == Resources[1] then
        self.outputs[1] = Resources[1]
      else
        self.outputs[1] = nil
      end
      self:cascade()
    end
  end),
  GameObject("Board", "Red to Green", function(self)
    if self.inputs[1] ~= nil then
      if self.inputs[1].board.outputs[self.inputs[1].port] == Resources[1] then
        self.outputs[1] = Resources[2]
      else
        self.outputs[1] = nil     
      end
      self:cascade()
    end   
  end),
  GameObject("Board", "Output", function(self)
    if self.inputs[1] ~= nil then
      local inputResource = self.inputs[1].board.outputs[self.inputs[1].port]
      local inR = ""
      if inputResource ~= nil then
        inR = inputResource
      else
        inR = "nil"
      end
      print("Need: "..Resources[3].." Have: "..inR)
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
      t[#t + 1] = {v.name, x, y.board.name, y.port}
      local out = ""
      if y.board.outputs[y.port] ~= nil then
        out = y.board.outputs[y.port]
      else
        out = "nil"
      end
      print(""..y.board.name.."["..y.port.."]("..out..") connects to "..v.name.."["..x.."]")
      
    end
  end
  return t
end