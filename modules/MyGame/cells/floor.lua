---@class FloorCell : Cell
local Floor = prism.Cell:extend("FloorCell")
Floor.name = "Floor"

function Floor:initialize()
  return {
    prism.components.Drawable(string.byte(".") + 1),
    prism.components.Collider({ allowedMovetypes = { "walk", "fly" }})
  }
end

return Floor
