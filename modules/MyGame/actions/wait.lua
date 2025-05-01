---@class WaitAction : Action
local Wait = prism.Action:extend("WaitAction")
Wait.name = "Wait"

function Wait:_canPerform()
  return true
end

function Wait:_perform(level)
end

return Wait

