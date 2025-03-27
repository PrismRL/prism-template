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
      prism.components.Mover{ "walk" }
   }
end

return Player
