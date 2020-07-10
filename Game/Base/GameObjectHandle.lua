GameObjectHandle = {}

function GameObjectHandle:GameObjectHandle(id)
  if type(id) == "table" then
    id = id.id
  end

  self.id = id

  setmetatable(self, {
    __index = function(table, key)
      if key == "setHandle" then
        return function(t, id)
          rawset(t, "id", id)
        end
      elseif key == "valid" then
        return function(t)
          return _G.GameObjectList[rawget(t, "id")] ~= nil
        end
      end

      local obj = _G.GameObjectList[rawget(table, "id")]
      if obj == nil then return nil end
      return obj[key];
    end,

    __newindex = function(table, key, value)
      local obj = _G.GameObjectList[rawget(table, "id")]
      if obj == nil then return nil end
      obj[key] = value
    end
  })
end

createClass("GameObjectHandle", GameObjectHandle)