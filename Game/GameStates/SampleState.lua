----------------------------------------------------------------------
--[[
  Author:
  Type: Game State
  Description:
]]
----------------------------------------------------------------------

SampleState = { 
}

local y1 = 360
local y2 = 180
local y3 = 0
local y4 = -180
local y = {y1, y2, y3, y4}

local x1 = -640
local x2 = -384
local x3 = -128
local x4 =  128
local x5  = 384
local x = {x1, x2, x3, x4, x5}

function setTutOne()
  Modules = {
    GameObject("Module", "Producer", {x = x2, y = y2},{ resource = "Star" }),
    GameObject("Module", "Ship System", {x = x4, y = y2},{ resource = "Star" }),
  }
end

function setTutTwo()
  Modules = {
    GameObject("Module", "Producer", {x = x2, y = y1},{ resource = "Star" }),
    GameObject("Module", "Producer", {x = x4, y = y1},{ resource = "Star" }),

    GameObject("Module", "Combiner", {x = x3, y = y2}),

    GameObject("Module", "Ship System", {x = x3, y = y3},{ resource = "Crab" }),
  }
end

function setLevel()
  Modules = {
    GameObject("Module", "Producer", {x = x1, y = y1}, { resource = "Electricity" }),
    GameObject("Module", "Producer", {x = x2, y = y1}, { resource = "Star" }),
    GameObject("Module", "Producer", {x = x3, y = y1}, { resource = "Fish" }),
    GameObject("Module", "Producer", {x = x4, y = y1},  { resource = "Fire" }),
    
    GameObject("Module", "Combiner", {x = x1, y = y2}),
    GameObject("Module", "Combiner", {x = x2, y = y2}),
    GameObject("Module", "Combiner", {x = x3, y = y2}),
    GameObject("Module", "Converter", {x = x4, y = y2}),
    GameObject("Module", "Converter", {x = x5, y = y2}),
    
    GameObject("Module", "Separator", {x = x1, y = y3}),
    GameObject("Module", "Separator", {x = x2, y = y3}),
    GameObject("Module", "Separator", {x = x3, y = y3}),
    GameObject("Module", "Doubler", {x = x4, y = y3}),
    GameObject("Module", "Doubler", {x = x5, y = y3}),

    GameObject("Module", "Ship System", {x = x1, y = y4}, { resource = "Electricity" }),
    GameObject("Module", "Ship System", {x = x2, y = y4}, { resource = "Electricity" }),
    GameObject("Module", "Ship System", {x = x3, y = y4}, { resource = "Electricity" }),
    GameObject("Module", "Ship System", {x = x4, y = y4}, { resource = "Electricity" }),
    GameObject("Module", "Ship System", {x = x5, y = y4}, { resource = "Electricity" }),
  }

  for k,obj in pairs(Modules) do
    if obj.moduleName == "Ship System" then
      obj:clear()
    end
  end

  GameOver = GameObject("GameOver")
end

function SampleState:init()
  -- Called once, and only once, before entering the state the first time. See Gamestate.switch().
  self.cableState = 0

  self.systemCooldown = 20
  self.systemTimer = 0
  self.completedModules = 0
  self.firstHookedUp = false
  self.firstModule = true

  wwise.postEvent("Main_Music")
end

function SampleState:enter(previous, ...)
  -- Called every time when entering the state. See Gamestate.switch().
  self.fadeIn = makeCoroutine(function()
    overTime(1, function(p)
      p = Easing.OutQuad(p,0,1,1)
      Fade = 1 * p
    end)
    self.fadeIn = nil
  end)
  setLevel()
  --setTutOne()
  
end

function SampleState:update()  
  if self.fadeIn then
    self.fadeIn:resume()
    return
  end

  SolveGraph()

  -- Get all current Producer modules
  local emptySystems = {}
  for k,obj in pairs(Modules) do
    if obj.moduleName == nil and obj.valid then
      table.insert(emptySystems, obj)
    end
  end

  local makeModule = function(module, max)
    local setupModule = function()
      local r = Resources[love.math.random(1, max)]
      module.params.resource = r
      module.moduleName = "Ship System"
      module.moduleIdx = AddModule(module.board, module.params)
      Init_Module[module.name](module)

      for k,v in pairs(module.initializedInputs) do
        module.input[#module.input + 1] = v[1]
        module.input[#module.input].position.x = module.position.x + v[2]
        module.input[#module.input].position.y = module.position.y + v[3]
        module.input[#module.input].zOrder = -9
      end

      for k,v in pairs(module.initializedOutputs) do
        module.output[#module.output + 1] = v[1]
        module.output[#module.output].position.x = module.position.x + v[2]
        module.output[#module.output].position.y = module.position.y + v[3]
        module.output[#module.output].zOrder = -9
        module.output[#module.output]:setupIconScreen()
        module.output[#module.output]:setupIcon()
      end
    end

    if not module.exitCo then
      module:animateOut(setupModule)
    else
      setupModule()
    end
  end


  if self.firstModule == true then

    local module = emptySystems[love.math.random(1, #emptySystems)]
    makeModule(module, 4)
    self.firstModule = false

  elseif self.firstHookedUp == false then

    local hookedUp = false
    for k,obj in pairs(Modules) do
      if obj.moduleName == "Ship System" then
        if NODE_LIST[obj.input[1].nodeIdx] and NODE_LIST[obj.input[1].nodeIdx].value == obj.params.resource then
          hookedUp = true
        end
      end
    end

    if hookedUp == true then
      self.firstHookedUp = true

      for k,obj in pairs(emptySystems) do
        makeModule(obj, #Resources)
      end
    end

  else

    if #emptySystems == 5 or (self.systemTimer <= 0 and #emptySystems ~= 0) or (foundShip == true and shipIncomplete == false and #emptySystems ~= 0) then
      self.systemTimer = math.max(self.systemCooldown - (self.completedModules * 0.75), 5)
  
      local module = emptySystems[love.math.random(1, #emptySystems)]
      makeModule(module, #Resources)
    else
      self.systemTimer -= dt
    end

  end
end

function SampleState:moduleFail()
  GameOver.failiures = GameOver.failiures + 1
end

function SampleState:draw()
  -- Draw on the screen. Called every frame.
end

function SampleState:leave()
  -- Called when leaving a state. See Gamestate.switch() and Gamestate.push().
end
