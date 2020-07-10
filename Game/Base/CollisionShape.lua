CollisionShape = {}

function CollisionShape:CollisionShape()
end

function CollisionShape:makeBox(width, height)
  self.type = "Box"
  self.width = width
  self.height = height
end

function CollisionShape:makeCircle(radius)
  self.type = "Circle"
  self.radius = radius
end

createClass("CollisionShape", CollisionShape)