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

DEBUG_GRAPH = false
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
      input = { "Electricity", "Star" },
      output = "Leaf"
    },
    {
      input = { "Electricity", "Fish" },
      output = "Crab"
    },
    {
      input = { "Electricity", "Fire" },
      output = "Gear"
    },
    {
      input = { "Star", "Fish" },
      output = "Snowman"
    },
    {
      input = { "Star", "Fire" },
      output = "Moon"
    },
    {
      input = { "Fish", "Fire" },
      output = "Heart"
    },
    {
      input = { "Crab", "Clock" },
      output = "Radiation"
    },
    {
      input = { "Spider", "Snowman" },
      output = "Illuminati"
    },
    {
      input = { "Money", "Clock" },
      output = "Music"
    },
    {
      input = { "Leaf", "Sun" },
      output = "Squirrel"
    }
  },

  tick = function(self, input1, input2)
    for k,recipe in pairs(self.recipes) do
      if recipe.input[1] == input1 and recipe.input[2] == input2 
      or recipe.input[1] == input2 and recipe.input[2] == input1 then
        return { recipe.output }
      end
    end

    return { "" }
  end
}


Boards["Separator"] = {
  inputs = 1,
  outputs = 2,

  recipes = {
    { input = "Electricity", output = { "Sun", "Spider"} },
    { input = "Star", output = { "Sun", "Clock"} },
    { input = "Fish", output = { "Money", "Water"} },
    { input = "Fire",  output = { "Clock", "Trash"} },
    { input = "Sun",  output = { "Heart", "Gear"} },
    { input = "Spider",  output = { "Moon", "Snowman"} },
    { input = "Clock",  output = { "Crab", "Leaf"} },
    { input = "Money",  output = { "Gear", "Moon"} },
    { input = "Water",  output = { "Leaf", "Heart"} },
    { input = "Trash",  output = { "Snowman", "Crab"} },
  },

  tick = function(self, input1)
    for k,recipe in pairs(self.recipes) do
      if recipe.input == input1 then
        return { recipe.output[1], recipe.output[2] }
      end
    end

    return { "", "" }
  end
}

Boards["Producer"] = {
  inputs = 0,
  outputs = 3,
  resource = "Star",

  init = function(self, params)
    self.resource = params.resource
  end,

  tick = function(self)
    return { self.resource, self.resource, self.resource }
  end
}

Boards["Converter"] = {
  inputs = 1,
  outputs = 1,
  slider = 0,

  recipes = {
    { input = { "Electricity", 0 }, output = "Sun" },
    { input = { "Electricity", 1 }, output = "Clock" },
    { input = { "Electricity", 2 }, output = "Spider" },
    { input = { "Electricity", 3 }, output = "Trash" },

    { input = { "Star", 0 }, output = "Water" },
    { input = { "Star", 1 }, output = "Sun" },
    { input = { "Star", 2 }, output = "Money" },
    { input = { "Star", 3 }, output = "Clock" },

    { input = { "Fish", 0 }, output = "Water" },
    { input = { "Fish", 1 }, output = "Clock" },
    { input = { "Fish", 2 }, output = "Money" },
    { input = { "Fish", 3 }, output = "Trash" },

    { input = { "Fire", 0 }, output = "Clock" },
    { input = { "Fire", 1 }, output = "Trash" },
    { input = { "Fire", 2 }, output = "Water" },
    { input = { "Fire", 3 }, output = "Spider" },
    
    { input = { "Sun", 0 }, output = "Fire"},
    { input = { "Sun", 1 }, output = "Leaf" },
    { input = { "Sun", 2 }, output = "Electricity" },
    { input = { "Sun", 3 }, output = "Star" },
    
    { input = { "Spider", 0 }, output = "Crab" },
    { input = { "Spider", 1 }, output = "Heart" },
    { input = { "Spider", 2 }, output = "Fish" },
    { input = { "Spider", 3 },  output = "Clock" },
    
    { input = { "Clock", 0 }, output = "Snowman" },
    { input = { "Clock", 1 }, output = "Star" },
    { input = { "Clock", 2 }, output = "Water" },
    { input = { "Clock", 3 },  output = "Moon" },
    
    { input = { "Money", 0 }, output = "Fish" },
    { input = { "Money", 1 }, output = "Leaf" },
    { input = { "Money", 2 }, output = "Crab" },
    { input = { "Money", 3 },  output = "Water" },
    
    { input = { "Water", 0 }, output = "Snowman" },
    { input = { "Water", 1 }, output = "Gear" },
    { input = { "Water", 2 }, output = "Trash" },
    { input = { "Water", 3 },  output = "Money" },
    
    { input = { "Trash", 0 }, output = "Heart" },
    { input = { "Trash", 1 }, output = "Moon" },
    { input = { "Trash", 2 }, output = "Electricity" },
    { input = { "Trash", 3 },  output = "Sun" },
  },

  init = function(self, params)
    self.resource = params.slider
  end,

  tick = function(self, input)
    for k,recipe in pairs(self.recipes) do
      if recipe.input[1] == input and self.slider == recipe.input[2] then
        return { recipe.output }
      end
    end

    return { "" }
  end
}

Boards["Empty"] = {
  inputs = 0,
  outputs = 0,

  tick = function(self)
    return {}
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
  
  init = function(self, params)
    self.neededResource = params.resource
  end,
  tick = function(self, input)
    if input == self.neededResource then return {} else return nil end
  end
}

MODULE_LIST = {}
MODULE_IDX = 0

NODE_LIST = {}
NODE_IDX = 0

function AddModule(board, params)
  local module = {
    idx = MODULE_IDX,
    board = board,
    input = {},
    output = {},
    params = params,

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
      if self.connection ~= nil and NODE_LIST[self.connection].value == nil then
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
  if board.init ~= nil then board:init(module.params) end

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