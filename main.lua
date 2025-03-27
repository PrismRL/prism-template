require "spectrum"
require "geometer"

prism.loadModule("spectrum")
prism.loadModule("example_srd")
prism.loadModule("geometer")

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

local TestGenerator = require "example_srd.generators.test"
local manager = spectrum.StateManager()

local SRDLevelState = require "example_srd.gamestates.srdlevelstate"
local spriteAtlas = spectrum.SpriteAtlas.fromGrid("example_srd/display/wanderlust_16x16.png", 16, 16)
local actionHandlers = require "example_srd.display.actionhandlers"

function love.load()
   manager:push(SRDLevelState(level, spectrum.Display(spriteAtlas, prism.Vector2(16, 16), level), actionHandlers))
end

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

