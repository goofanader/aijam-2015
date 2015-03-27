local class = require 'classes/Character'
local anim8 = require 'libraries/anim8'

Witch = Character:subclass('Witch')

local REACTION_TIME = 1 --seconds
local time = 0

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

function Witch:update(dt)
   time = time + dt
   if time > REACTION_TIME then
      time = 0
      if self.path then
         local temp = table.remove(self.path)
         if temp then
            self:move_to(temp[1],temp[2])
         end
      end
      
   end
   
   Character.update(self, dt)
end
