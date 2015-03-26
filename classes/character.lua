local class = require 'middleclass'
local anim8 = require 'libraries/anim8'
 
Character = class('Character')

function Character:initialize(image, x, y)
   self.image = image
   self.x = x
   self.y = y
   
   self.animGrid = anim8.newGrid(IMAGE_SIZE, IMAGE_SIZE, image:getWidth(), image:getHeight())
   self.animations = {}
   self.currAnimation = 1
end

function Character:update(dt)
   self.animations[self.currAnimation]:update(dt)
end

function Character:draw()
   self.animations[self.currAnimation]:draw(self.image, (self.x - 1) * IMAGE_SIZE, (self.y - 1) * IMAGE_SIZE)
   --love.graphics.draw(self.image, (self.x-1)*IMAGE_SIZE, (self.y-1)*IMAGE_SIZE, 0)
end
