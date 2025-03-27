-- Set up our turn logic.
local keybindings = require "keybindingschema"

--- @class MyGameLevelState : LevelState
--- @field path Path
--- @field level Level
local MyGameLevelState = spectrum.LevelState:extend "MyGameLevelState"

function MyGameLevelState:__new(level, display, actionHandlers)
   spectrum.LevelState.__new(self, level, display, actionHandlers)
end

function MyGameLevelState:updateDecision(dt, actor, decision)
end

function MyGameLevelState:drawBeforeCells(display)
   -- add functionality!
end

local keybindOffsets = {
   ["move up"] = prism.Vector2(0, -1),
   ["move left"] = prism.Vector2(-1, 0),
   ["move down"] = prism.Vector2(0, 1),
   ["move right"] = prism.Vector2(1, 0),
   ["move up-left"] = prism.Vector2(-1, -1),
   ["move up-right"] = prism.Vector2(1, -1),
   ["move down-left"] = prism.Vector2(-1, 1),
   ["move down-right"] = prism.Vector2(1, 1),
   ["wait"] = prism.Vector2(0, 0),
}

function MyGameLevelState:keypressed(key, scancode)
   if not self.decision or not self.decision:is(prism.decisions.ActionDecision) then
      return
   end

   local action = keybindings:keypressed(key)
   
   if keybindOffsets[action] then
      local owner = self.decision.actor
      local move = prism.actions.Move(owner, {owner:getPosition() + keybindOffsets[action]})
      if move:canPerform(self.level) then
         self.decision:setAction(move)
      end
   end
end


function MyGameLevelState:mousepressed(x, y, button, istouch, presses)
   -- add functionality!
end

return MyGameLevelState
