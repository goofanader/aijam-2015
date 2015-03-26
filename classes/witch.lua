local class = require 'classes/Character'

Witch = Character:subclass('Witch')

function Witch:initialize(x, y)
   local image = love.graphics.newImage("assets/images/characters/witch.png")
   Character.initialize(self, image, x, y)
end
