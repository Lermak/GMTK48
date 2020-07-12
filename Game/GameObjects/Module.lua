----------------------------------------------------------------------
--[[
  Author: Corbin McBride
  Type: Game Object
  Description:
]]
----------------------------------------------------------------------

--- Prebuild module setups
-- Inputs and outputs are declared IN ORDER, I.E the first declareInput() call will setup input 1, the second input 2, etc
-- All functions must be declared in the form Init_Module_##MODULE_NAME

local Y_TOP_ROW = -45
local Y_BOTTOM_ROW = -135

local X_CENTER_LEFT = 64
local X_CENTER = 128
local X_CENTER_RIGHT = 192

local ICON_OFFSET = 45

Init_Module = {}

Init_Module["Producer"] = function(self)
  self:declareOutput(X_CENTER_LEFT, Y_BOTTOM_ROW, Vector2D(0, 0), 0)
  self:declareOutput(X_CENTER, Y_BOTTOM_ROW, Vector2D(0, ICON_OFFSET + 30), 80)
  self:declareOutput(X_CENTER_RIGHT, Y_BOTTOM_ROW, Vector2D(0, 0), 0)
  self.name = self.moduleName..": "..self.params.resource
end

Init_Module["Combiner"] = function(self)
  self:declareInput(X_CENTER_LEFT - 20, Y_TOP_ROW + 12)
  self:declareInput(X_CENTER_RIGHT + 20, Y_TOP_ROW + 12)

  self:declareOutput(X_CENTER, Y_BOTTOM_ROW, Vector2D(0, ICON_OFFSET + 10), 60)

  table.insert(self.detail, GameObject("Image", "ModuleAssets/WireFrameCombiner.png", self.position, Vector2D(256, 180), -5))
end

Init_Module["Separator"] = function(self)
  self:declareInput(X_CENTER, Y_TOP_ROW)

  self:declareOutput(X_CENTER_LEFT - 30, Y_BOTTOM_ROW + 14, Vector2D(50, 0), 50)
  self:declareOutput(X_CENTER_RIGHT + 30, Y_BOTTOM_ROW + 14, Vector2D(-50, 0), 50)

  table.insert(self.detail, GameObject("Image", "ModuleAssets/WireFrameSeparator.png", self.position, Vector2D(256, 180), -5))
end

Init_Module["Converter"] = function(self)
  self:declareInput(X_CENTER_LEFT - 30, Y_BOTTOM_ROW + 18)
  self.slider = GameObject("Slider", self.position.x + 128, self.position.y - 50, self)
  self:declareOutput(X_CENTER_RIGHT + 28, Y_BOTTOM_ROW + 18, Vector2D(-100, 0), 60)

  table.insert(self.detail, GameObject("Image", "ModuleAssets/WireFrameConverter.png", self.position, Vector2D(256, 180), -5))
end

Init_Module["Doubler"] = function(self)
  self:declareInput(X_CENTER, Y_TOP_ROW + 20)

  self:declareOutput(X_CENTER_LEFT - 30, Y_BOTTOM_ROW + 24, Vector2D(0, ICON_OFFSET), 0)
  self:declareOutput(X_CENTER_RIGHT + 30, Y_BOTTOM_ROW + 24, Vector2D(-64 - 30, ICON_OFFSET - 40), 80)

  table.insert(self.detail, GameObject("Image", "ModuleAssets/WireFrameDoubler.png", self.position, Vector2D(256, 180), -5))
end


Init_Module["Ship System"] = function(self)
  self:declareInput(X_CENTER, Y_TOP_ROW)

  local iconScreen = GameObject("IconScreen", 80)
  iconScreen.position = self.position + Vector2D(64, -120)
  iconScreen.zOrder = self.zOrder + 1

  local icon = GameObject("ResourceIcon", self.params.resource, Color(0,0,0))
  local iconScale = 2
  icon.position = self.position + Vector2D(64, -120)
  icon.zOrder = self.zOrder + 2
  icon.visible = true
  icon.scale.x = icon.scale.x * iconScale
  icon.scale.y = icon.scale.y * iconScale

  local energyBar = GameObject("EnergyBar", self)
  energyBar.position = self.position:clone()
  energyBar.position.x = energyBar.position.x + X_CENTER
  energyBar.position.y = energyBar.position.y - 160
  --energyBar.position.y = energyBar.position.y - energyBar.image:getHeight()
  self.energyBar = energyBar
  self.systemIconScreen = iconScreen
  self.system_icon = icon
  self.systemTime = 120--math.random(5, 100)
end

Init_Module["Empty"] = function(self)
end


-----------------------------------

local Module = ...

function Module:declareInput(x, y)
  local inputObj = { GameObject("ModuleSocket", "input", self.moduleIdx, (#self.initializedInputs) + 1), x, y }
  
  table.insert(self.initializedInputs, inputObj)
end

function Module:declareOutput(x, y, imgPos, imgScale)
  imgScale = imgScale or 40
  local outObj = { GameObject("ModuleSocket", "output", self.moduleIdx, (#self.initializedOutputs) + 1, {iconPos = imgPos, imgScale = imgScale}), x, y }
  table.insert(self.initializedOutputs, outObj)
end

function Module:onInitialize(name, position, params)
  params = params or {}

  self.detail = {}

  self.params = params
  self.moduleName = name
  self.position = Vector2D(position.x, position.y)
  self.board = Boards[name]
  self.moduleIdx = AddModule(self.board, params)
  self.initializedInputs = {}
  self.initializedOutputs = {}
  self.namePos = Vector2D(X_CENTER-10,Y_BOTTOM_ROW-20)
  self.name = self.moduleName
  Init_Module[name](self)

  if self.board == nil then
    error("No board exists with name \"" .. name .. "\"!")
  end

  if self.board.inputs ~= #self.initializedInputs then
    error("Failed to set all of the inputs to module " .. name .. "! Expected " .. #board.inputs .. ", got " .. #self.initializedInputs .. ".")
  end
  
  if self.board.outputs ~= #self.initializedOutputs then
    error("Failed to set all of the outputs to module " .. name .. "! Expected " .. #board.outputs .. " got " .. #self.initializedOutputs .. ".")
  end

  -- Called when the game object is constructed
  --this is for the module
  self:setImage("ModuleAssets/Frame.png")

  self.bgImage = ImageManager.getImage("Data/Images/ModuleAssets/Background.png")
  self.bgImage:setWrap("repeat", "repeat")
  self.bgImageQuad = love.graphics.newQuad( 0,0, 256,180, 18,26 )

  self.scale.x = 256
  self.scale.y = 180
  self.pivot.x = 0
  self.pivot.y = 0
  self.zOrder = -10
  self.input = {}
  self.output = {}
  for k,v in pairs(self.initializedInputs) do
    self.input[#self.input + 1] = v[1]
    self.input[#self.input].position.x = self.position.x + v[2]
    self.input[#self.input].position.y = self.position.y + v[3]
    self.input[#self.input].zOrder = 0
  end

  for k,v in pairs(self.initializedOutputs) do
    self.output[#self.output + 1] = v[1]
    self.output[#self.output].position.x = self.position.x + v[2]
    self.output[#self.output].position.y = self.position.y + v[3]
    self.output[#self.output].zOrder = 0
    self.output[#self.output]:setupIconScreen()
    self.output[#self.output]:setupIcon()
  end
end

function Module:drawMesh()
  -- Set color
  love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)

  love.graphics.draw(self.bgImage, self.bgImageQuad, self.position.x, self.position.y - 180, 0, self.scale.x / 256, self.scale.y / 180)
  love.graphics.setColor(0,0,0,175)
  love.graphics.printf(self.name, self.position.x + self.namePos.x, self.position.y + self.namePos.y, self.image:getWidth(), "center", 0, .5, -.5, 0.5 * 200, 0)

  --drawText(self.name, self.position + self.namePos, 500, 64, nil, Color(0.1, 0.1, 0.1))

  if self.moduleName == "Ship System" then
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(love.graphics.newImage("Data/Images/ModuleAssets/TimerFrame.png"), self.position.x + 155, self.position.y - 110)
    love.graphics.setColor(255,0,0,175)
    local s = (math.floor(self.systemTime%60))
    if s < 10 then
      s = "0"..s
    end
    love.graphics.printf((math.floor(self.systemTime/60))..":"..s, self.position.x + 170, self.position.y + -60, self.image:getWidth(), "center", 0, 1, -1, 0.5 * 200, 0)

    --drawText(string.format("%.0f", self.systemTime), self.position + Vector2D(200, -84), 500, 128, nil, Color(0.1, 0.1, 0.1))
  end
  love.graphics.setColor(0,0,0,255)
  self:coreDraw()
end

function Module:animateOut(callbackFn)
  if self.exitCo then return end

  if callbackFn then self.valid = false end

  self:clearConnections()

  self.exitCo = makeCoroutine(function()
    wwise.postEvent("GoAway")
    self:propegatezOrder(200)

    local d = Vector2D(0, 5)
    local s = 0.01
    local lastP = 0
    overTime(0.2, function(p)
      self:propegatePosition(d * (p - lastP))
      self:propegateScale(1.0 - s * (p - lastP))
      lastP = p
    end)

    local d = Vector2D(0, 256)
    local lastP = 0
    overTime(2.2, function(p)
      p = Easing.InBack(p, 0, 1, 1)
      self:propegatePosition(d * (p - lastP))
      lastP = p
    end)

    self:clear()
    self.valid = false
    
    if callbackFn then
      callbackFn()
      self.valid = true
    else
      self.valid = true
    end

    while self.moduleName == nil do coroutine.yield() end

    wwise.postEvent("ComeBack")


    local d = Vector2D(0, 256)
    local lastP = 0
    overTime(3.4, function(p)
      p = Easing.OutBack(p, 0, 1, 1)
      self:propegatePosition(-d * (p - lastP))
      lastP = p
    end)

    local d = Vector2D(0, 5)
    local s = 0.01
    local lastP = 0
    overTime(0.4, function(p)
      self:propegatePosition(-d * (p - lastP))
      self:propegateScale(1.0 + s * (p - lastP))
      lastP = p
    end)

    self.exitCo = nil
  end)
end

function Module:propegatezOrder(dz)
  self.zOrder -= dz

  for k,v in pairs(self.initializedInputs) do
    v[1]:propegatezOrder(dz)
  end

  for k,v in pairs(self.initializedOutputs) do
    v[1]:propegatezOrder(dz)
  end

  if self.system_icon then self.system_icon:propegatezOrder(dz) end
  if self.systemIconScreen then self.systemIconScreen:propegatezOrder(dz) end
  if self.energyBar then self.energyBar:propegatezOrder(dz) end

  for k,v in pairs(self.detail) do
    v:propegatezOrder(dz)
  end
end

function Module:propegatePosition(dv)
  self.position -= dv

  for k,v in pairs(self.initializedInputs) do
    v[1]:propegatePosition(dv)
  end

  for k,v in pairs(self.initializedOutputs) do
    v[1]:propegatePosition(dv)
  end

  if self.system_icon then self.system_icon:propegatePosition(dv) end
  if self.systemIconScreen then self.systemIconScreen:propegatePosition(dv) end
  if self.energyBar then self.energyBar:propegatePosition(dv) end

  for k,v in pairs(self.detail) do
    v:propegatePosition(dv)
  end
end

function Module:propegateScale(s)
  self.scale *= s
  self.position += Vector2D(256, 180) * (1 - s) / 2

  for k,v in pairs(self.initializedInputs) do
    v[1]:propegateScale(s)
  end

  for k,v in pairs(self.initializedOutputs) do
    v[1]:propegateScale(s)
  end

  if self.system_icon then self.system_icon:propegateScale(s) end
  if self.systemIconScreen then self.systemIconScreen:propegateScale(s) end
  if self.energyBar then self.energyBar:propegateScale(s) end

  for k,v in pairs(self.detail) do
    v:propegateScale(s)
  end
end

function Module:onUpdate(dt)
  if self.exitCo then self.exitCo:resume() return end

  if self.moduleName == "Ship System" then
    if NODE_LIST[self.input[1].nodeIdx].value == self.params.resource then
      self.system_icon.color = Color(0, 210, 0)
    else
      self.system_icon.color = Color(0, 0, 0)
      
      self.systemTime -= dt

      if self.systemTime < 0 then
        Gamestate.current():moduleFail(self)
        self:animateOut()
      end
    end
  end
end

function Module:clearConnections()
  self.valid = false

  for k,v in pairs(self.initializedInputs) do
    v[1]:clearConnections()
  end

  for k,v in pairs(self.initializedOutputs) do
    v[1]:clearConnections()
  end

  RemoveModule(self.moduleIdx)
  self.moduleName = nil
end

function Module:clear()

  for k,v in pairs(self.initializedInputs) do
    v[1]:destroy()
  end

  for k,v in pairs(self.initializedOutputs) do
    v[1]:destroy()
  end

  self.valid = true

  self.initializedInputs = {}
  self.initializedOutputs = {}
  self.input = {}
  self.output = {}

  if self.system_icon then self.system_icon:destroy() end
  if self.systemIconScreen then self.systemIconScreen:destroy() end
  if self.energyBar then self.energyBar:destroy() end

  for k,v in pairs(self.detail) do
    v:destroy()
  end

  self.moduleName = nil
end

function Module:onDestroy()
  -- Called when the object is destroyed
end