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
print "WTF"

prism.loadModule("prism/spectrum")
prism.loadModule("modules/MyGame")

local mapbuilder = prism.MapBuilder(prism.cells.Wall)
mapbuilder:drawRectangle(0, 0, 32, 32, prism.cells.Wall)
mapbuilder:drawRectangle(1, 1, 31, 31, prism.cells.Floor)
mapbuilder:drawRectangle(5, 5, 7, 7, prism.cells.Wall)
mapbuilder:drawRectangle(20, 20, 25, 25, prism.cells.Pit)

mapbuilder:addActor(prism.actors.Player(), 12, 12)
mapbuilder:addActor(prism.actors.Player(), 16, 16)
mapbuilder:addActor(prism.actors.Bandit(), 19, 19)

local map, actors = mapbuilder:build()

local sensesSystem = prism.systems.Senses()
local sightSystem = prism.systems.Sight()
local level = prism.Level(map, actors, { sensesSystem, sightSystem })

local TestGenerator = require "generators.test"
local manager = spectrum.StateManager()

local SRDLevelState = require "gamestates.srdlevelstate"
local spriteAtlas = spectrum.SpriteAtlas.fromGrid("example_srd/display/wanderlust_16x16.png", 16, 16)
local actionHandlers = require "display.actionhandlers"

function love.load()
   manager:push(SRDLevelState(level, spectrum.Display(spriteAtlas, prism.Vector2(16, 16), level), actionHandlers))
end

function love.draw()
   manager:draw()
end

function love.update(dt)
   print "YA!"
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

