---@class Wait : Action
local Wait = prism.Action:extend("Wait")

function Wait:_canPerform()
  return true
end

function Wait:_perform(level)
end

return Wait

