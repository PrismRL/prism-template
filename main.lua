if os.getenv("LOCAL_LUA_DEBUGGER_VSCODE") == "1" then
   require("lldebugger").start()
end

if os.getenv "LOCAL_LUA_DEBUGGER_VSCODE" == "1" then
   local lldebugger = require "lldebugger"
   lldebugger.start()
   local run = love.run
   function love.run(...)
       local f = lldebugger.call(run, false, ...)
       return function(...) return lldebugger.call(f, false, ...) end
   end
end

require "prism"

prism.loadModule("prism/spectrum")
prism.loadModule("modules/Sight")
prism.loadModule("modules/MyGame")

-- build a basic test map
local mapbuilder = prism.MapBuilder(prism.cells.Wall())
mapbuilder:drawRectangle(0, 0, 32, 32, prism.cells.Wall())
mapbuilder:drawRectangle(1, 1, 31, 31, prism.cells.Floor())
mapbuilder:drawRectangle(5, 5, 7, 7, prism.cells.Wall())
mapbuilder:drawRectangle(20, 20, 25, 25, prism.cells.Pit())

-- create and add the player
mapbuilder:addActor(prism.actors.Player(), 12, 12)

-- bake the map down
local map, actors = mapbuilder:build()

-- initialize the level
local sensesSystem = prism.systems.Senses()
local sightSystem = prism.systems.Sight()
local level = prism.Level(map, actors, { sensesSystem, sightSystem })

-- spin up our state machine
local manager = spectrum.StateManager()

-- Grab our level state and sprite atlas.
local MyGameLevelState = require "gamestates.MyGamelevelstate"
love.graphics.setDefaultFilter("nearest", "nearest")
local spriteAtlas = spectrum.SpriteAtlas.fromGrid("display/wanderlust_16x16.png", 16, 16)

-- we put out levelstate on top here, but you could create a main menu
function love.load()
   manager:push(MyGameLevelState(level, spectrum.Display(spriteAtlas, prism.Vector2(16, 16), level)))
end

-- passing love events to our statemachine
function love.draw()
   manager:draw()
end

function love.update(dt)
   manager:update(dt)
end

function love.keypressed(key, scancode)
   manager:keypressed(key, scancode)
end

function love.textinput(text)
   manager:textinput(text)
end

function love.mousepressed(x, y, button, istouch, presses)
   manager:mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button)
   manager:mousereleased(x, y, button)
end

function love.mousemoved(x, y, dx, dy, istouch)
   manager:mousemoved(x, y, dx, dy, istouch)
end

function love.wheelmoved(x, y)
   manager:wheelmoved(x, y)
end

