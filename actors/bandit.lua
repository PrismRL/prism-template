--- @type AttackData
local AttackData = require "example_srd.attackdata"
---@type DiceData
local DiceData = require "example_srd.dice.dice"

--- @class BanditActor : Actor
local Bandit = prism.Actor:extend("BanditActor")
Bandit.name = "Bandit"

function Bandit:initialize()
   return {
      prism.components.Drawable(string.byte("b") + 1),
      prism.components.Collider(),
      prism.components.BanditController(),
      prism.components.Senses(),
      prism.components.Sight { range = 64, fov = true },
      prism.components.SRDStats {
         movePoints = 6,
         moveTypes = { "walk" },
         stats = {
            STR = 11,
            DEX = 12,
            CON = 12,
            WIS = 10,
            CHA = 10,
            INT = 10
         },
         attacks = {
            AttackData {
               name = "Scimitar",
               damage = {
                  {dice = DiceData(1, 6), type = "bludgeoning"}
               },
               range = 1,
               properties = { finesse = true },
               staticToHit = 3,
            },
            AttackData {
               name = "Light Crossbow",
               damage = {
                  {dice = DiceData(1, 8), type = "piercing"}
               },
               range = {short = 16, long = 64},
               properties = { ranged = true },
               staticToHit = 3,
            },
         },
      }
   }
end

return Bandit
