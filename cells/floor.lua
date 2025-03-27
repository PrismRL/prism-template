---@class FloorCell : Cell
local Floor = prism.Cell:extend("FloorCell")
Floor.name = "Floor"
Floor.passable = true
Floor.opaque = false
Floor.drawable = prism.components.Drawable(string.byte(".") + 1)
Floor.allowedMovetypes = { "walk" }

return Floor
