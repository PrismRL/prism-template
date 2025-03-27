local BanditBehavior = require "example_srd.behaviors.bandit"

--- @class BanditControllerComponent : ControllerComponent
--- @field root BTRoot
--- @field blackboard table<string, any>
local BanditController = prism.components.Controller:extend("BanditControllerComponent")

function BanditController:__new()
   self.root = BanditBehavior
end

---@param level Level
---@param actor Actor
function BanditController:act(level, actor)
   self.blackboard = {}
   return self.root:run(level, actor, self)
end

return BanditController
