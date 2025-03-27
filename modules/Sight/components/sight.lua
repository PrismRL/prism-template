--- @class SightComponent : Component
--- @field range integer How many tiles can this actor see?
--- @field fov boolean
local Sight = prism.Component:extend( "SightComponent" )
Sight.name = "Sight"
Sight.requirements = { prism.components.Senses }

--- @param options {range: integer, fov: boolean}
function Sight:__new(options)
   self.range = options.range
   self.fov = options.fov
end

return Sight
