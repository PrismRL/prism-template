---@class PathfindNode : BTNode
---@field destinationDistance integer The distance from the goal we should stop pathfinding.
---@field destinationFunc fun(level: Level, actor: Actor, controller: ControllerComponent): Vector2
local PathfindNode = prism.BehaviorTree.Node:extend("PathfindNode")

---@param destinationFunc fun(level: Level, actor: Actor, controller: ControllerComponent): Vector2
---@param destinationDist integer
function PathfindNode:__new(destinationFunc, destinationDist)
   self.destinationFunc = destinationFunc
   self.destinationDistance = destinationDist or math.huge
end

function PathfindNode:run(level, actor, controller)
   local destination = self.destinationFunc(level, actor, controller)

   if actor:getRangeVec(prism._defaultDistance, destination) <= self.destinationDistance then return true end

   local stats = actor:getComponent(prism.components.SRDStats)
   if not stats then return false end
   
   local path = level:findPath(actor:getPosition(), destination, self.destinationDistance, stats.mask)
   if not path then return false end

   local nextCell = path:pop()
   local moveAction = prism.actions.Move(actor, { nextCell })
   return moveAction:canPerform(level) and moveAction or false
end

return PathfindNode