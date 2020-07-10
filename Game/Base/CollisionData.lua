--[[
]]

CollisionData = {}

function CollisionData:CollisionData()
  -- Start with default
  self:reset()
end

function CollisionData:reset()
  -- Collision locations
  self.top = false
  self.bottom = false
  self.left = false
  self.right = false
  
  self.leftWallJump = false
  self.rightWallJump = false
  
  -- Direction the character is facing
  self.faceDir = 1
end

createClass("CollisionData", CollisionData)