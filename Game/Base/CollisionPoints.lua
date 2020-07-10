CollisionPoints = {}

function CollisionPoints:CollisionPoints()
  --[[
  1 = Bottom Left
  2 = Bottom Right
  3 = Top Left
  4 = Top Right
  
  5 = Left Bottom
  6 = Left Top
  7 = Right Bottom
  8 = Right Top
  ]]
  
  self.points = {}
  self.points["BottomLeft"] = Vector2D()
  self.points["BottomRight"] = Vector2D()
  self.points["TopLeft"] = Vector2D()
  self.points["TopRight"] = Vector2D()
  
  self.points["LeftBottom"] = Vector2D()
  self.points["LeftTop"] = Vector2D()
  self.points["RightBottom"] = Vector2D()
  self.points["RightTop"] = Vector2D()
  
  self.tiles = {}
  
  self.partway = 0.35
end

function CollisionPoints:calculatePoints(position, movement, scale, part)
  local center = position + movement
  local half = 0.5 * scale
  local part = self.partway * scale
  
  self.points["BottomLeft"] = Vector2D(-part.x, -half.y) + center
  self.points["BottomRight"] = Vector2D(part.x, -half.y) + center
  
  self.points["TopLeft"] = Vector2D(-part.x, half.y) + center
  self.points["TopRight"] = Vector2D(part.x, half.y) + center
  
  self.points["LeftBottom"] = Vector2D(-half.x, -part.y) + center
  self.points["LeftTop"] = Vector2D(-half.x, part.y) + center
  
  self.points["RightBottom"] = Vector2D(half.x, -part.y) + center
  self.points["RightTop"] = Vector2D(half.x, part.y) + center
end

function CollisionPoints:calcCollisionsX(map)
  -- Clear tile list
  for k,v in pairs(self.tiles) do
    self.tiles[k] = nil
  end
  
  -- Add tiles
  self.tiles["BottomLeft"] = map:getTileFromPoint(self.points["LeftBottom"])
  self.tiles["BottomRight"] = map:getTileFromPoint(self.points["RightBottom"])
  self.tiles["TopLeft"] = map:getTileFromPoint(self.points["LeftTop"])
  self.tiles["TopRight"] = map:getTileFromPoint(self.points["RightTop"])
  
  self:fillRemainingTiles(map)
end

function CollisionPoints:calcCollisionsY(map)
  -- Clear tile list
  for k,v in pairs(self.tiles) do
    self.tiles[k] = nil
  end
  
  -- Add tiles
  self.tiles["BottomLeft"] = map:getTileFromPoint(self.points["BottomLeft"])
  self.tiles["BottomRight"] = map:getTileFromPoint(self.points["BottomRight"])
  self.tiles["TopLeft"] = map:getTileFromPoint(self.points["TopLeft"])
  self.tiles["TopRight"] = map:getTileFromPoint(self.points["TopRight"])
  
  self:fillRemainingTiles(map)
end

function CollisionPoints:fillRemainingTiles(map)
  local minX = self.tiles["BottomLeft"].x
  local maxX = self.tiles["BottomRight"].x
  local minY = self.tiles["BottomLeft"].y
  local maxY = self.tiles["TopLeft"].y
  
  for i=minX, maxX do
    for j=minY, maxY do
      -- These are the corners, they are already in the list
      if not ((i == minX or i == maxX) and (j == minY or j == maxY)) then
        table.insert(self.tiles, map:getTileFromPoint(Vector2D(i,j)))
      end
    end
  end
end

createClass("CollisionPoints", CollisionPoints)