require("constants")
require("libraries/bgCreator")

function love.load()
   tilesheet = love.graphics.newImage("assets/images/background/Ground_Tilesheet.png")
   local sizeOfMap = {}
   sizeOfMap.x = 20
   sizeOfMap.y = 15

   bg = BGCreator:new(tilesheet, 1, 16, 20, 15, sizeOfMap, sizeOfMap)

   love.graphics.setBackgroundColor(0,0,255)
end

function love.update(dt)
end

function love.draw()
   bg:draw()
end

function love.keypressed(key, isrepeat)
   if key == 'r' then
      local sizeOfMap = {}
      sizeOfMap.x = 20
      sizeOfMap.y = 15
      bg:reload(20, 15, sizeOfMap)
   end
   
   if key == 'b' then
      hasBitmap = not hasBitmap
   end
   
   if key == 'g' then
      bg:gameOfLife(1)
      bg:rerunMap()
   end

   if key == 'escape' then
      love.event.quit()
   end
end