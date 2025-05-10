--- @class Sight : Component
--- @field range integer How many tiles can this actor see?
--- @field fov boolean
local Sight = prism.Component:extend("Sight")
Sight.requirements = { "Senses" }

function Sight:getRequirements()
   return prism.components.Senses
end

--- @param options {range: integer, fov: boolean}
function Sight:__new(options)
   self.range = options.range
   self.fov = options.fov
end

return Sight
