---@class PitCell : Cell
local Pit = prism.Cell:extend("PitCell")
Pit.name = "Pit"

function Pit:initialize()
  return {
    prism.components.Drawable(string.byte(" ") + 1),
    prism.components.Collider({ allowedMovetypes = { "fly" }})
  }
end

return Pit
