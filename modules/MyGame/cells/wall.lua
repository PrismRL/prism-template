--- @class WallCell : Cell
local Wall = prism.Cell:extend("WallCell")
Wall.name = "Wall" -- displayed in the user interface

function Wall:initialize()
  return {
    prism.components.Drawable(string.byte("#") + 1),
    prism.components.Collider(),
    prism.components.Opaque()
  }
end

return Wall
