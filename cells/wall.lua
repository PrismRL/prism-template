--- @class WallCell : Cell
local Wall = prism.Cell:extend("WallCell")

Wall.name = "Wall" -- displayed in the user interface
Wall.passable = false -- defines whether a cell is passable
Wall.opaque = true -- defines whether a cell can be seen through
Wall.drawable = prism.components.Drawable(string.byte("#") + 1)

return Wall
