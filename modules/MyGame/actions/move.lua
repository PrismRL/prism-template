local MoveTarget = prism.Target()
   :isPrototype(prism.Vector2)
   :range(1)

---@class Move : Action
---@field name string
---@field targets Target[]
---@field previousPosition Vector2
local Move = prism.Action:extend("Move")
Move.name = "move"
Move.targets = { MoveTarget }

Move.requiredComponents = {
   prism.components.Controller,
   prism.components.Mover
}

--- @param level Level
--- @param destination Vector2
function Move:canPerform(level, destination)
   local mover = self.owner:expect(prism.components.Mover)
   return level:getCellPassableByActor(destination.x, destination.y, self.owner, mover.mask)
end

--- @param level Level
--- @param destination Vector2
function Move:perform(level, destination)
   level:moveActor(self.owner, destination)
end

return Move
