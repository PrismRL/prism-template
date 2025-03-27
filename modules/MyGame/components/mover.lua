--- @class MoverComponent : Component
--- @field range integer How many tiles can this actor see?
--- @field fov boolean
local Mover = prism.Component:extend( "MoverComponent" )
Mover.name = "Mover"

--- @param movetypes string[]
function Mover:__new(movetypes)
   self.mask = prism.Collision.createBitmaskFromMovetypes(movetypes)
end

return Mover
