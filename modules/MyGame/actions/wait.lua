---@class Wait : Action
local Wait = prism.Action:extend("Wait")

function Wait:canPerform()
   return true
end

function Wait:perform(level) end

return Wait
