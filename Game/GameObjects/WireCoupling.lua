----------------------------------------------------------------------
--[[
  Author: Rhen Niles
  Type: Game Object
  Description: Two WireEnds connected by a cable
]]
----------------------------------------------------------------------

local WireCoupling = ...

function WireCoupling:onInitialize()
  -- Called when the game object is constructed
  self.zOrder = 10
  self.visible = false

  self.wireEnds = {
    GameObject("WireEnd"),
    GameObject("WireEnd")
  }
  self.birth = true
  self.cable = GameObject("Cable", self.wireEnds[1].position:clone(), self.wireEnds[2].position:clone())
  self:show(true)
end

function WireCoupling:show(b)
  self.wireEnds[1].visible = b
  self.wireEnds[2].visible = b
  self.cable.visible = b
end

function WireCoupling:attachCable()
  if self.cable.dropPoint == "none" then
    self.cable.p0 = self.wireEnds[1].position:clone()
    self.cable.p1 = self.wireEnds[2].position:clone()
  else
    self.wireEnds[1].position = self.cable.p0:clone()
    self.wireEnds[2].position = self.cable.p1:clone()
  end
end

function WireCoupling:onUpdate(dt)
  -- Called every frame
  

  local mx, my = MainCamera:mousePosition()
  
  local w1 = (self.wireEnds[1].position - Vector2D(mx, my)):len()
  local w2 = (self.wireEnds[2].position - Vector2D(mx, my)):len()
  
  if love.mouse.isLeftClick() and self.born == false then

    local flag = false
    for k,v in pairs(Modules) do
      local t = {}
      for q,x in pairs(v.initializedInputs) do
        t[#t + 1] = x[1]
      end
      for q,x in pairs(v.initializedOutputs) do
        t[#t + 1] = x[1]
      end
      for z,y in pairs(t) do
        local l = (y.position - Vector2D(mx, my)):len()
        for i,w in pairs(self.wireEnds) do 
          if l < y.scale.x then
            --left clicking on an empty node while carrying this node
            if y.isConnected == false and Cursor.wireEnd == w then
              y.wireEnd = w
              y.isConnected = true
              w.myNode = y
              w.dragged = false
              w.position = y.position
              Cursor.wireEnd = nil
              flag = true

              ConnectNode(self.wireEnds[1].myNode.nodeIdx, self.wireEnds[2].myNode.nodeIdx)
            elseif Cursor.wireEnd == nil and y.isConnected == true and y.wireEnd == w then
              DisconnectNode(w.myNode.nodeIdx)

              y.isConnected = false
              Cursor.wireEnd = y.wireEnd
              w.dragged = true
              w.myNode = nil
              y.wireEnd = nil
              flag = true
            end
          end
        end
      end
    end


    --Didn't click on valid node
    if flag == false then
      if w1 < self.wireEnds[1].scale.x then
        if self.wireEnds[1].dragged then
          self.wireEnds[1].dragged = false
          Cursor.wireEnd = nil
          self.cable:drop("p0")
        elseif Cursor.wireEnd == nil then
          self.wireEnds[1].dragged = true
          Cursor.wireEnd = self.wireEnds[1]
          self.cable.dropPoint = "none"
        end
      end
    
      if w2 < self.wireEnds[2].scale.x then
        if self.wireEnds[2].dragged then
          self.cable:drop("p1")
          self.wireEnds[2].dragged = false
          Cursor.wireEnd = nil
        elseif Cursor.wireEnd == nil then
          self.wireEnds[2].dragged = true
          Cursor.wireEnd = self.wireEnds[2]
          self.cable.dropPoint = "none"
        end
      end
    end
  else
    self.born = false
  end
  

  self:attachCable()
end

function WireCoupling:onDestroy()
  -- Called when the object is destroyed
end
    

function f()
  
end