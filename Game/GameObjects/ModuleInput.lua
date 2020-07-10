----------------------------------------------------------------------
--[[
  Author: Corbin McBride
  Type: Game Object
  Description:
]]
----------------------------------------------------------------------

local ModuleInput = ...

function ModuleInput:onInitialize(color)
  -- Called when the game object is constructed
  self.color = color
  self:setImage("ModuleInput.png")
  
  self.pivot.x = 0.5
  self.pivot.y = 0.5
  self.defaultColor = self.color
end

function ModuleInput:onUpdate(dt)
  -- Called every frame
  local mx, my = MainCamera:mousePosition()
  if math.floor(mx+0.5) == math.floor(self.position.x) and math.floor(my) == math.floor(self.position.y) then
    self:onHover()
  else
    self:onNotHover()
  end

end

function ModuleInput:onHover()
  self.color = Color(0,0,255)
end

function ModuleInput:onNotHover()
  self.color = self.defaultColor
end

function ModuleInput:onDestroy()
  -- Called when the object is destroyed
end
    