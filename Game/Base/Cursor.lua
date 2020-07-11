Cursor = {
  inBoard = nil,
  inPort = nil,
  outBoard = nil,
  outPort = nil,
  cable = nil
}

function CheckCursorPlacement(obj)
  if Cursor.cable == nil then
    local v = obj.position:clone()
    Cursor.cable = GameObject("Cable", v, v)
    obj.cabl = Cursor.cable
  end

  if Cursor.inBoard ~= nil and
  Cursor.inPort ~= nil and
  Cursor.outBoard ~= nil and
  Cursor.outPort ~= nil then
    ConnectBoards(Cursor.inBoard, Cursor.inPort, Cursor.outBoard, Cursor.outPort)
    Cursor.cable.placing = false
    Cursor.cable.p1 = obj.position:clone()
    Cursor.cable:rebuild()
    obj.cabl = Cursor.cable
    
    Cursor.cable = nil
    Cursor.inBoard = nil 
    Cursor.inPort = nil 
    Cursor.outBoard = nil
    Cursor.outPort = nil 
    GetAllConnections()
  end
end