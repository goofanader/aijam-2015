local class = require 'classes/Character'

Familiar = Character:subclass('Familiar')

function Familiar:initialize(x, y)
   local image = love.graphics.newImage("assets/images/characters/cat.png")
   Character.initialize(self, image, x, y)
end
