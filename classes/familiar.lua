local class = require 'classes/Character'
local anim8 = require 'libraries/anim8'

Familiar = Character:subclass('Familiar')

function Familiar:initialize(x, y)
   local image = love.graphics.newImage("assets/images/characters/CatHue_Sheet.png")
   Character.initialize(self, image, x, y)
   
   -- Add the animations --
   self.animations[IDLE_STATE] = anim8.newAnimation(self.animGrid('1-2', 1), 1/3)
   self.animations[WALKING_STATE] = anim8.newAnimation(self.animGrid(4,1,5,1,4,1,3,1), 1/6)
   self.animations[ATTACK_STATE] = anim8.newAnimation(self.animGrid('6-7', 1), 1/6)
   
   self.currAnimation = IDLE_STATE
end
