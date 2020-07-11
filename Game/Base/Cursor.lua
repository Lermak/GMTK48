Cursor = {
  input = nil,
  output = nil,
  cable = nil,
}

function CheckCursorPlacement(obj)
  local function tryMakeCable()
    if Cursor.cable == nil then
      local v = obj.position:clone()
      Cursor.cable = GameObject("Cable", v, v)
      Cursor.cable.zOrder = 10
      obj.cable = GameObjectHandle(Cursor.cable)
    end
  end

  if obj.nodeType == "input" and Cursor.input == nil and NODE_LIST[obj.nodeIdx].connection == nil then
    Cursor.input = {module = obj.moduleIdx, node = obj.nodeIdx}
    tryMakeCable()
  end

  if obj.nodeType == "output" and Cursor.output == nil and NODE_LIST[obj.nodeIdx].connection == nil then
    Cursor.output = {module = obj.moduleIdx, node = obj.nodeIdx}
    tryMakeCable()
  end

  if Cursor.input and Cursor.output then
    Cursor.cable.placing = false
    Cursor.cable.p1 = obj.position:clone()
    Cursor.cable:rebuild()
    obj.cable = GameObjectHandle(Cursor.cable)

    ConnectNode(Cursor.input.node, Cursor.output.node)

    Cursor.input = nil
    Cursor.output = nil
    Cursor.cable = nil
  end
end

function CursorHasInput()
  return Cursor.input ~= nil
end

function CursorHasOutput()
  return Cursor.output ~= nil
end