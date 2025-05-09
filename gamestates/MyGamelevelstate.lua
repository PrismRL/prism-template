local keybindings = require "keybindingschema"

--- @class MyGameLevelState : LevelState
--- A custom game level state responsible for initializing the level map,
--- handling input, and drawing the state to the screen.
---
--- @field path Path
--- @field level Level
--- @overload fun(): MyGameLevelState
local MyGameLevelState = spectrum.LevelState:extend "MyGameLevelState"

function MyGameLevelState:__new()
   -- Construct a simple test map using MapBuilder.
   -- In a complete game, you'd likely extract this logic to a separate module
   -- and pass in an existing player object between levels.

   local mapbuilder = prism.MapBuilder(prism.cells.Wall)

   -- Draw the outer walls of the level
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

   -- Load a sprite atlas and configure the terminal-style display
   local spriteAtlas = spectrum.SpriteAtlas.fromASCIIGrid("display/wanderlust_16x16.png", 16, 16)
   local display = spectrum.Display(81, 41, spriteAtlas, prism.Vector2(16, 16))

   -- Automatically size the window to match the terminal dimensions
   display:fitWindowToTerminal()

   -- Initialize with the created level and display, the heavy lifting is done by
   -- the parent class.
   spectrum.LevelState.__new(self, level, display)
end

function MyGameLevelState:handleMessage(message)
   spectrum.LevelState.handleMessage(self, message)

   -- Handle any messages sent to the level state.
   -- This is where you'd process custom messages like advancing to the next
   -- level or triggering a game over.
end

function MyGameLevelState:_draw(primary, secondary)
   -- Center the camera on the active actor
   local position = self.decision.actor:getPosition()
   local x, y = self.display:getCenterOffset(position:decompose())
   self.display:setCamera(x, y)

   -- Render the level using the actor’s senses
   self.display:putSenses(primary, secondary)

   -- Say hello!
   self.display:putString(1, 1, "Hello prism!")
end

function MyGameLevelState:draw()
   -- Perform default draw behavior, calling _draw above after
   -- some bookkeeping
   spectrum.LevelState.draw(self)

   -- Add any custom Love2D drawing code here!
end

-- Maps string actions from the keybinding schema to directional vectors.
-- These vectors are used to calculate movement destinations.
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
-- the level.
function MyGameLevelState:keypressed(key, scancode)
   -- handles opening geometer for us
   spectrum.LevelState.keypressed(self, key, scancode)

   local decision = self.decision
   ---@cast decision ActionDecision

   -- Resolve the action string from the keybinding schema
   local action = keybindings:keypressed(key)

   -- Attempt to translate the action into a directional move
   if keybindOffsets[action] then
      local owner = self.decision.actor
      local destination = owner:getPosition() + keybindOffsets[action]

      local move = prism.actions.Move(owner, { destination })
      if move:canPerform(self.level) then
         decision:setAction(move)
         return
      end
   end

   -- Handle waiting as a fallback or deliberate action
   if action == "wait" then
      decision:setAction(prism.actions.Wait(self.decision.actor))
   end
end

function MyGameLevelState:mousepressed(x, y, button, istouch, presses)
   -- Handle mouse input here (if needed)
end

return MyGameLevelState
