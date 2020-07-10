----------------------------------------------------------------------
--[[
  Author:
  Type: Game Object
  Description:
]]
----------------------------------------------------------------------

local VisualConnection = ...

function VisualConnection:onInitialize(p1, p2)
  -- Called when the game object is constructed
  --draw as a line, center of input to center of output
  print("VisualConnection!")
  self.pivot.x = 0
  self.pivot.y = 0.5
  self.position = p1
  self.scale.y = 0.25
  self.color = Color(127,255,255)
  self.shape = "rectangle"

  local dx = p1.x - p2.x
  local dy = p1.y - p2.y
  local length = math.sqrt(dx*dx + dy*dy)
  self.scale.x = length
  local angle = math.atan(dy, dx)
  self.rotation = math.deg(angle)
  self.zOrder = 2
  
end

function VisualConnection:onUpdate(dt)
  -- Called every frame
end

function VisualConnection:onDestroy()
  -- Called when the object is destroyed
end
    