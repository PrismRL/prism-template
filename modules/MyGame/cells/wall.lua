--- @class Wall : Cell
local Wall = prism.Cell:extend("Wall")

function Wall:initialize()
  return {
    prism.components.Drawable(string.byte("#") + 1),
    prism.components.Collider(),
    prism.components.Opaque()
  }
end

return Wall
