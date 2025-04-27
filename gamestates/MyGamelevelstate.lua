local keybindings = require "keybindingschema"

--- @class MyGameLevelState : LevelState
--- @field path Path
--- @field level Level
local MyGameLevelState = spectrum.LevelState:extend "MyGameLevelState"

function MyGameLevelState:__new(level, display, actionHandlers)
   spectrum.LevelState.__new(self, level, display, actionHandlers)
end

function MyGameLevelState:update(dt)
   spectrum.LevelState.update(self, dt)

   if not self.decision or not self.decision.actor then
      return
   end

   local cellSize = self.display.cellSize
   local ax, ay = self.decision.actor:getPosition():decompose()
   self.display.camera.scale = prism.Vector2(1, 1)
   self.display.camera:centerOn(ax * cellSize.x, ay * cellSize.y)
end

function MyGameLevelState:drawBeforeCells(display)
   -- add functionality!
end

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

function MyGameLevelState:keypressed(key, scancode)
   if key == "`" then
      self.manager:push(self.geometer)
   end

   if not self.decision or not self.decision:is(prism.decisions.ActionDecision) then
      return
   end

   local decision = self.decision
   ---@cast decision ActionDecision

   local action = keybindings:keypressed(key)

   if keybindOffsets[action] then
      local owner = self.decision.actor
      local destination = owner:getPosition() + keybindOffsets[action]

      local move = prism.actions.Move(owner, { destination })
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
