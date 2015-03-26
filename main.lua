require("constants")
require("libraries/bgCreator")
require("classes/Familiar")
require("classes/Witch")

function love.load()
   tilesheet = love.graphics.newImage("assets/images/background/Ground_Tilesheet.png")
   local sizeOfMap = {}
   sizeOfMap.x = 20
   sizeOfMap.y = 15

   --bg = BGCreator:new(tilesheet, 1, 16, 20, 15, sizeOfMap, sizeOfMap)
   
   --Janky test map by Andrew!
   map = {}
   for i=1, 10 do
      map[i] = {}
      for j=1, 10 do
         map[i][j] = 1
      end
   end
   grass = love.graphics.newImage("assets/images/background/grass.png")
   
   --Start characters in their starting places
   witch = Witch:new(1,1)
   cat = Familiar:new(5,5)
   
   love.graphics.setBackgroundColor(0,0,255)
end

function love.update(dt)
   
end

function love.draw()
   --bg:draw()
   
   --janky test map by Andrew!
   for i=1, #map do
      for j=1, #map[i] do
         love.graphics.setColor(255,255,255)
         love.graphics.draw(grass, (i-1)*IMAGE_SIZE, (j-1)*IMAGE_SIZE, 0)
      end
   end
   
   witch:draw()
   cat:draw()
   
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
   
   if key == 'right' or key == 'd' then
      cat.x = cat.x + 1
   end
   
   if key == 'left' or key == 'a' then
      cat.x = cat.x - 1
   end
   
   if key == 'up' or key == 'w' then
      cat.y = cat.y - 1
   end
   
   if key == 'down' or key == 's' then
      cat.y = cat.y + 1
   end
   
end