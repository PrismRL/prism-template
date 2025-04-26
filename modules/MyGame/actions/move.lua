local PointTarget = prism.Target:extend("PointTarget")

--- @param owner Actor
--- @param targetObject any
function PointTarget:validate(owner, targetObject)
   return 
      targetObject:is(prism.Vector2) and
      owner:getRangeVec("8way", targetObject) == 1
end

---@class MoveAction : Action
---@field name string
---@field targets Target[]
---@field previousPosition Vector2
local Move = prism.Action:extend("MoveAction")
Move.name = "move"
Move.targets = { PointTarget }
Move.requiredComponents = {
   prism.components.Controller,
   prism.components.Mover,
}

--- @param level Level
--- @param destination Vector2
function Move:_canPerform(level, destination)
   local mover = self.owner:expectComponent(prism.components.Mover)
   return level:getCellPassable(destination.x, destination.y, mover.mask)
 end

--- @param level Level
--- @param destination Vector2
function Move:_perform(level, destination)
   level:moveActor(self.owner, destination)
end

return Move
