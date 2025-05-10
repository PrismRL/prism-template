---@class Floor : Cell
local Floor = prism.Cell:extend("Floor")

function Floor:initialize()
  return {
    prism.components.Drawable("."),
    prism.components.Collider({ allowedMovetypes = { "walk", "fly" }})
  }
end

return Floor
