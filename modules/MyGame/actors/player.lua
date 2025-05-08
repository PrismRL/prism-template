--- @class Player : Actor
local Player = prism.Actor:extend "PlayerActor"

function Player:initialize()
   return {
      prism.components.Drawable(string.byte("@") + 1, prism.Color4.GREEN, prism.Color4.BLACK),
      prism.components.Collider(),
      prism.components.PlayerController(),
      prism.components.Senses(),
      prism.components.Sight { range = 64, fov = true },
      prism.components.Mover{ "walk" }
   }
end

return Player
