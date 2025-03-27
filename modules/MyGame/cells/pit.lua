---@class PitCell : Cell
local Pit = prism.Cell:extend("PitCell")
Pit.name = "Pit"
Pit.passable = true
Pit.opaque = false
Pit.drawable = prism.components.Drawable(string.byte(" ") + 1)
Pit.allowedMovetypes = { "fly" }

return Pit
