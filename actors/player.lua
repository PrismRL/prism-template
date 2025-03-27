--- @type AttackData
local AttackData = require "example_srd.attackdata"

--- @type DiceData
local DiceData = require "example_srd.dice.dice"

--- @class PlayerActor : Actor
local Player = prism.Actor:extend("PlayerActor")
Player.name = "Player"

function Player:initialize()
   return {
      prism.components.Drawable(string.byte("@") + 1, prism.Color4(0, 1, 0, 1)),
      prism.components.Collider(),
      prism.components.PlayerController(),
      prism.components.Senses(),
      prism.components.Sight { range = 64, fov = true },

      --- Stat Block
      prism.components.SRDStats {
         movePoints = 6,
         moveTypes = {"walk"},
         stats = {
            STR = 10,
            DEX = 10,
            CON = 10,
            WIS = 10,
            CHA = 10,
            INT = 10
         },
         attacks = {
            AttackData {
               name = "Unarmed Strike",
               damage = { 
                  dice = 1, type = "bludgeoning"
               },
               range = 1,
               properties = { unarmed = true },
               bonus = 0,
            },
         },
      }
   }
end

return Player
