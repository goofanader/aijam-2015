local class = require 'middleclass'
 
Character = class('Character')

function Character:initialize(image, x, y)
   self.image = image
   self.x = x
   self.y = y
end

function Character:draw()
   love.graphics.draw(self.image, (self.x-1)*IMAGE_SIZE, (self.y-1)*IMAGE_SIZE, 0)
end
