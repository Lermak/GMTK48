Cursor = {
  inBoard = nil,
  inPort = nil,
  outBoard = nil,
  outPort = nil
}

function CheckCursorPlacement()
  if Cursor.inBoard ~= nil and
  Cursor.inPort ~= nil and
  Cursor.outBoard ~= nil and
  Cursor.outPort ~= nil then
    ConnectBoards(Cursor.inBoard, Cursor.inPort, Cursor.outBoard, Cursor.outPort)
    Cursor.inBoard = nil 
    Cursor.inPort = nil 
    Cursor.outBoard = nil
    Cursor.outPort = nil 
    GetAllConnections()
  end
end
