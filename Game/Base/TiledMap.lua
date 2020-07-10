TiledMap = {}

function TiledMap:TiledMap(name)
  self.mapData = love.filesystem.load(name)()
  --self.mapImage = love.graphics.newImage("Data" .. self.mapData.tilesets[1].image:sub(3))
  
  self.tileInstances = {}
  
  --Create generic wall for 0
  self.tileInstances["Wall"] = {}
  self.tileInstances["Wall"].properties = {}
  self.tileInstances["Wall"].properties.IsWall = true
  
  for k, tile in pairs(self.mapData.tilesets[1].tiles) do
    self.tileInstances[tile.id + 1] = {}
    self.tileInstances[tile.id + 1].properties = tile.properties
  end
  
  self:generateMapMesh()
  
  for k,v in pairs(self.mapMesh) do
    local image = love.graphics.newImage("Data" .. self.mapData.tilesets[1].image:sub(3))
    image:setFilter("nearest")
    v:setTexture(image)
  end
  
  --Create gameobjects for each object in editor
  local map = self.mapData
  self.mapObjects = {}
  
  for k, layer in pairs(map.layers) do
    if layer.type == "objectgroup" then
    
      --Create all objects
      for k, object in pairs(layer.objects) do
        
        local createdObject = GameObject(object.properties.type, object.properties.args)
        createdObject.position = Vector2D(object.x / map.tilewidth + (object.width / 2 / map.tilewidth), map.height - (object.y / map.tileheight + (object.height / map.tileheight)))
        createdObject.scale = Vector2D(object.width / map.tilewidth, object.height / map.tileheight)
        createdObject.tile_position = Vector2D(math.floor(object.x / map.tilewidth), map.height - math.floor(object.y / map.tileheight) - 1)
        
        if object.properties.image then
          createdObject:setImage(object.properties.image)
        end
        
        local blacklist = {"args", "type", "image"}
        
        for k,v in pairs(object.properties) do
          local pass = true
          for key,name in pairs(blacklist) do
            if k == name then
              pass = false
            end
          end
        
          if pass then
            createdObject[k] = v
          end
        end
        
        if createdObject.controller ~= nil then
          createdObject.controller.map = self
        end

        self.mapObjects[createdObject.id] = {gObj = createdObject, obj = object}
      end
      
      -- Resolve all objects
      for k, object in pairs(self.mapObjects) do
        if object.gObj.onTiledImport ~= nil then
          object.gObj:onTiledImport(object.obj)
        end
      end
      
    end
  end
  
  MainCamera.x = self.mapData.width / 2
  MainCamera.y = self.mapData.height / 2
end

function TiledMap:destroy()
  -- Destroy all map objects
  for k,mapObj in pairs(self.mapObjects) do
    mapObj.gObj:destroy()
    self.mapObjects[k] = nil
  end
end

function TiledMap:getTileFromPoint(point)
  local tile = {}
  tile.x = math.floor(point.x)
  tile.y = math.floor(point.y)
  tile.id = -1
  tile.center = Vector2D(tile.x + 0.5, tile.y + 0.5)
  tile.isWall = false
  
  local x = math.floor(tile.x)
  local y = (self.mapData.height - 1) - math.floor(tile.y)
  
  if x < 0 or x >= self.mapData.width or y < 0 or y >= self.mapData.height then
    tile.isWall = true
    tile.isShop = false
    return tile
  end
  
  tile.id = 1 + (x + y * self.mapData.width)
  local tile_id = self.mapData.layers[1].data[tile.id]
  
  local rawTile = self.tileInstances[tile_id]
  if rawTile then
    tile.isWall = rawTile.properties.isWall
    tile.isShop = rawTile.properties.isShop
  end
  
  return tile
end

function TiledMap:getBackgroundFromPoint(point)
  local tile = {}
  tile.x = math.floor(point.x)
  tile.y = math.floor(point.y)
  tile.id = -1
  tile.center = Vector2D(tile.x + 0.5, tile.y + 0.5)
  tile.isWall = false
  tile.properties = {}
  
  local x = math.floor(tile.x)
  local y = (self.mapData.height - 1) - math.floor(tile.y)
  
  if x < 0 or x >= self.mapData.width or y < 0 or y >= self.mapData.height then
    tile.isWall = true
    return tile
  end
  
  tile.id = 1 + (x + y * self.mapData.width)
  local tile_id = self.mapData.layers[1].data[tile.id]
  
  local rawTile = self.tileInstances[tile_id]
  if rawTile then
    tile.isWall = rawTile.properties.isWall
    tile.properties = rawTile.properties
  end
  
  return tile
end

function TiledMap:draw()
  --love.graphics.push()
  --love.graphics.scale(1 / WorldScale)
  love.graphics.setColor(255,255,255,255)
  love.graphics.draw(self.mapMesh[1], 0, 0)
  --love.graphics.pop()
end

function TiledMap:generateMapMesh()
  local map = self.mapData
  local vertices = {}
  
  self.mapMesh = {}
  
  local uv_width = map.tilesets[1].tilewidth / map.tilesets[1].imagewidth
  local uv_height = map.tilesets[1].tileheight / map.tilesets[1].imageheight

  local marginWidth = map.tilesets[1].margin / map.tilesets[1].imagewidth
  local marginHeight = map.tilesets[1].margin / map.tilesets[1].imageheight
  local spacingWidth = map.tilesets[1].spacing / map.tilesets[1].imagewidth
  local spacingHeight = map.tilesets[1].spacing / map.tilesets[1].imageheight
  
  local tiles_per_row = (map.tilesets[1].imagewidth) / (map.tilesets[1].tilewidth + map.tilesets[1].spacing)

  local trans_y = map.height

  for k, layer in pairs(map.layers) do
    local currentTile = 0
    
    if layer.type == "tilelayer" then
      for k,tileId in pairs(layer.data) do
        local current_col = math.floor(currentTile % layer.width)
        local current_row = math.floor(currentTile / layer.width)
        
        local tile_col = math.floor((tileId - 1) % tiles_per_row)
        local tile_row = math.floor((tileId - 1) / tiles_per_row)
        
        local start_x = current_col
        local start_y = current_row
        
        local tile_color = 255
        
        if tileId == 0 then
          tile_color = 0
        end
        
        -- Calculate vertex positions
        local topleft = {}
        topleft[1] = current_col
        topleft[2] = (map.height - current_row)
        topleft[3] = tile_col * (uv_width + spacingWidth) + marginWidth
        topleft[4] = tile_row * (uv_height + spacingHeight) + marginHeight
        topleft[5] = tile_color
        topleft[6] = tile_color
        topleft[7] = tile_color
        topleft[8] = tile_color
        
        local topright = {}
        topright[1] = (current_col + 1)
        topright[2] = (map.height - current_row)
        topright[3] = tile_col * (uv_width + spacingWidth) + uv_width + marginWidth
        topright[4] = tile_row * (uv_height + spacingHeight) + marginHeight
        topright[5] = tile_color
        topright[6] = tile_color
        topright[7] = tile_color
        topright[8] = tile_color
        
        local bottomright = {}
        bottomright[1] = (current_col + 1)
        bottomright[2] = (map.height - (current_row + 1))
        bottomright[3] = tile_col * (uv_width + spacingWidth) + uv_width + marginWidth
        bottomright[4] = tile_row * (uv_height + spacingHeight) + uv_height + marginHeight
        bottomright[5] = tile_color
        bottomright[6] = tile_color
        bottomright[7] = tile_color
        bottomright[8] = tile_color
        
        local bottomleft = {}
        bottomleft[1] = current_col
        bottomleft[2] = (map.height - (current_row + 1))
        bottomleft[3] = tile_col * (uv_width + spacingWidth) + marginWidth
        bottomleft[4] = tile_row * (uv_height + spacingHeight) + uv_height + marginHeight
        bottomleft[5] = tile_color
        bottomleft[6] = tile_color
        bottomleft[7] = tile_color
        bottomleft[8] = tile_color
        
        if currentTile == 0 then
          print("Top Column: " .. tile_col)
        end

        -- Create vertices
        table.insert(vertices, bottomleft)
        table.insert(vertices, topleft)
        table.insert(vertices, bottomright)
        
        table.insert(vertices, topleft)
        table.insert(vertices, bottomright)
        table.insert(vertices, topright)
        currentTile += 1
      end
      
      self.mapMesh[k] = love.graphics.newMesh(vertices, "triangles", "static")
      vertices = {}
    end
  end
end

function TiledMap:isPointTraversable(x, y)
  -- Get the tile from the map
  local tile = self:getTileFromPoint(Vector2D(x, y))
  
  -- If it's a wall, then it's not traversible
  if tile.isWall then
    return false
  end
  
  -- Otherwise, the point is traversable
  return true
end

function TiledMap:pointInside(point, position, scale)
  return point.x > position.x - scale.x * 0.5 and point.x < position.x + scale.x * 0.5
     and point.y > position.y - scale.y * 0.5 and point.y < position.y + scale.y * 0.5
end

function TiledMap:bresenhamLine(x1, y1, x2, y2)
  local result = {}
  
  local steep = math.abs(y2 - y1) > math.abs(x2 - x1)
  if steep then
    x1, y1 = y1, x1
    x2, y2 = y2, x2
  end
  if x1 > x2 then
    x1, x2 = x2, x1
    y1, y2 = y2, y1
  end
  
  local dx = x2 - x1
  local dy = math.abs(y2 - y1)
  local error = 0
  local y = y1
  local yStep = -1;
  if y1 < y2 then yStep = 1 end
  
  for x=x1, x2 do
    if steep then
      table.insert(result, Vector2D(y, x))
    else
      table.insert(result, Vector2D(x, y))
    end
    
    error += dy
    
    if 2 * error >= dx then
      y += yStep
      error -= dx
    end
  end
  
  return result
end

function TiledMap:rayCast(position, direction)
  -- Table to hold the result information
  local result = {}
  result.collide = false
  
  -- Exit the function now if ray length is zero
  if direction:len2() <= 0.001 then
    result.collide = self:isPointTraversable(position.x, position.y)
    result.position = position
    
    return result
  end
  
  -- Get the list of points from the Bresenham algorithm
  local line = self:bresenhamLine(position.x, position.y,
                                  position.x + direction.x, position.y + direction.y)
  result.line = line
  
  if table.getn(line) > 0 then
    -- Loop through eahc space on the line
    for i=1, table.getn(line) do
      local rayPoint = line[i]
      
      if not self:isPointTraversable(rayPoint.x, rayPoint.y) then
        result.collide = true
        result.position = rayPoint
        
        break
      end
    end
  end
  
  return result
end

createClass("TiledMap", TiledMap)