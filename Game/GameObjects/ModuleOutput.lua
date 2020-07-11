----------------------------------------------------------------------
--[[
  Author: Corbin McBride
  Type: Game Object
  Description:
]]
----------------------------------------------------------------------

local ModuleOutput = ...

function ModuleOutput:onInitialize(color, b, p)
  -- Called when the game object is constructed
  self.color = color
  self:setImage("ModuleOutput.png")
  
  self.pivot.x = 0.5
  self.pivot.y = 0.5
  self.defaultColor = self.color

  self.board = b
  self.port = p
end

function ModuleOutput:onUpdate(dt)
  -- Called every frame
  local mx, my = MainCamera:mousePosition()
  if math.floor(mx+0.5) == math.floor(self.position.x) and math.floor(my) == math.floor(self.position.y) then
    self:onHover()
    if love.mouse.isLeftClick() and Cursor.outBoard ~= self.board and IsOutputUsed(self.board, self.port) == false and Cursor.inBoard ~= self.board then
      Cursor.outBoard = self.board
      Cursor.outPort = self.port
      CheckCursorPlacement()
    end
    if love.mouse.isRightClick() and IsOutputUsed(self.board, self.port) then
      for k,v in pairs(GetAllConnections()) do
        if v[3] == self.board and v[4] == self.port then
          DisconnectBoards(v[1], v[2])
        end
      end
    end
  else
    self:onNotHover()
  end
end


function ModuleOutput:onHover()
  self.color = Color(0,0,255)
end

function ModuleOutput:onNotHover()
  self.color = self.defaultColor
end

function ModuleOutput:onDestroy()
  -- Called when the object is destroyed
end
    