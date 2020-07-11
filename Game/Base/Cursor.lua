Cursor = {
  inBoard = nil,
  inPort = nil,
  outBoard = nil,
  outPort = nil,
  wireEnd = nil
}

function CheckCursorPlacement(obj)
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

function CursorHasInput()
  return Cursor.inPort ~= nil and Cursor.inBoard ~= nil
end

function CursorHasOutput()
  return Cursor.outPort ~= nil and Cursor.outBoard ~= nil
end