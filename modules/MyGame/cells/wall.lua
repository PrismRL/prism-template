--- @class Wall : Cell
local Wall = prism.Cell:extend("Wall")

function Wall:initialize()
  return {
    prism.components.Drawable("#"),
    prism.components.Collider(),
    prism.components.Opaque()
  }
end

return Wall
