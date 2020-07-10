--[[
]]

AnimationController = {}

function AnimationController:AnimationController(parent, ...)
  -- Hold parent so we can change it's image
  self.Parent = parent
  
  self.States = {}
  self.CurrentState = nil
  self.CurrentFrame = 1
  self.Time = 0
  self.Co = makeCoroutine(self.animLoop, self)
  self.AnimEnd = false
end

function AnimationController:update()
  -- Update if there is a current state
  if self.CurrentState ~= nil and self.Parent ~= nil then
    self.Co:resume()
  end
end

function AnimationController:animLoop()
  while true do
    -- Change the image to the current frame
    self.Parent:setImage(self.CurrentState.Frames[self.CurrentFrame])
    
    -- Check if enough time has passed to change frames
    self.Time += love.timer.getDelta()
    if self.Time > self.CurrentState.FrameTime then
      
      self.CurrentFrame += 1
      
      if self.CurrentFrame > table.getn(self.CurrentState.Frames) then
        if self.CurrentState.Loop then
          self.CurrentFrame = 1
        else
          self.CurrentFrame = table.getn(self.CurrentState.Frames)
          self.AnimEnd = true
        end
      end
      
      self.Time = 0
    end
    
    coroutine.yield()
  end
end

function AnimationController:setState(stateName)
  -- Check if current state is nil or is the same state
  if self.CurrentState == nil or self.CurrentState.Name ~= stateName then
    local state = self:getState(stateName)
    if state ~= nil then
      self.CurrentState = state
      self.CurrentFrame = 1
      self.Time = 0
      self.AnimEnd = false
    end
  end
end

function AnimationController:addFrame(stateName, imageName)
  -- Find the state to put the frame in
  local state = self:getState(stateName)
  
  -- If the state isn't found, create it
  if state == nil then
    state = {}
    state.Name = stateName
    state.Frames = {}
    state.FrameTime = 1
    state.Loop = false
    table.insert(self.States, state)
  end
  
  -- Add the image frame to the state
  table.insert(state.Frames, imageName)
end

function AnimationController:setLoop(stateName, loop)
  -- Get the state to get it's loop
  local state = self:getState(stateName)
  
  -- if the state exists, set its speed
  if state ~= nil then
    state.Loop = loop
  end
end

function AnimationController:getLoop(stateName)
  -- Get the state to get it's loop
  local state = self:getState(stateName)
  
  -- if the state exists, set its speed
  if state ~= nil then
    return state.Loop
  end
end

function AnimationController:setAnimTime(stateName, seconds)
  -- Get the state to set it's speed
  local state = self:getState(stateName)
  
  -- if the state exists, set its speed
  if state ~= nil then
    state.FrameTime = seconds / table.getn(state.Frames)
  end
end

function AnimationController:isAnimEnd()
  return self.AnimEnd
end

function AnimationController:resetAnim()
  self.CurrentFrame = 1
  self.Time = 0
  self.AnimEnd = false
end

function AnimationController:getState(stateName)
  -- Find the state to put the frame in
  local state = nil
  
  for k,st in pairs(self.States) do
    if st.Name == stateName then
      state = st
      break
    end
  end
  
  return state
end

createClass("AnimationController", AnimationController)