--- @class MoverComponent : Component
--- @field mask Bitmask
local Mover = prism.Component:extend( "MoverComponent" )
Mover.name = "Mover"

--- @param movetypes string[]
function Mover:__new(movetypes)
   self.mask = prism.Collision.createBitmaskFromMovetypes(movetypes)
end

return Mover
