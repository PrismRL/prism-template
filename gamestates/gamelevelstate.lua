local keybindings = require "keybindingschema"

--- @class MyGameLevelState : LevelState
--- A custom game level state responsible for initializing the level map,
--- handling input, and drawing the state to the screen.
---
--- @field path Path
--- @field level Level
--- @overload fun(display: Display): MyGameLevelState
local MyGameLevelState = spectrum.LevelState:extend "MyGameLevelState"

--- @param display Display
function MyGameLevelState:__new(display)
   -- Construct a simple test map using MapBuilder.
   -- In a complete game, you'd likely extract this logic to a separate module
   -- and pass in an existing player object between levels.
   local mapbuilder = prism.MapBuilder(prism.cells.Wall)

   mapbuilder:drawRectangle(0, 0, 32, 32, prism.cells.Wall)
   -- Fill the interior with floor tiles
   mapbuilder:drawRectangle(1, 1, 31, 31, prism.cells.Floor)
   -- Add a small block of walls within the map
   mapbuilder:drawRectangle(5, 5, 7, 7, prism.cells.Wall)
   -- Add a pit area to the southeast
   mapbuilder:drawRectangle(20, 20, 25, 25, prism.cells.Pit)

   -- Place the player character at a starting location
   mapbuilder:addActor(prism.actors.Player(), 12, 12)

   -- Build the map and instantiate the level with systems
   local map, actors = mapbuilder:build()
   local level = prism.Level(map, actors, {
      prism.systems.Senses(),
      prism.systems.Sight(),
   })

   -- Initialize with the created level and display, the heavy lifting is done by
   -- the parent class.
   spectrum.LevelState.__new(self, level, display)
end

function MyGameLevelState:handleMessage(message)
   spectrum.LevelState.handleMessage(self, message)

   -- Handle any messages sent to the level state from the level. LevelState
   -- handles a few built-in messages for you, like the decision you fill out
   -- here.

   -- This is where you'd process custom messages like advancing to the next
   -- level or triggering a game over.
end

--- @param primary Senses[] { curActor:getComponent(prism.components.Senses)}
---@param secondary Senses[]
function MyGameLevelState:draw(primary, secondary)
   if not self.decision then return end
   
   self.display:clear()

   local position = self.decision.actor:getPosition()
   if not position then return end

   local x, y = self.display:getCenterOffset(position:decompose())
   self.display:setCamera(x, y)

   local primary, secondary = self:getSenses()
   -- Render the level using the actor’s senses
   self.display:putSenses(primary, secondary)

   -- custom terminal drawing goes here!

   -- Say hello!
   self.display:putString(1, 1, "Hello prism!")

   -- Actually render the terminal out and present it to the screen.
   -- You could use love2d to translate and say center a smaller terminal or
   -- offset it for custom non-terminal UI elements. If you do scale the UI
   -- just remember that display:getCellUnderMouse expects the mouse in the
   -- display's local pixel coordinates
   self.display:draw()

   -- custom love2d drawing goes here!
end

-- Maps string actions from the keybinding schema to directional vectors.
local keybindOffsets = {
   ["move up"] = prism.Vector2.UP,
   ["move left"] = prism.Vector2.LEFT,
   ["move down"] = prism.Vector2.DOWN,
   ["move right"] = prism.Vector2.RIGHT,
   ["move up-left"] = prism.Vector2.UP_LEFT,
   ["move up-right"] = prism.Vector2.UP_RIGHT,
   ["move down-left"] = prism.Vector2.DOWN_LEFT,
   ["move down-right"] = prism.Vector2.DOWN_RIGHT,
}

-- The input handling functions act as the player controller’s logic.
-- You should NOT mutate the Level here directly. Instead, find a valid
-- action and set it in the decision object. It will then be executed by
-- the level. This is a similar pattern to the example KoboldController.
function MyGameLevelState:keypressed(key, scancode)
   -- handles opening geometer for us
   spectrum.LevelState.keypressed(self, key, scancode)

   local decision = self.decision
   if not decision then return end

   local owner = decision.actor

   -- Resolve the action string from the keybinding schema
   local action = keybindings:keypressed(key)

   -- Attempt to translate the action into a directional move
   if keybindOffsets[action] then
      local destination = owner:getPosition() + keybindOffsets[action]

      local move = prism.actions.Move(owner, destination)
      if self.level:canPerform(move) then
         decision:setAction(move)
         return
      end
   end

   -- Handle waiting
   if action == "wait" then decision:setAction(prism.actions.Wait(self.decision.actor)) end
end

return MyGameLevelState
