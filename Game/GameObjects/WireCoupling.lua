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

  local c = ColorList[love.math.random(1, #ColorList)]
  self.color = Color(c[1]*255, c[2]*255, c[3]*255, 255)

  self.wireEnds = {
    GameObject("WireEnd"),
    GameObject("WireEnd")
  }
  self.birth = true
  self.cable = GameObject("Cable", self.wireEnds[1].position:clone(), self.wireEnds[2].position:clone())
  self:show(true)

  self.cable.color = self.color
  self.wireEnds[1].color = self.color
  self.wireEnds[2].color = self.color

  self.wireEnds[1].coupling = self
  self.wireEnds[2].coupling = self
end

function WireCoupling:show(b)
  self.wireEnds[1].visible = b
  self.wireEnds[2].visible = b
  self.cable.visible = b
end

function WireCoupling:attachCable()
  --print(self.cable.dropPointTwo)
  if self.cable.dropPointOne == false or self.cable.dropPointOne == nil then
    self.cable.p0 = self.wireEnds[1].position:clone()
  else
    self.wireEnds[1].position = self.cable.p0:clone()
  end
  --print(self.wireEnds[2])
  if self.cable.dropPointTwo == false or self.cable.dropPointTwo == nil then
    self.cable.p1 = self.wireEnds[2].position:clone()   
  else
    self.wireEnds[2].position = self.cable.p1:clone()
  end
end

function WireCoupling:onUpdate(dt)
  -- Called every frame

  if self.wireEnds[1].position.y < -2000 and self.wireEnds[2].position.y < -2000 then self:destroy() return end
  

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
          if l < y.scale.x and y.id ~= nil and y.valid then
            --left clicking on an empty node while carrying this node
            
            if y.isConnected == false and Cursor.wireEnd == w then
              y.wireEnd = w
              y.isConnected = true
              w.myNode = y
              w.dragged = false
              w.position = y.position
              Cursor.wireEnd = nil
              flag = true

              self.cable.placing = false
              self:attachCable()
              self.cable:rebuild()
              wwise.postEvent("Connect")

              if self.wireEnds[1].myNode and self.wireEnds[2].myNode then
                ConnectNode(self.wireEnds[1].myNode.nodeIdx, self.wireEnds[2].myNode.nodeIdx)
              end

            elseif Cursor.wireEnd == nil and y.isConnected == true and y.wireEnd == w then
              self:disconnectEnd(y, w, true)
              flag = true
            end
          end
        end
      end
    end

    if flag == false then
      if w1 < self.wireEnds[1].scale.x then
        if self.wireEnds[1].dragged then
          self.wireEnds[1].dragged = false
          Cursor.wireEnd = nil
          self.cable.placing = false
          self.cable:drop("p0", true)
        elseif Cursor.wireEnd == nil then
          self.wireEnds[1].dragged = true
          Cursor.wireEnd = self.wireEnds[1]
          self.cable.placing = true
          self.cable:drop("p0", false)
        end
      end
    
      if w2 < self.wireEnds[2].scale.x then
        if self.wireEnds[2].dragged then
          self.cable:drop("p1", true)
          self.cable.placing = false
          self.wireEnds[2].dragged = false
          Cursor.wireEnd = nil
        elseif Cursor.wireEnd == nil then
          self.wireEnds[2].dragged = true
          Cursor.wireEnd = self.wireEnds[2]
          self.cable.placing = true
          self.cable:drop("p1", false)
        end
      end
    end
  else
    self.born = false
  end

  self:attachCable()
end

function WireCoupling:disconnectEnd(moduleObj, wireEnd, attachCursor)
  if NODE_LIST[wireEnd.myNode.nodeIdx] ~= nil then
    DisconnectNode(wireEnd.myNode.nodeIdx)
  end

  wwise.postEvent("Disconnect")

  moduleObj.isConnected = false
  
  if attachCursor then
    wireEnd.dragged = true
    Cursor.wireEnd = moduleObj.wireEnd
    self.cable.placing = true
    self.cable:rebuild()
  else
    wireEnd.dragged = false

    if self.wireEnds[1] == wireEnd then
      self.cable:drop("p0", true)
    else
      self.cable:drop("p1", true)
    end
  end

  wireEnd.myNode = nil
  moduleObj.wireEnd = nil
end

function WireCoupling:onDestroy()
  -- Called when the object is destroyed
  self.wireEnds[1]:destroy()
  self.wireEnds[2]:destroy()
  self.cable:destroy()
end