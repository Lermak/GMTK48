CollisionManager = {}

function CollisionManager.insert(id, shape)
  if CollisionManager.shapes == nil then 
    CollisionManager.shapes = {}
  end

  CollisionManager[id] = shape
end

function CollisionManager.remove(id)
  if CollisionManager.shapes == nil then 
    CollisionManager.shapes = {}
  end

  CollisionManager.shapes[id] = nil
end

function CollisionManager.checkCollision(pos, shape)
  if pos == nil or shape == nil then
    return false, 0
  end

  --Loop through all the collision shapes registered
  for k,v in pairs(CollisionManager.shapes) do
    local collision = false
    local obj = _G.GameObjectList[k]

    if obj and v then
      if v.type == "Box" and shape.type == "Box" then
        collision = CollisionManager.boxToBox(obj.position, v, pos, shape)
      elseif v.type == "Circle" and shape.type == "Circle" then
        collision = CollisionManager.circleToCircle(obj.position, v, pos, shape)
      elseif v.type == "Box" and shape.type == "Circle" then
        collision = CollisionManager.boxToCircle(obj.position, v, pos, shape)
      elseif v.type == "Circle" and shape.type == "Box" then
        collision = CollisionManager.boxToCircle(pos, shape, obj.position, v)
      end
    end

    if collision then
      return true, k
    end
  end

  return false, 0
end

function CollisionManager.boxToBox(posA, shapeA, posB, shapeB)
  return (posA.x < posB.x + shapeB.width
    and posA.x + posA.width > posB.x
    and posA.y < posB.y + shapeB.height
    and posA.y + shapeA.height > posB.y)
end

function CollisionManager.circleToCircle(posA, shapeA, posB, shapeB)
  local distSq = posA:dist2(posB)
  local combRad = shapeA.radius + shapeB.radius
  return distSq < combRad * combRad
end

function CollisionManager.boxToCircle(posA, boxA, posB, circleB)
  local newX = math.clamp(posA.x - boxA.width * 0.5, posB.x, posA.x + boxA.width * 0.5)
  local newY = math.clamp(posA.y - boxA.height * 0.5, posB.y, posA.x + boxA.height * 0.5)

  local distSq = posB:dist2(Vector2D(newX, newY))
  return distSq < circleB.radius * circleB.radius
end

function CollisionManager.lineToCircle(a, b, c, r)
  local ab = (b - a)
  local ac = (c - a)
  
  local projLen = ac:dot(ab) / ab:len()
  local pointOnLine = a + ab:normalized() * projLen

  if projLen < 0 or projLen > ab:len() then
    return false, nil
  end

  local pointToCircle =  (pointOnLine - c):len()
  return pointToCircle <= r, pointOnLine
end