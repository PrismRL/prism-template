local PathfindBehavior = require "example_srd.behaviors.pathfind"

--- @class BanditBehavior : BTRoot
local BanditBehavior = prism.BehaviorTree.Root:extend "BanditBehavior"

BanditBehavior.children = {
   prism.BehaviorTree.Sequence {
      prism.BehaviorTree.Node(function(_, level, actor, controller)
         local senses = actor:getComponent(prism.components.Senses)
         local stats = actor:getComponent(prism.components.SRDStats)

         if not stats or not senses then return false end

         local candidate
         local candidateDistance = math.huge
         for sensedActor in senses.actors:eachActor() do
            if actor ~= sensedActor then
               local range = actor:getRange(prism._defaultDistance, sensedActor)
               if range < candidateDistance then
                  candidate = sensedActor
                  candidateDistance = range
               end
            end
         end

         if candidate then
            controller.blackboard.meleeTarget = candidate
            return true
         end

         return false
      end),
      PathfindBehavior(function(_, _, controller) return controller.blackboard.meleeTarget:getPosition() end, 1),
      prism.BehaviorTree.Node(function(_, level, actor, controller)
         local stats = actor:getComponent(prism.components.SRDStats)
         if not stats then return false end

         local weapon = stats.attacks:get(1)

         local attackInstance = prism.actions.Attack(actor, {weapon, controller.blackboard.meleeTarget})
         return attackInstance:canPerform(level) and attackInstance or false
      end)
   },
   prism.BehaviorTree.Node(function ()
      return prism.actions.EndTurn()
   end)
}

return BanditBehavior