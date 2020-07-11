require "Base/Global"

PUBLISH = false

WorldScale = 1
FontSize = 128
Fade = 255
UnderHUDFade = 255
DefaultFont = love.graphics.newFont("Data/Fonts/KenPixel Mini Square.ttf", 32)
TickRate = 0.2

OldDelta = love.timer.getDelta
maxDt = 1/60

MainCursor = nil
Pause = nil
Map = nil

function love.timer.getDelta()
  local dt = OldDelta()
  
  if dt > maxDt then
    return maxDt
  end
  return dt
end

keysdown = 0

function love.keyboard.isAnyKeyDown()
  return keysdown > 0
end

function love.keypressed(key, unicode)
    keysdown = keysdown + 1
end

function love.keyreleased(key)
    keysdown = keysdown - 1
end

function love.load(args)
  if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
    require("Base/lldebugger").start()
  end
  
  wwise.load(true)

  --Add in when we get sounds
  wwise.loadBank("./Banks/Init.bnk")
  wwise.loadBank("./Banks/Main.bnk")

  FlashShader = love.graphics.newShader("Data/Shaders/Flash.shader")

  math.randomseed(os.time())
  love.graphics.setDefaultFilter("linear")

  Gamestate.registerEvents()
  local files = love.filesystem.getDirectoryItems("GameStates")
  for k,v in pairs(files) do
    local f, err = love.filesystem.load("GameStates/" .. tostring(v))
    if not f then
      love.errhand(err)
    end
    f()
  end
  
  MainCamera = Camera.new(0,0, WorldScale)
  collectgarbage("stop")

  _RectangleMesh = love.graphics.newMesh{{0,0, 0,0}, {1,0, 0,0}, {1,1, 0,0}, {0,1, 0,0}}
  
  --_G.Font = love.graphics.setNewFont("Data/Fonts/kenvector_future.ttf", FontSize)
  love.graphics.setFont(DefaultFont)
  
  MainTarget = RenderTarget(love.graphics.getWidth(), love.graphics.getHeight(), 0)
  
  if(args[2] ~= nil) then
    Gamestate.switch(_G[args[2]])
  else
    Gamestate.switch(SampleState)
  end
end

local SleepTime = 0

function Sleep(ms)
  if SleepTime + ms >= 32 then
    return
  end

  SleepTime += ms

  local stime = love.timer.getTime()
  while love.timer.getTime() - stime < (ms / 1000) do
    collectgarbage("step", 0)
  end
end

function love.update(dt)
  if debuggee then debuggee.poll() end

  SleepTime = 0
  
  _G.dt = dt

  if GlobalConveyerAnimations then
    for k,v in pairs(GlobalConveyerAnimations) do
      v.anim:update(dt)
    end
  end
  
  MainCamera:update(dt)

  -- Update all the objects
  Profiler:End()
  Profiler:Start("GObj", Color(0,100,0,255))
  if Pause == nil then
    for id,args in pairs(_G.GameObjectInitList) do
      local obj = _G.GameObjectList[id]
      if obj then
        obj:onPostInitialize()
      end
    end

    _G.GameObjectInitList = {}

    for k,obj in pairs(_G.GameObjectList) do
      obj:update(dt)
    end
  else
    if not Pause:update(dt) then
      Pause:destroy()
      Pause = nil
    end
  end
  Profiler:End()
  
  --Collect garbage for 1ms
  Profiler:Start("GC", Color(255,255,0,255))
  local stime = love.timer.getTime()
  while love.timer.getTime() - stime < 0.01 do
    collectgarbage("step", 0)
  end
  Profiler:End()
  
  --FPS
  if not PUBLISH then
    love.window.setTitle("(FPS:" .. 1 / love.timer.getDelta() .. ")")
  end
  
  --Update keys for love.keyboard.isTriggered
  keyboard_events_old = {}
  for k,v in pairs(keyboard_events) do
    keyboard_events_old[k] = v
  end
  keyboard_events = {}

  mouse_events_old = {}
  for k,v in pairs(mouse_events) do
    mouse_events_old[k] = v
  end
  mouse_events = {}
end

function love.draw()
  -- Draw background
  love.graphics.setColor(0.2,0.2,0.2,255)
  love.graphics.rectangle("fill", 0,0, love.graphics.getWidth(), love.graphics.getHeight())
  
  if Map then
    MainCamera:attach()
    Map.map:drawBackground()
    MainCamera:detach()
  end
  
  -- Variables for drawing targets
  local mainRender = {}
  local mainText = {}
  local targets = {}

  -- Add objects to render target lists
  for k,obj in pairs(_G.GameObjectList) do
    -- Only add the object if it's visible
    if obj.visible then
      if obj.renderTarget then
        -- If the object has a render target, place it in that list
        local target = obj.renderTarget
        if not targets[target] then
          -- Create the list if it doesn't exist
          targets[target] = {}
          targets[target].objects = {}
          targets[target].text = {}
        end
        
        --If object has special draw list, run that
        if obj.customDrawList then
          obj:customDrawList(targets[target].objects)
        --Run default draw
        else
          table.insert(targets[target].objects, obj)
        end
      else
        -- Otherwise, add it to the main render
        
        --If object has special draw list, run that
        if obj.customDrawList then
          obj:customDrawList(mainRender)
        --Run default draw
        else
          table.insert(mainRender, obj)
        end
      end
    end
  end
  
  -- Add text to render target lists
  if _G.TextList then
    for k,text in pairs(_G.TextList) do
      if text.renderTarget then
        -- If the text has a render target, place it in that list
        local target = text.renderTarget
        if not targets[target] then
          targets[target] = {}
          targets[target].objects = {}
          targets[target].text = {}
        end
        table.insert(targets[target].text, text)
      else
        -- Otherwise, add it the main text list
        table.insert(mainText, text)
      end
    end
    -- Clear the global text list to be empty for next frame
    _G.TextList = {}
  end  

  -- Sort targets
  table.sort(targets, function(a,b) return a.zOrder < b.zOrder end)
  
  -- Draw each target
  for target,list in pairs(targets) do
    -- Sort objects by z order
    table.sort(list.objects, function(a,b) return a.zOrder < b.zOrder end)
    
    -- The key to the table was it's canvas, so set that
    love.graphics.setCanvas(target.canvas)
    love.graphics.clear()
    
    -- Attach the main camera and draw all the objects and text
    MainCamera:attach()
    for k,obj in ipairs(list.objects) do
      obj:draw()
    end
    for k,text in pairs(mainText) do
      love.graphics.setFont(text.font or DefaultFont)
      love.graphics.setColor(text.color.r, text.color.g, text.color.b, text.color.a)
      love.graphics.printf(text.text, text.x, text.y, text.width, text.align, math.rad(text.rot), text.fontSize, -text.fontSize, 0.5 * text.width, 0)
    end
    MainCamera:detach()
  end
  
  -- Set the main target canvas
  love.graphics.setCanvas(MainTarget.canvas)
  love.graphics.clear()
  
  -- Sort main render
  table.sort(mainRender, function(a,b)
    if a.zOrder == b.zOrder then
      return (a.position.y) > (b.position.y)
    end

    return a.zOrder < b.zOrder
  end)

  -- Attach camera and draw main objects and text
  MainCamera:attach()
  for k,obj in pairs(mainRender) do
    obj:draw()
  end
  for k,text in pairs(mainText) do
    love.graphics.setFont(text.font or DefaultFont)
    love.graphics.setColor(text.color.r, text.color.g, text.color.b, text.color.a)
    love.graphics.printf(text.text, text.x, text.y, text.width, text.align, math.rad(text.rot), text.fontSize, -text.fontSize, 0.5 * text.width, 0)
  end
  MainCamera:detach()
  
  -- Draw all the render targets
  love.graphics.setCanvas()
  love.graphics.setColor(255, 255, 255, 255)
  for target,v in pairs(targets) do
    target:Draw()
  end
  
  -- Then draw the main render
  MainTarget:draw()
  
  -- Draw the fade block
  love.graphics.setColor(0,0,0, 255 - UnderHUDFade)
  local verts = { 0, 0,
                  0, love.graphics.getHeight(),
                  love.graphics.getWidth(), love.graphics.getHeight(),
                  love.graphics.getWidth(), 0 }
  love.graphics.polygon('fill', verts)

  -- Draw the HUD
  DrawingHUD = true
  drawHUD()
  DrawingHUD = false
  
  -- Draw the fade block
  love.graphics.setColor(0,0,0, 255 - Fade)
  local verts = { 0, 0,
                  0, love.graphics.getHeight(),
                  love.graphics.getWidth(), love.graphics.getHeight(),
                  love.graphics.getWidth(), 0 }
  love.graphics.polygon('fill', verts)
  
  -- Draw pause screen if it exists
  if Pause then
    Pause:draw()
  end
end

function drawHUD()
  -- Reset canvas and shader
  love.graphics.setCanvas()
  love.graphics.setShader()
  
  for k,obj in pairs(_G.GameObjectList) do
    if obj.drawHUD then
      obj:drawHUD()
    end
  end
end

function love.quit()
  love.event.quit()
end

function love.run()
  -- Set a random seed
	if love.math then
		love.math.setRandomSeed(os.time())
		for i=1,3 do love.math.random() end
	end
 
	if love.event then
		love.event.pump()
	end
 
	if love.load then love.load(arg) end
 
	-- We don't want the first frame's dt to include time taken by love.load.
	if love.timer then love.timer.step() end
 
	local dt = 0
 
	-- Main loop time.
	while true do
		-- Process events.
		Profiler:Start("Events", Color(0,0,255,255))
		if love.event then
			love.event.pump()
			for e,a,b,c,d in love.event.poll() do
				if e == "quit" then
					if not love.quit or not love.quit() then
						if love.audio then
							love.audio.stop()
            end
						return
					end
				end
				love.handlers[e](a,b,c,d)
			end
		end
		Profiler:End()

		-- Update dt, as we'll be passing it to update
		if love.timer then
			love.timer.step()
      dt = love.timer.getDelta()
		end
 
		-- Call update and draw
		Profiler:Start("Update", Color(0,255,0,255))
    if wwise then wwise.update() end --Update sound engine
		if love.update then love.update(dt) end -- will pass 0 if love.timer is disabled
    Profiler:End()
 
		if love.window and love.graphics and love.window.isOpen() then
		  Profiler:Start("Draw", Color(255,0,0,255))
			love.graphics.clear()
			love.graphics.origin()
			if love.draw then love.draw() end
			Profiler:End()
			
			Profiler:Draw()
			
			Profiler:Start("Present", Color(255,255,255,255))
			love.graphics.present()
			Profiler:End()
		end
 
		--if love.timer then love.timer.sleep(0.001) end
	end


end