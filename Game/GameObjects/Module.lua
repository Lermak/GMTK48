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

local TOP_ROW_Y = -45
local BOTTOM_ROW_Y = -135

local LEFT_CENTER = 64
local CENTER = 128
local RIGHT_CENTER = 192

local ICON_OFFSET = 45

local Init_Module = {}

Init_Module["Producer"] = function(self)
  self:declareOutput(LEFT_CENTER, BOTTOM_ROW_Y, Vector2D(0, 0), 0)
  self:declareOutput(CENTER, BOTTOM_ROW_Y, Vector2D(0, ICON_OFFSET + 30), 80)
  self:declareOutput(RIGHT_CENTER, BOTTOM_ROW_Y, Vector2D(0, 0), 0)
end

Init_Module["Combiner"] = function(self)
  self:declareInput(LEFT_CENTER, TOP_ROW_Y)
  self:declareInput(RIGHT_CENTER, TOP_ROW_Y)

  self:declareOutput(CENTER, BOTTOM_ROW_Y, Vector2D(0, ICON_OFFSET))
end

Init_Module["Separator"] = function(self)
  self:declareInput(CENTER, TOP_ROW_Y)

  self:declareOutput(LEFT_CENTER, BOTTOM_ROW_Y, Vector2D(0, ICON_OFFSET))
  self:declareOutput(RIGHT_CENTER, BOTTOM_ROW_Y, Vector2D(0, ICON_OFFSET))
end

Init_Module["Converter"] = function(self)
  self:declareInput(CENTER, TOP_ROW_Y)
  GameObject("Slider", self.position.x + 75, self.position.y - 135)
  self:declareOutput(RIGHT_CENTER, BOTTOM_ROW_Y, Vector2D(0, ICON_OFFSET))
end

Init_Module["Doubler"] = function(self)
  self:declareInput(CENTER, TOP_ROW_Y)

  self:declareOutput(LEFT_CENTER, BOTTOM_ROW_Y, Vector2D(0, ICON_OFFSET))
  self:declareOutput(RIGHT_CENTER, BOTTOM_ROW_Y, Vector2D(0, ICON_OFFSET))
end


Init_Module["Ship System"] = function(self)
  self:declareInput(CENTER, TOP_ROW_Y)

  local iconScreen = GameObject("IconScreen", 80)
  iconScreen.position = self.position + Vector2D(64, -120)
  iconScreen.zOrder = self.zOrder + 1

  local icon = GameObject("ResourceIcon", self.params.resource, Color(0,0,0))
  icon.position = self.position + Vector2D(64, -120)
  icon.zOrder = self.zOrder + 2
  icon.visible = true

  self.system_icon = icon
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

  self.params = params
  self.moduleName = name
  self.position = Vector2D(position.x, position.y)
  self.board = Boards[name]
  self.moduleIdx = AddModule(self.board, params)
  self.initializedInputs = {}
  self.initializedOutputs = {}
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

function Module:drawMesh()
  -- Set color
  love.graphics.setColor(self.color.r / 255, self.color.g / 255, self.color.b / 255, self.color.a / 255)

  love.graphics.draw(self.bgImage, self.bgImageQuad, self.position.x, self.position.y - 180)
  self:coreDraw()
end

function Module:onUpdate(dt)
  if self.moduleName == "Ship System" then
    if NODE_LIST[self.input[1].nodeIdx].value == self.params.resource then
      self.system_icon.color = Color(0, 210, 0)
    else
      self.system_icon.color = Color(0, 0, 0)
    end


  end
end

function Module:onDestroy()
  -- Called when the object is destroyed
end