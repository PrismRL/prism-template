local keybindings = require "keybindingschema"

--- @class MyGameLevelState : LevelState
--- @field path Path
--- @field level Level
--- @overload fun(mapbuilder: MapBuilder): MyGameLevelState
local MyGameLevelState = spectrum.LevelState:extend "MyGameLevelState"

--- @param mapbuilder MapBuilder
function MyGameLevelState:__new(mapbuilder)
   -- build a basic test map, realistically you'd want to split this off
   -- into it's own module but as an example we're putting it here
   local mapbuilder = prism.MapBuilder(prism.cells.Wall)
   mapbuilder:drawRectangle(0, 0, 32, 32, prism.cells.Wall)
   mapbuilder:drawRectangle(1, 1, 31, 31, prism.cells.Floor)
   mapbuilder:drawRectangle(5, 5, 7, 7, prism.cells.Wall)
   mapbuilder:drawRectangle(20, 20, 25, 25, prism.cells.Pit)

   -- create and add the player you'd probably take this in as an argument
   -- to the levelstate in a real game so as the player descends you can
   -- pass it to the new level
   mapbuilder:addActor(prism.actors.Player(), 12, 12)

   -- build the map and put together the level
   local map, actors = mapbuilder:build()
   local level = prism.Level(map, actors, {
      prism.systems.Senses(),
      prism.systems.Sight()
   })

   -- Load up our sprite atlas and set up the terminal display
   local spriteAtlas = spectrum.SpriteAtlas.fromASCIIGrid("display/wanderlust_16x16.png", 16, 16)
   local display = spectrum.Display(81, 41, spriteAtlas, prism.Vector2(16, 16))

   -- fit the window size to the terminal we just made
   display:fitWindowToTerminal()

   spectrum.LevelState.__new(self, level, display)
end

function MyGameLevelState:handleMessage(message)
   spectrum.LevelState.handleMessage(self, message)

   -- we'd handle custom messages from the level here, this will get covered
   -- in the tutorial, custom messages might tell the state it's time to descend
   -- and we'd spin up a new levelstate here, or it might say the player died and
   -- the game is over and we'd push a game over state.
end

function MyGameLevelState:_draw(curActor, primary, secondary)
   -- set the camera to follow the player, you can disable this by commenting these
   -- lines out
   local x, y = self.display:getCenterOffset(curActor:getPosition():decompose())
   self.display:setCamera(x, y)

   -- The terminal has a simple method to take a set of primary and secondary senses components
   -- which the parent of this prototype conviently builds for you.
   -- This paints the level from the perspective of the 
   self.display:putSenses(primary, secondary)

   -- draw ui and stuff on the terminal
   -- this is where you'd draw your status stuff like hp and monster hps
   self.display:putString(1, 1, "Hello prism!")
end

-- we map our actions from our keybinding schemas to movement direction
-- vectors that well hand off to the move actor
local keybindOffsets = {
   ["move up"] = prism.Vector2.UP,
   ["move left"] = prism.Vector2.LEFT,
   ["move down"] = prism.Vector2.DOWN,
   ["move right"] = prism.Vector2.RIGHT,
   ["move up-left"] = prism.Vector2.UP_LEFT,
   ["move up-right"] = prism.Vector2.UP_RIGHT,
   ["move down-left"] = prism.Vector2.DOWN_LEFT,
   ["move down-right"] = prism.Vector2.DOWN_RIGHT,
   ["wait"] = prism.Vector2.ZERO
}


-- Everything below this you should think of as if it's the PlayerController's act method,
-- like the controller for the Kobold in the tutorial, but for the player.
-- Do NOT mutate Level from here! Your goal is to find a valid action and
-- set it in the decision!
function MyGameLevelState:keypressed(key, scancode)
   spectrum.LevelState.keypressed(self, key, scancode)

   local decision = self.decision
   ---@cast decision ActionDecision

   local action = keybindings:keypressed(key)

   if keybindOffsets[action] then
      local owner = self.decision.actor
      local destination = owner:getPosition() + keybindOffsets[action]

      local move = prism.actions.Move(owner,  { destination })
      if move:canPerform(self.level) then
         decision:setAction(move)
         return
      end
   end
end

function MyGameLevelState:mousepressed(x, y, button, istouch, presses)
   -- add functionality!
end

return MyGameLevelState
