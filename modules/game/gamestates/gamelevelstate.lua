local controls = require "controls"

--- @class GameLevelState : LevelState
--- A custom game level state responsible for initializing the level map,
--- handling input, and drawing the state to the screen.
---
--- @overload fun(display: Display): GameLevelState
local GameLevelState = spectrum.gamestates.LevelState:extend "GameLevelState"

--- @param display Display
function GameLevelState:__new(display)
   -- Construct a simple test map using MapBuilder.
   -- In a complete game, you'd likely extract this logic to a separate module
   -- and pass in an existing player object between levels.
   local builder = prism.LevelBuilder()

   builder:rectangle("line", 0, 0, 32, 32, prism.cells.Wall)
   -- Fill the interior with floor tiles
   builder:rectangle("fill", 1, 1, 31, 31, prism.cells.Floor)
   -- Add a small block of walls within the map
   builder:rectangle("fill", 5, 5, 7, 7, prism.cells.Wall)
   -- Add a pit area to the southeast
   builder:rectangle("fill", 20, 20, 25, 25, prism.cells.Pit)

   -- Place the player character at a starting location
   builder:addActor(prism.actors.Player(), 12, 12)

   -- Add systems
   builder:addSystems(prism.systems.SensesSystem(), prism.systems.SightSystem())

   -- Initialize with the created level and display, the heavy lifting is done by
   -- the parent class.
   self.super.__new(self, builder:build(prism.cells.Wall), display)
end

function GameLevelState:handleMessage(message)
   self.super.handleMessage(self, message)

   -- Handle any messages sent to the level state from the level. LevelState
   -- handles a few built-in messages for you, like the decision you fill out
   -- here.

   -- This is where you'd process custom messages like advancing to the next
   -- level or triggering a game over.
end

-- updateDecision is called whenever there's an ActionDecision to handle.
function GameLevelState:updateDecision(dt, owner, decision)
   -- Controls need to be updated each frame.
   controls:update()

   -- Controls are accessed directly via table index.
   if controls.move.pressed then
      local destination = owner:getPosition() + controls.move.vector
      local move = prism.actions.Move(owner, destination)
      if self:setAction(move) then return end
   end

   if controls.wait.pressed then self:setAction(prism.actions.Wait(owner)) end
end

function GameLevelState:draw()
   self.display:clear()

   local player = self.level:query(prism.components.PlayerController):first()

   if not player then
      -- You would normally transition to a game over state
      self.display:putLevel(self.level)
   else
      local position = player:expectPosition()

      local x, y = self.display:getCenterOffset(position:decompose())
      self.display:setCamera(x, y)

      local primary, secondary = self:getSenses()
      -- Render the level using the player’s senses
      self.display:beginCamera()
      self.display:putSenses(primary, secondary, self.level)
      self.display:endCamera()
   end

   -- custom terminal drawing goes here!

   -- Say hello!
   self.display:print(1, 1, "Hello prism!")

   -- Actually render the terminal out and present it to the screen.
   -- You could use love2d to translate and say center a smaller terminal or
   -- offset it for custom non-terminal UI elements. If you do scale the UI
   -- just remember that display:getCellUnderMouse expects the mouse in the
   -- display's local pixel coordinates
   self.display:draw()

   -- custom love2d drawing goes here!
end

function GameLevelState:resume()
   -- Run senses when we resume from e.g. Geometer.
   self.level:getSystem(prism.systems.SensesSystem):postInitialize(self.level)
end

return GameLevelState
