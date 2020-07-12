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

local Init_Module = {}

Init_Module["Producer"] = function(self)
  self:declareOutput(X_CENTER_LEFT, Y_BOTTOM_ROW, Vector2D(0, 0), 0)
  self:declareOutput(X_CENTER, Y_BOTTOM_ROW, Vector2D(0, ICON_OFFSET + 30), 80)
  self:declareOutput(X_CENTER_RIGHT, Y_BOTTOM_ROW, Vector2D(0, 0), 0)
  self.name = self.moduleName..": "..self.params.resource
end

Init_Module["Combiner"] = function(self)
  self:declareInput(X_CENTER_LEFT - 20, Y_TOP_ROW + 12)
  self:declareInput(X_CENTER_RIGHT + 20, Y_TOP_ROW + 12)

  self:declareOutput(X_CENTER, Y_BOTTOM_ROW, Vector2D(0, ICON_OFFSET + 10), 50)

  table.insert(self.detail, GameObject("Image", "ModuleAssets/WireFrameCombiner.png", self.position, Vector2D(256, 180), 0))
end

Init_Module["Separator"] = function(self)
  self:declareInput(X_CENTER, Y_TOP_ROW)

  self:declareOutput(X_CENTER_LEFT - 30, Y_BOTTOM_ROW + 14, Vector2D(50, 0))
  self:declareOutput(X_CENTER_RIGHT + 30, Y_BOTTOM_ROW + 14, Vector2D(-50, 0))

  table.insert(self.detail, GameObject("Image", "ModuleAssets/WireFrameSeparator.png", self.position, Vector2D(256, 180), 0))
end

Init_Module["Converter"] = function(self)
  self:declareInput(X_CENTER_LEFT - 30, Y_BOTTOM_ROW + 18)
  self.slider = GameObject("Slider", self.position.x + 128, self.position.y - 50, self)
  self:declareOutput(X_CENTER_RIGHT + 28, Y_BOTTOM_ROW + 18, Vector2D(-100, 0), 50)

  table.insert(self.detail, GameObject("Image", "ModuleAssets/WireFrameConverter.png", self.position, Vector2D(256, 180), 0))
end

Init_Module["Doubler"] = function(self)
  self:declareInput(X_CENTER, Y_TOP_ROW + 20)

  self:declareOutput(X_CENTER_LEFT - 30, Y_BOTTOM_ROW + 24, Vector2D(0, ICON_OFFSET), 0)
  self:declareOutput(X_CENTER_RIGHT + 30, Y_BOTTOM_ROW + 24, Vector2D(-64 - 30, ICON_OFFSET - 40), 80)

  table.insert(self.detail, GameObject("Image", "ModuleAssets/WireFrameDoubler.png", self.position, Vector2D(256, 180), 0))
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
  self.cooldown = 10
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

  love.graphics.draw(self.bgImage, self.bgImageQuad, self.position.x, self.position.y - 180)
  love.graphics.setColor(0,0,0,255)
  love.graphics.printf(self.name, self.position.x + self.namePos.x, self.position.y + self.namePos.y, self.image:getWidth(), "center", 0, .5, -.5, 0.5 * 200, 0)

  --drawText(self.name, self.position + self.namePos, 500, 64, nil, Color(0.1, 0.1, 0.1))

  if self.moduleName == "Ship System" then
    
    love.graphics.draw(love.graphics.newImage("Data/Images/ModuleAssets/TimerFrame.png"), self.position.x + 200, self.position.y)
    love.graphics.setColor(255,0,0,175)
    love.graphics.printf((math.floor(self.systemTime/60))..":"..(math.floor(self.systemTime%60)), self.position.x + 200, self.position.y + -84, self.image:getWidth(), "center", 0, 1, -1, 0.5 * 200, 0)

    --drawText(string.format("%.0f", self.systemTime), self.position + Vector2D(200, -84), 500, 128, nil, Color(0.1, 0.1, 0.1))
  end
  love.graphics.setColor(0,0,0,255)
  self:coreDraw()
end

function Module:onUpdate(dt)
  if self.moduleName == "Ship System" then
    if NODE_LIST[self.input[1].nodeIdx].value == self.params.resource then
      self.system_icon.color = Color(0, 210, 0)
    else
      self.system_icon.color = Color(0, 0, 0)
    end

    self.systemTime -= dt

    if self.systemTime < 0 then
      Gamestate.current():moduleFail(self)
      self:clear()
    end
  end

  if self.moduleName == nil then
    self.cooldown = self.cooldown - dt
    if self.cooldown < 0 then
      self.cooldown = 10
      local r = Resources[love.math.random(1, #Resources)]
      self.params.resource = r
      self.moduleName = "Ship System"
      self.moduleIdx = AddModule(self.board, self.params)
      Init_Module[self.name](self)

      for k,v in pairs(self.initializedInputs) do
        print(v[1].nodeIdx)
        self.input[#self.input + 1] = v[1]
        self.input[#self.input].position.x = self.position.x + v[2]
        self.input[#self.input].position.y = self.position.y + v[3]
        self.input[#self.input].zOrder = -9
      end
    
      for k,v in pairs(self.initializedOutputs) do
        self.output[#self.output + 1] = v[1]
        self.output[#self.output].position.x = self.position.x + v[2]
        self.output[#self.output].position.y = self.position.y + v[3]
        self.output[#self.output].zOrder = -9
        self.output[#self.output]:setupIconScreen()
        self.output[#self.output]:setupIcon()
      end
    end
  end
end

function Module:clear()
  for k,v in pairs(self.initializedInputs) do
    v[1]:destroy()
  end

  for k,v in pairs(self.initializedOutputs) do
    v[1]:destroy()
  end

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

  RemoveModule(self.moduleIdx)
  self.moduleName = nil
end

function Module:onDestroy()
  -- Called when the object is destroyed
end