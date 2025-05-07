require "debugger"
require "prism"

prism.loadModule("prism/spectrum")
prism.loadModule("modules/Sight")
prism.loadModule("modules/MyGame")

-- Level Generation

-- build a basic test map
local mapbuilder = prism.MapBuilder(prism.cells.Wall)
mapbuilder:drawRectangle(0, 0, 32, 32, prism.cells.Wall)
mapbuilder:drawRectangle(1, 1, 31, 31, prism.cells.Floor)
mapbuilder:drawRectangle(5, 5, 7, 7, prism.cells.Wall)
mapbuilder:drawRectangle(20, 20, 25, 25, prism.cells.Pit)

-- create and add the player
mapbuilder:addActor(prism.actors.Player(), 12, 12)

-- bake the map down from the sparse structure of mapbuilder into a
-- sized Map object
local map, actors = mapbuilder:build()

-- initialize the level
local sensesSystem = prism.systems.Senses()
local sightSystem = prism.systems.Sight()
local level = prism.Level(map, actors, { sensesSystem, sightSystem })

-- Set up the display

-- Grab our level state and sprite atlas.
local MyGameLevelState = require "gamestates.MyGamelevelstate"
love.graphics.setDefaultFilter("nearest", "nearest")
local spriteAtlas = spectrum.SpriteAtlas.fromGrid("display/wanderlust_16x16.png", 16, 16)
local display = spectrum.Display(spriteAtlas, prism.Vector2(16, 16), level)

-- State Management

-- spin up our state machine
--- @type GameStateManager
local manager = spectrum.StateManager()

-- we put out levelstate on top here, but you could create a main menu
--- @diagnostic disable-next-line
function love.load()
   manager:push(MyGameLevelState(level, display))
   manager:hook()
end
