require("middleclass")
require("middleclass-commons")

BGCreator = class("BGCreator")

function BGCreator:initialize(tilesheet, numRows, numColumns, maxMapWidth, maxMapHeight, sizeOfMap)
   self.tilesheet = tilesheet
   self.imageSize = {}
   self.imageSize.width = tilesheet:getWidth() / numColumns
   self.imageSize.height = tilesheet:getHeight() / numRows

   self.tiles = {}
   local counter = 0

   for i = 0, tilesheet:getHeight() - 1, self.imageSize.height do
      for j = 0, tilesheet:getWidth() - 1, self.imageSize.width do
         self.tiles[counter] = love.graphics.newQuad(j, i, self.imageSize.width, self.imageSize.height, tilesheet:getDimensions())
         counter = counter + 1
      end
   end

   self:reload(maxMapWidth, maxMapHeight, sizeOfMap)
end

function BGCreator:draw()
   local row = 0

   for i = 1, #self.mapArray do
      local col = 0
      for j = 1, #self.mapArray[i] do
         love.graphics.setColor(255,255,255)
         love.graphics.draw(self.tilesheet, self.tiles[self.mapArray[i][j]], col, row)--row, col)

         if hasBitmap then
            love.graphics.setColor(0,0,0)
            love.graphics.print(self.mapBitArray[i][j], col+10, row+10)
         end
         col = col + self.imageSize.width
      end

      row = row + self.imageSize.height
   end
end

function BGCreator:gameOfLife(numIterations)
   if not numIterations then
      numIterations = DEFAULT_NUM_ITERATIONS
   end

   for iteration = 1, numIterations do
      local newArray = {}
      for i = 1, #self.mapBitArray do
         newArray[i] = {}

         for j = 1, #self.mapBitArray[i] do
            newArray[i][j] = self.mapBitArray[i][j]
            local north = self.mapBitArray[i - 1] and self.mapBitArray[i - 1][j] or 1
            local northwest = 0--self.mapBitArray[i - 1] and self.mapBitArray[i - 1][j - 1] or 1
            local west = self.mapBitArray[i][j - 1] and self.mapBitArray[i][j - 1] or 1
            local northeast = 0--self.mapBitArray[i - 1] and self.mapBitArray[i - 1][j + 1] or 1
            local east = self.mapBitArray[i][j + 1] and self.mapBitArray[i][j + 1] or 1
            local southeast = 0--self.mapBitArray[i + 1] and self.mapBitArray[i + 1][j + 1] or 1
            local south = self.mapBitArray[i + 1] and self.mapBitArray[i + 1][j] or 1
            local southwest = 0--self.mapBitArray[i + 1] and self.mapBitArray[i + 1][j - 1] or 1

            local numNeighbors = north + west + east + south + northwest + northeast + southwest + southeast

            -- apply rules of the Game of Life
            if numNeighbors < 2 and numNeighbors > 4 then
               -- if has less than three neighbors, it dies
               newArray[i][j] = 0
            elseif self.mapBitArray[i][j] == 0 and numNeighbors > 3 then
               -- come back to life!
               newArray[i][j] = 1
            end
         end
      end

      self.mapBitArray = newArray
   end
end

function BGCreator:reload(maxMapWidth, maxMapHeight, sizeOfMap, gameIterations)
   if not sizeOfMap then
      sizeOfMap = {}
      math.randomseed(os.time())
      math.random()
      math.random()

      if not maxMapHeight then
         maxMapHeight = maxMapWidth
      end

      sizeOfMap.x = math.random(maxMapWidth)
      sizeOfMap.y = math.random(maxMapHeight)
   end

   self.mapBitArray = {}
   for i = 1, sizeOfMap.y do
      self.mapBitArray[i] = {}

      for j = 1, sizeOfMap.x do
         if math.random() < .5 then
            self.mapBitArray[i][j] = 0
         else
            self.mapBitArray[i][j] = 1
         end
      end
   end
   
   self:gameOfLife(gameIterations)
   self:rerunMap()
   --[[self.mapArray = {}
   for i = 1, #self.mapBitArray do
      self.mapArray[i] = {}

      for j = 1, #self.mapBitArray[i] do
         self.mapArray[i][j] = 0

         if self.mapBitArray[i][j] ~= 0 then
            if self.mapBitArray[i - 1] and self.mapBitArray[i - 1][j] == 1 then
               self.mapArray[i][j] = self.mapArray[i][j] + 1
            end
            if self.mapBitArray[i + 1] and self.mapBitArray[i + 1][j] == 1 then
               self.mapArray[i][j] = self.mapArray[i][j] + 4
            end
            if self.mapBitArray[i][j - 1] and self.mapBitArray[i][j - 1] == 1 then
               self.mapArray[i][j] = self.mapArray[i][j] + 8
            end
            if self.mapBitArray[i][j + 1] and self.mapBitArray[i][j + 1] == 1 then
               self.mapArray[i][j] = self.mapArray[i][j] + 2
            end
         end
      end
   end]]
end

function BGCreator:rerunMap()
   self.mapArray = {}
   for i = 1, #self.mapBitArray do
      self.mapArray[i] = {}

      for j = 1, #self.mapBitArray[i] do
         self.mapArray[i][j] = 0

         if self.mapBitArray[i][j] ~= 0 then
            if self.mapBitArray[i - 1] and self.mapBitArray[i - 1][j] == 1 then
               self.mapArray[i][j] = self.mapArray[i][j] + 1
            end
            if self.mapBitArray[i + 1] and self.mapBitArray[i + 1][j] == 1 then
               self.mapArray[i][j] = self.mapArray[i][j] + 4
            end
            if self.mapBitArray[i][j - 1] and self.mapBitArray[i][j - 1] == 1 then
               self.mapArray[i][j] = self.mapArray[i][j] + 8
            end
            if self.mapBitArray[i][j + 1] and self.mapBitArray[i][j + 1] == 1 then
               self.mapArray[i][j] = self.mapArray[i][j] + 2
            end
         end
      end
   end
end
   