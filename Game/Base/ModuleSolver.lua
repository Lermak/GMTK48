function ArrayRemove(t, fnKeep)
  local j, n = 1, #t;

  for i=1,n do
      if (fnKeep(t, i, j)) then
          -- Move i's kept value to j's position, if it's not already there.
          if (i ~= j) then
              t[j] = t[i];
              t[i] = nil;
          end
          j = j + 1; -- Increment position of where we'll place the next kept value.
      else
          t[i] = nil;
      end
  end

  return t;
end

Boards = {}

local DEBUG_GRAPH = false
local dbg_print = function(...)
  if DEBUG_GRAPH then print(...) end
end

local ERROR_INVALID_INPUT = "Invalid Input"
local EMPTY_VALUE = ""

Boards["Combiner"] = {
  inputs = 2,
  outputs = 1,

  recipes = {
    {
      input = { "Star", "Star" },
      output = "Crab"
    },
    {
      input = { "Crab", "Crab" },
      output = "Electricity" 
    },
  },

  tick = function(self, input1, input2)
    for k,recipe in pairs(self.recipes) do
      if recipe.input[1] == input1 and recipe.input[2] == input2 then
        return { recipe.output }
      end
    end

    return { "" }
  end
}

Boards["Producer"] = {
  inputs = 0,
  outputs = 1,

  tick = function(self)
    return {"Star"}
  end
}

Boards["Doubler"] = {
  inputs = 1,
  outputs = 2,

  tick = function(self, input1)
    return { input1, input1 }
  end
}

Boards["Ship System"] = {
  inputs = 1,
  outputs = 0,
  
  tick = function(self, input)
    if input == "Crab" then return {} else return nil end
  end
}

MODULE_LIST = {}
MODULE_IDX = 0

NODE_LIST = {}
NODE_IDX = 0

function AddModule(board)
  local module = {
    idx = MODULE_IDX,
    board = board,
    input = {},
    output = {},

    setOutputError = function(self)
      for k,v in pairs(self.output) do
        v.value = EMPTY_VALUE
      end
    end,
  }

  MODULE_LIST[MODULE_IDX] = module
  MODULE_IDX += 1

  return MODULE_IDX - 1
end

function RemoveModule(idx)
  MODULE_LIST[idx] = nil
end

function AddNode(type, module_id, index)
  local node = {
    idx = NODE_IDX,
    type = type,
    module_id = module_id,
    index = index,
    connection = nil,
    value = nil,

    setValue = function(self, value)
      self.value = value
      if self.connection ~= nil then
        dbg_print("  Propegation to Node #" .. self.connection)
        NODE_LIST[self.connection].value = value
      end
    end
  }

  MODULE_LIST[module_id][type][index] = node

  NODE_LIST[NODE_IDX] = node
  NODE_IDX += 1

  return NODE_IDX - 1
end

function ConnectNode(i1, i2)
  local n1 = NODE_LIST[i1]
  local n2 = NODE_LIST[i2]

  if n1 == nil or n2 == nil then
    error("INVALID INDEX SPECIFIED FOR CONNECTION! " .. i1 .. " <--> " .. i2)
  end

  dbg_print("Connect Node " .. i1 .. " to Node " .. i2)

  n1.connection = i2
  n2.connection = i1
end

function DisconnectNode(idx)
  local node = NODE_LIST[idx]
  if node == nil then error("Invalid node index!") end

  if node.connection then
    NODE_LIST[node.connection].connection = nil
  end

  node.connection = nil
end

function RemoveNode(idx)
  NODE_LIST[idx] = nil
end

function tickModule(module, inputs)
  dbg_print("Ticking Module " .. module.idx)

  for k,v in pairs(inputs) do
    dbg_print("  Input " .. k .. ": \"" .. v .. "\"")
  end

  local board = module.board

  local valid, res = pcall(board.tick, board, unpack(inputs))
  if valid then
    if res == nil then
      dbg_print("NO OUTPUT!")
      module:setOutputError()
      return
    end

    if #res == board.outputs then
      for i=1, board.outputs do
        dbg_print("  Module Output #" .. i .. " to Node #" .. module.output[i].idx .. ": \"" .. res[i] .. "\"")
        module.output[i]:setValue(res[i])
      end
    else
      dbg_print("Module returned " .. #res .. "outputs, but we expected " .. #module.outputs .. "!")
      module:setOutputError()
      return
    end
  else
    print("  Module had an error when ticking!")
    print(res)
    module:setOutputError()
  end
end

function SolveGraph()
  dbg_print("----------- START OF SOLVE -------------------")

  for k,v in pairs(NODE_LIST) do
    if v.type == "input" and v.connection then
      v.value = nil
    else
      v.value = EMPTY_VALUE
    end
  end

  local UnsolvedModules = {}
  for k,v in pairs(MODULE_LIST) do
    table.insert(UnsolvedModules, v)
  end

  local anySatisfied = false

  while #UnsolvedModules ~= 0 do
    anySatisfied = false

    ArrayRemove(UnsolvedModules, function(t, i)
      local module = t[i]

      local inputs = {}
      for k,v in pairs(module.input) do
        if v.value ~= nil then
          table.insert(inputs, v.value)
        end
      end

      --Don't have enough inputs, can't solve
      if #inputs ~= #module.input then
        dbg_print("Module " .. module.idx .. " had " .. #inputs .. " inputs, but needed " .. #module.input .. " to tick.")
        return true
      end

      tickModule(module, inputs)
      anySatisfied = true
      return false
    end)

    if not anySatisfied then
      dbg_print("UNSOLVABLE")
      break
    end
  end

  dbg_print("----------- END OF SOLVE -------------------\n\n\n")
end



--function IsOutputUsed(b, i)
--  
--end
--
--function IsInputUsed(b, p)
--  
--end
--
--function ConnectBoards(b1, i, b2, o)
--  
--end
--
--function DisconnectBoards(b, i)
--  
--end
--
--function GetAllConnections()
--  
--end
--
--function GetAllInputsFor(b)
--  
--end