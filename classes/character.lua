local class = require 'middleclass'
local anim8 = require 'libraries/anim8'

Character = class('Character')

function Character:initialize(image, x, y)
   self.image = image
   self.x = x
   self.y = y
   self.ACCESSIBLE_TERRAIN = {1}
   
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

function Character:move(x, y)
   if self:isValidLocation(self.x + x, self.y + y) then
      self.x = self.x + x
      self.y = self.y + y
   end
end

function Character:move_to(x, y)
   if self:isValidLocation(x, y) then
      self.x = x
      self.y = y
      return true
   else
      return false
   end
end

function Character:path_to(x, y)
   if self:isValidLocation(x, y) then
      local temp = self:pathfind(x, y)
      if temp then
         self.path = temp
      else
         return false
      end
      return true
   else
      return false
   end
end

function Character:isValidLocation(x, y)
   if x < 1 or x > MAP_X then
      return false
   end
   if y < 1 or y > MAP_Y then
      return false
   end
   for key,terrainType in pairs(self.ACCESSIBLE_TERRAIN) do
      if map[x][y] == terrainType then
         return true
      end
   end
   return false
end

function Character:pathfind(x, y)
   local start = {self.x,self.y}
   local goal = {x, y}
   local closedset = {} --nodes already evaluated
   local in_openset = {}
   local came_from = {} --map of navigated nodes
   local g = {} --cost from start along best known path
   local f = {} --estimated total cost from start to goal
   for i=1,MAP_X do
      closedset[i] = {}
      in_openset[i] = {}
      came_from[i] = {}
      g[i] = {}
      f[i] = {}
   end
   local openset = {} --set of tentative nodes to be evaluated, initially containing the start node
   table.insert(openset, start)
   
   in_openset[start[1]][start[2]] = true
   g[start[1]][start[2]] = 0
   f[start[1]][start[2]] = 0 + heuristic(start,goal)
   
   while openset ~= {} do
      --Find the node in openvset having the lowest f value
      local min_f = 0
      local current_node
      local current_i
      for i,v in ipairs(openset) do
         local node = openset[i]
         local f_value = f[node[1]][node[2]]
         if min_f == 0 or f_value < min_f then
            min_f = f_value
            current_node = node
            current_i = i
         end
      end
      
      --If it's the goal, we're done!
      if current_node[1] == goal[1] and current_node[2] == goal[2] then
         print("Reconstructing path:")
         return reconstructPath(came_from, goal)
      end

      if #openset > (MAP_X*MAP_Y) then
         print("Exceeded possible number of map positions, exiting pathfinding")
         return false
      end
      
      --else move it from open set to closed set
      in_openset[current_node[1]][current_node[2]] = false
      closedset[current_node[1]][current_node[2]] = true
      table.remove(openset, current_i)
      
      --go through neighbors and add them to the openset
      local neighbors = self:getNeighbors(current_node)
      
      for i,neighbor in ipairs(neighbors) do
         --print("Closed Set: ")
         --print(closedset[neighbor[1]][neighbor[2]])
         if closedset[neighbor[1]][neighbor[2]] ~= true then
            local tentative_g = g[current_node[1]][current_node[2]] + 1
            if in_openset[neighbor[1]][neighbor[2]] ~= true or tentative_g < g[neighbor[1]][neighbor[2]] then
               came_from[neighbor[1]][neighbor[2]] = current_node
               g[neighbor[1]][neighbor[2]] = tentative_g
               f[neighbor[1]][neighbor[2]] = tentative_g + heuristic(neighbor, goal)
               if in_openset[neighbor[1]][neighbor[2]] ~= true then
                  table.insert(openset, neighbor)
                  in_openset[neighbor[1]][neighbor[2]] = true
               end
            end
         end
      end
   end
   -- failure :(
   return false
end

function reconstructPath(came_from, current)
   local path = {current}
   while came_from[current[1]][current[2]] do
      current = came_from[current[1]][current[2]]
      table.insert(path, current)
   end
   return path
end

function Character:getNeighbors(pos)
   local x = pos[1]
   local y = pos[2]
   local neighbors = {}
   if self:isValidLocation(x+1,y) then
      table.insert(neighbors, {x+1,y})
   end
   if self:isValidLocation(x-1,y) then
      table.insert(neighbors, {x-1,y})
   end
   if self:isValidLocation(x,y+1) then
      table.insert(neighbors, {x,y+1})
   end
   if self:isValidLocation(x,y-1) then
      table.insert(neighbors, {x,y-1})
   end
   return neighbors
end

function heuristic(start, goal)
   x = math.abs(goal[1] - start[1])
   y = math.abs(goal[2] - start[2])
   return x + y
end
