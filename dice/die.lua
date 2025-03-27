--- @class Die : Object
--- @field sides integer
--- @field result integer|nil
local Die = prism.Object:extend "Die"

function Die:__new(sides)
   self.sides = sides
end

---@param rng RNG
function Die:roll(rng)
   self.result = rng:getUniformInt(1, self.sides)
end

return Die