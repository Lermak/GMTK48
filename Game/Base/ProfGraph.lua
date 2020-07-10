local win = love.window
local lgr = love.graphics
local tmr = love.timer

local performanceGraph = {}
performanceGraph.enabled = false

local performanceGraphTimes = {}
local performanceGraphName = ""
local performanceGraphColor = {}

local performanceGraphUpdateTime = 0
local performanceGraphDrawTime = 0
local performanceGraphTickPos = 0
local performanceGraphTickScale = 10000
local performanceGraphWidth = 1000
local performanceGraphScale = win.getPixelScale()
local performanceGraphCanvas = lgr.newCanvas(performanceGraphWidth, 800)
performanceGraphCanvas:setFilter("nearest")

local _performanceGraphTime = 0

local function performanceGraphReset()
   local _s = 1 / 60
   performanceGraphTickPos = 0
   love.graphics.clear()
   lgr.setColor(0,0,0,100)
   lgr.rectangle("fill", 0, 0, performanceGraphWidth, _s * performanceGraphTickScale)
   lgr.setColor(255,255,255)
   lgr.line(0, _s * performanceGraphTickScale, performanceGraphWidth, _s * performanceGraphTickScale)
   
   performanceGraphTimes = {}
end

function performanceGraph:Start(name, color)
  if not self.enabled then return false end
  
  performanceGraphName = name
  performanceGraphColor = color
  _performanceGraphTime = tmr.getTime()
  
end

function performanceGraph:End()
  if not self.enabled then return false end
  performanceGraphTimes[performanceGraphName] = {}
  performanceGraphTimes[performanceGraphName].Time = tmr.getTime() - _performanceGraphTime
  performanceGraphTimes[performanceGraphName].Color = performanceGraphColor
end

-- Call this at the bottom of love.draw after everything else
function performanceGraph:Draw()
   if not self.enabled then return false end

   lgr.setCanvas(performanceGraphCanvas)
   
   if performanceGraphTickPos == 0 then performanceGraphReset() end

   local h = 0
   
   for k,v in pairs(performanceGraphTimes) do
    lgr.setColor(v.Color.r, v.Color.g, v.Color.b)
    lgr.rectangle("fill", performanceGraphTickPos, h, 1, v.Time * performanceGraphTickScale)
    
    h += v.Time * performanceGraphTickScale
   end
   
   performanceGraphTimes = {}
   
   performanceGraphTickPos = performanceGraphTickPos + 1
   
   if performanceGraphTickPos >= lgr.getWidth() then performanceGraphTickPos = 0 end
   
   lgr.setCanvas()

   lgr.setColor(255,255,255)
   lgr.draw(performanceGraphCanvas, 0, lgr.getHeight(), 0, performanceGraphScale, -performanceGraphScale)
end

function performanceGraph:toggle()
   performanceGraphReset()
   self.enabled = not self.enabled
end

return performanceGraph