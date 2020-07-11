Resources = {
  "Red",
  "Green",
  "Blue"
}

CombinerRecipies = {
  { needed = {Resources[1], Resources[2]}, produce = {Resources[3]}},
  { needed = {Resources[2], Resources[3]}, produce = {Resources[1]}}
}

SeperatorRecipies = {
  { needed = {Resources[1]}, produce = {Resources[2], Resources[2]}}
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
  GameObject("Board", "c1", function(self)
    if self.inputs[1] ~= nil then
      print(#CombinerRecipies[1].needed, #GetAllInputsFor(self))
      if Contains(CombinerRecipies[1].needed, GetAllInputsFor(self)) then
        print("changed")
        self.outputs = CombinerRecipies[1].produce
      else
        self.outputs = {}
      end
      self:cascade()
    end
  end),
  GameObject("Board", "c2", function(self)
    if self.inputs[1] ~= nil then
      if Contains(CombinerRecipies[2].needed, GetAllInputsFor(self)) then
        self.outputs[1] = CombinerRecipies[2].produce
      else
        self.outputs[1] = nil     
      end
      self:cascade()
    end   
  end),
  GameObject("Board", "Splitter", function(self)
    if self.inputs[1] ~= nil then
      local r = self.inputs[1].board.outputs[self.inputs[1].port]
      if r ~= nil then
        self.outputs[1] = r
        self.outputs[2] = r
      else
        self.outputs[1] = nil
        self.outputs[2] = nil
      end
    end
  end),
}


function IsOutputUsed(b, i)
  for k,v in pairs(Boards) do
    for x,y in pairs(v.inputs) do
      if y.board == b and y.port == i then
        return true
      end
    end
  end
  return false;
end

function IsInputUsed(b, p)
  if b.inputs == nil or b.inputs[p] == nil then
    return false
  else
    return true
  end
end

function ConnectBoards(b1, i, b2, o)
  if b1.inputs[i] == nil and IsOutputUsed(b2,o) == false then
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
      t[#t + 1] = {v, x, y.board, y.port}
      local out = ""
      if y.board.outputs[y.port] ~= nil then
        out = y.board.outputs[y.port]
      else
        out = "nil"
      end
      print("Output "..y.board.name.."["..y.port.."]("..out..") connects to Input "..v.name.."["..x.."]")
      
    end
  end
  return t
end

function GetAllInputsFor(b)
  local t = {}
  for k,v in pairs(Boards) do
    for x,y in pairs(v.inputs) do
      if v == b then
        t[#t + 1] = y.board.outputs[y.port]
      end
    end
  end
  return t
end