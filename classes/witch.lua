local class = require 'classes/Character'
local anim8 = require 'libraries/anim8'

Witch = Character:subclass('Witch')

function Witch:initialize(x, y)
   local image = love.graphics.newImage("assets/images/characters/Alli_Sheet.png")
   Character.initialize(self, image, x, y)
   
   -- Add the animations --
   self.animations[IDLE_STATE] = anim8.newAnimation(self.animGrid(2, 1), 1/6)
   self.animations[WALKING_STATE] = anim8.newAnimation(self.animGrid(1,1,2,1,3,1,2,1), 1/6)
   self.animations[ATTACK_STATE] = anim8.newAnimation(self.animGrid('4-5', 1), 1/6)
   self.animations[HURT_STATE] = anim8.newAnimation(self.animGrid(6, 1), 1/6)
   
   self.currAnimation = IDLE_STATE
end
