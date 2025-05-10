--- @class Thing : Component
--- @field mask Bitmask
local Thing = prism.Component:extend("Thing")

function Thing:getRequirements()
   return prism.components.Mover
end

--- @param movetypes string[]
function Thing:__new(movetypes)
   self.mask = prism.Collision.createBitmaskFromMovetypes(movetypes)
end

return Thing
