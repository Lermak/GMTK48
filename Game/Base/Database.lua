Resources = {
  "Red",
  "Green",
  "Blue"
}

CombinerRecipies = {
  { needed = {Resources[1]}, produce = {Resources[2]}}
}

SeperatorRecipies = {
  { needed = {Resources[1]}, produce = {Resources[2]}}
}

NumberRecipies = {
  { needed = {Resources[1]}, number = 3, produce = {Resources[2]}}
}

function Contains(t1, t2)
  if #t1 ~= #t2 then
    return false
  end
  local i = 0
  for k,v in pairs(t1) do
    for x,y in pairs(t2) do
      if v == y then
        i = i + 1
      end
    end
  end
  if i == #t1 then
    return true
  else
    return false
  end
end

Boards = {
  GameObject("Board", "Resources", function(self)end),
  GameObject("Board", "Continue", function(self)
    if self.inputs[1] ~= nil then
      if Contains(CombinerRecipies[1], GetAllInputsFor(self)) then
        self.outputs = CombinerRecipies[1].produce
      else
        self.outputs = {}
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


function IsOutputUsed(b, i)
  for k,v in pairs(Boards) do
    for x,y in pairs(v.inputs) do
      if y.board == b and y.port == i then
        print("used")
        return true
      end
    end
  end
  return false;
end

function ConnectBoards(b1, i, b2, o)
  if b1.inputs[i] == nil and not IsOutputUsed(b2,o) then
    b1.inputs[i] = {board = b2, port = o}
    b1:performOperation()    
  end
end

function DisconnectBoards(b, i)
  if b.inputs ~= nil and b.inputs[i] ~= nil then
    b.inputs[i] = nil
    b:performOperation()   
    b:cascade()
  end
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

function GetAllInputsFor(b)
  local t = {}
  for k,v in pairs(Boards) do
    for x,y in pairs(v.inputs) do
      t[#t + 1] = y.board[y.port]
    end
  end
  return t
end