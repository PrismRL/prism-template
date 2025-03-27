local Die = require "example_srd.dice.die"

--- @class DiceRoll : Object
--- @field dice [Die]
local DiceRoll = prism.Object:extend "DiceRoll"

function DiceRoll:__new(count, sides)
   assert(count >= 1, "Count must be greater than zero!")
   assert(sides >= 1, "Sides must be greater than zero!")
   self.dice = {}
   for i = 1, count do
      table.insert(self.dice, Die(sides))
   end
end

function DiceRoll:roll(rng)
   for _, die in ipairs(self.dice) do
      die:roll(rng)
   end
end

return DiceRoll