function waitSeconds(seconds)
  local curTime = 0.0
  
  while(true) do
    curTime = curTime + love.timer.getDelta()
    
    if curTime > seconds then
      coroutine.yield()
      return
    else
      coroutine.yield()
    end
  
  end
end

function print_table(tab)
  for k,v in pairs(tab) do
    print(k,v)
  end
end

function inCameraVierport(pos, scale)
  if pos.x < (MainCamera.x + (-love.graphics.getWidth() / (2 * WorldScale)) + scale.x /2) or
     pos.x > (MainCamera.x + ( love.graphics.getWidth() / (2 * WorldScale)) - scale.x /2) or
     pos.y < (MainCamera.y + (-love.graphics.getHeight() / (2 * WorldScale)) + scale.x /2) or
     pos.y > (MainCamera.y + (love.graphics.getHeight() / (2 * WorldScale)) - scale.x /2)
     then
     return false
  end
  
  return true
end

function overTime(totalTime, callback, cor)
  cor = cor or false
  local curTime = 0.0
  local co
  
  if cor then
    co = coroutine.create(callback)
  end
  
  while curTime < totalTime do
  
    if cor then
      coroutine.resume(co,curTime / totalTime, curTime, totalTime)
    else
      local val = callback(curTime / totalTime, curTime, totalTime)
      if val then
        break
      end
    end
    
    curTime = curTime + love.timer.getDelta()
    coroutine.yield()
  end
  
  callback(1.0, totalTime, totalTime)
  
end

function length(tbl)
  local count = 0
  for k,v in pairs(tbl) do count += 1 end
  return count
end

function get_first(tbl)
  local f = nil
  for k,v in pairs(tbl) do
    return v
  end
end

function math.randomf(lower, greater)
    return lower + math.random()  * (greater - lower);
end

function math.clamp(val, lower, upper)
    if lower > upper then lower, upper = upper, lower end -- swap if boundaries supplied the wrong way
    return math.max(lower, math.min(upper, val))
end

function math.map(value, low1, high1, low2, high2)
  return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

function math.bicubic(p0,p1,p2,p3, val)
  local function bicubic(p0, p1, p2, p3, val)
    local a = -0.5 * p0 + (3/2) * p1 - (3/2) * p2 + 0.5 * p3
    local b = p0 - (5/2) * p1 + (2) * p2 - 0.5 * p3
    local c = -0.5 * p0 + 0.5 * p2
    local d = p1
    
    return a * (val * val * val) + b * (val * val) + c * val + d
  end
  

  local result = Vector2D()
  
  result.x = bicubic(p0.x, p1.x, p2.x, p3.x, val)
  result.y = bicubic(p0.y, p1.y, p2.y, p3.y, val)
  
  return result
end

function math.interpolate_values(percent, values)
  local interPoints = values
  
  local function GetValue(tbl, val)
    if val < 1 then
      val = 1
    elseif val > #tbl then
      val = #tbl
    end
    
    return tbl[val]
  end
  
  if percent >= 1.0 then
    percent = 0.999999
  end
  
  if percent < 1.0 then
    local interSample = 1 / (#interPoints - 1)
    local test = math.map(percent, interSample * math.floor(percent / interSample), interSample * (math.floor(percent / interSample) + 1), 0, 1)    
    local curNum = math.floor(percent / interSample) + 1

    local pos = math.bicubic(GetValue(interPoints, curNum - 1), GetValue(interPoints, curNum), 
                             GetValue(interPoints, curNum + 1), GetValue(interPoints, curNum + 2), test)
    return pos
  end
end

function makeCoroutine(f, ...)
  local args = {...}

  local function temp(loop)
    while true do
      f(unpack(args))
      coroutine.yield()
      
      if not loop then return true end
    end
  end
  
  local co = coroutine.create(temp)
  local obj = {}
  obj.co = co
  obj.loop = true
  function obj:resume()
    if coroutine.status(co) == "dead" then
      return true
    end
  
    local ok, err = coroutine.resume(self.co, obj.loop)
    if not ok then
      print((debug.traceback(self.co, "Error: " .. tostring(err), 0):gsub("\n[^\n]+$", "")))
    end
  end
  
  return obj
end

function createClass(name, t)
  _G["_" .. name] = nil
  _G[name] = nil
  
  _G["_" .. name] = t
  _G["_" .. name].__index = _G["_" .. name]
  _G[name] = function(...)
    --Construct object with metatable
    local args = {...}
    
    local temp = {}
    setmetatable(temp, _G["_" .. name])
    
    --Call constructor
    temp[name](temp, unpack(args))
    
    return temp
  end
end

function drawText(text, position, width, fontSize, target, color, rotation, align)
  -- If the text list isn't there, create it
  if _G.TextList == nil then 
    _G.TextList = {}
  end
  
  fontSize = fontSize or FontSize
  
  -- Create text object
  local textObj = {}
  textObj.text = text
  textObj.x = position.x
  textObj.y = position.y
  textObj.fontSize = fontSize / FontSize
  textObj.width = width * WorldScale
  textObj.renderTarget = target
  textObj.color = color or Color(255, 255, 255, 255)
  textObj.rot = rotation or 0
  textObj.align = align or "center"
  
  -- Add it to the table to be rendered later
  table.insert(_G.TextList, textObj)
end

function string.split(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={} ; i=1
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    t[i] = str
    i = i + 1
  end
  return t
end

keyboard_events_old = {}
keyboard_events = {}
function love.keyboard.isTriggered(key)
  local res = love.keyboard.isDown(key)
  
  if res then
    keyboard_events[key] = true
    
    return keyboard_events_old[key] == nil
  end
  
  return false
end

mouse_events_old = {}
mouse_events = {}
function love.mouse.isLeftClick()
  local mouseButton = 1
  local res = love.mouse.isDown(mouseButton)
  
  if res then
    mouse_events[mouseButton] = true
    
    return mouse_events_old[mouseButton] == nil
  end
  
  return false
end

function love.mouse.isRightClick()
  local mouseButton = 2
  local res = love.mouse.isDown(mouseButton)
  
  if res then
    mouse_events[mouseButton] = true
    
    return mouse_events_old[mouseButton] == nil
  end
  
  return false
end

function math.floatEqual(a, b)
  return a-b < 0.01 and a-b > -0.01
end

function love.graphics.create_triangle(x, y, w, h, dir_x, dir_y)
  if dir_x ~= 0 and dir_y == 0 then
    return {x + (w / 2) * dir_x, y - (h / 2), 
            x - (w / 2) * dir_x, y, 
            x + (w / 2) * dir_x, y + (h / 2)}
  end
end

function parallel(...)
  local coTable = {}
  local funcs = {...}
  
  for k,v in pairs(funcs) do
    local coObj = {}
    coObj.co = coroutine.create(v)
    coObj.good = true
    
    table.insert(coTable, coObj)
  end
  
  local stillRun = true
  local err
  
  while stillRun do
    local allGood = true
    
    for k,v in pairs(coTable) do
      if v.good == true then
        v.good, err = coroutine.resume(v.co)
        allGood = false
      end
    end
    
    if allGood then
      stillRun = false
    end
    
    coroutine.yield()
  end
  
end

function getObject(name)
  for k,v in pairs(_G.GameObjectList) do
    if v.name == name then
      return v
    end
  end

  return nil
end

function getObjectList(name)
  local objects = {}

  for k,v in pairs(_G.GameObjectList) do
    if v.name == name then
      table.insert(objects, v)
    end
  end

  return objects
end

function math.sign(number)
  if number < 0 then
    return -1
  elseif number == 0 then
    return 0
  else
    return 1
  end
end

Easing = require "Base/GlobalEasing"
Vector2D = require "Base/Vector2D"
Color = require "Base/Color"
Camera = require "Base/Camera"
Gamestate = require "Base/GameState"
Profiler = {}
function Profiler:End(...) end
function Profiler:Start(...) end
function Profiler:Draw(...) end
HC = require "Base/HC"

require "Base/RenderTarget"
require "Base/GameObject"
require "Base/GameObjectHandle"
require "Base/ImageManager"
require "Base/TiledMap"
require "Base/TileController"
require "Base/CollisionData"
require "Base/CollisionPoints"
require "Base/AnimationController"
require "Base/wwise"
require "Base/PauseScreen"
require "Base/CollisionShape"
require "Base/CollisionManager"
require "Base/SquashFunctions"
require "Base/UpgradeManager"
tove = require "tove"
require "Base/Database"
require "Base/Cursor"
