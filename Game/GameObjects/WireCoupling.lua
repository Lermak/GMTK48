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
  
  self.cable = GameObject("Cable", self.wireEnds[1].position:clone(), self.wireEnds[2].position:clone())
  self:show(true)
end

function WireCoupling:show(b)
  self.wireEnds[1].visible = b
  self.wireEnds[2].visible = b
  self.cable.visible = b
end

function WireCoupling:onUpdate(dt)
  -- Called every frame
  self.cable.p0 = self.wireEnds[1].position:clone()
  self.cable.p1 = self.wireEnds[2].position:clone()
end

function WireCoupling:onDestroy()
  -- Called when the object is destroyed
end
    