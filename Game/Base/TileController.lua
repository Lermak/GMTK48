TileController = {}

function TileController:TileController(...)
  -- Collision data
  self.data = CollisionData()
  self.points = CollisionPoints()
end

function TileController:move(position, movement, scale)
  -- If no map exists, then don't do anything
  if self.map == nil then
    print("No map exists for Tile Controller")
    return position, movement
  end

  -- Reset collision data
  self.data:reset()
  
  -- Save local position
  local pos = position:clone()
  local mov = movement:clone()
  
  -- Resolve Y and then X
  pos, mov = self:resolveY(pos, mov, scale)
  pos, mov = self:resolveX(pos, mov, scale)
  
  -- Move the position
  pos = Vector2D(pos.x + mov.x, pos.y + mov.y)
  
  -- Return the velocity and new position
  return pos, mov
end

function TileController:resolveX(position, movement, scale)
  -- Calculate the object's points
  self.points:calculatePoints(position, movement, scale)
  self.points:calcCollisionsX(self.map)
  
  -- Collect tiles that block off movement of going up or down
  local blockedIds = {}

  if self.points.tiles["BottomLeft"].isWall == true and self.points.tiles["BottomRight"].isWall == true then
    table.insert(blockedIds, self.points.tiles["BottomLeft"].id)
    table.insert(blockedIds, self.points.tiles["BottomRight"].id)
  end
  
  if self.points.tiles["TopLeft"].isWall == true and self.points.tiles["TopRight"].isWall == true then
    table.insert(blockedIds, self.points.tiles["TopLeft"].id)
    table.insert(blockedIds, self.points.tiles["TopRight"].id)
  end
  
  -- Step throguh tiles
  for tK,tile in pairs(self.points.tiles) do
    local blocked = false
    
    for bK,id in pairs(blockedIds) do
      if tile.id == id then
        blocked = true
        break
      end
    end
    
    if not blocked then
      if tile.isWall then
        if tile.center.x > position.x then
          position.x = self:resolveTileX(tile, scale, -1)
          
          if movement.x > 0 then
            movement.x = 0
            
            self.data.right = true
          end
        else
          position.x = self:resolveTileX(tile, scale, 1)
          
          if movement.x < 0 then
            movement.x = 0
            
            self.data.left = true
          end
        end
      end
    end
  end
  
  
  return position, movement
end

function TileController:resolveY(position, movement, scale)
  -- Calculate the object's points
  self.points:calculatePoints(position, movement, scale)
  self.points:calcCollisionsY(self.map)
  
  -- Collect tiles that block off movement of going up or down
  local blockedIds = {}
  
  if self.points.tiles["TopLeft"].isWall == true and self.points.tiles["BottomLeft"].isWall == true then
    table.insert(blockedIds, self.points.tiles["BottomLeft"].id)
    table.insert(blockedIds, self.points.tiles["TopLeft"].id)
  end
  
  if self.points.tiles["TopRight"].isWall == true and self.points.tiles["BottomRight"].isWall == true then
    table.insert(blockedIds, self.points.tiles["BottomRight"].id)
    table.insert(blockedIds, self.points.tiles["TopRight"].id)
  end
  
  -- Step throguh tiles
  for tK,tile in pairs(self.points.tiles) do
    local blocked = false
    
    for bK,id in pairs(blockedIds) do
      if tile.id == id then
        blocked = true
        break
      end
    end
    
    if not blocked then
      if tile.isWall then 
        -- Resolving down from collision above
        if tile.center.y > position.y then
          position.y = self:resolveTileY(tile, scale, -1)
          
          if movement.y > 0 then
            movement.y = 0
            
            self.data.top = true
          end
        else
          position.y = self:resolveTileY(tile, scale, 1)
          
          if movement.y < 0 then
            movement.y = 0
            
            self.data.bottom = true
          end
        end
      end
    end
  end
  
  return position, movement
end

function TileController:resolveTileX(tile, scale, direction)
  return tile.center.x + direction * 0.5 + scale.x * 0.5 * direction
end

function TileController:resolveTileY(tile, scale, direction)
  return tile.center.y + direction * 0.5 + scale.y * 0.5 * direction
end

function TileController:isPointInside(point, position, scale)
  return point.x > position.x - scale.x * 0.5 and point.x < position.x + scale.x * 0.5
     and point.y > position.y - scale.y * 0.5 and point.y < position.y + scale.y * 0.5
end

createClass("TileController", TileController)