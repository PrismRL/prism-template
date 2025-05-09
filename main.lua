require "debugger"
require "prism"

prism.loadModule("prism/spectrum")
prism.loadModule("modules/Sight")
prism.loadModule("modules/MyGame")

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
