local DiceRoll = require "example_srd.dice.diceroll"

--- A data object that describes a dice roll of uni-sided dice, like 2d4 or 3d8 or 4d100.
---@class DiceData : Object
---@field count integer
---@field sides integer
local DiceData = prism.Object:extend "Dice"

function DiceData:__new(count, sides)
   self.count = count
   self.sides = sides
end

--- Generate a dice roll from this dice data.
---@return DiceRoll roll A diceroll object holding individual Die objects.
function DiceData:roll(rng)
   local roll = DiceRoll(self.count, self.sides)
   roll:roll(rng)

   return roll
end

return DiceData