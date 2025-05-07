require "debugger"
require "prism"

prism.loadModule("prism/spectrum")
prism.loadModule("modules/Sight")
prism.loadModule("modules/MyGame")

-- Map Generation

-- build a basic test map
local mapbuilder = prism.MapBuilder(prism.cells.Wall)
mapbuilder:drawRectangle(0, 0, 32, 32, prism.cells.Wall)
mapbuilder:drawRectangle(1, 1, 31, 31, prism.cells.Floor)
mapbuilder:drawRectangle(5, 5, 7, 7, prism.cells.Wall)
mapbuilder:drawRectangle(20, 20, 25, 25, prism.cells.Pit)

-- create and add the player
mapbuilder:addActor(prism.actors.Player(), 12, 12)

-- Grab our level state and sprite atlas.
local MyGameLevelState = require "gamestates.MyGamelevelstate"

-- State Management

-- spin up our state machine
--- @type GameStateManager
local manager = spectrum.StateManager()

-- we put out levelstate on top here, but you could create a main menu
--- @diagnostic disable-next-line
function love.load()
   manager:push(MyGameLevelState(mapbuilder))
   manager:hook()
end
