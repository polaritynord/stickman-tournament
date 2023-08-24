--Import scripts
local menuParticles = require "scripts.menuParticles"
Interface = require "scripts.interface"
JoystickManager = require "scripts.joystickManager"

--Functions
function math.uniform(a,b)
	return a + (math.random()*(b-a))
end

--Love functions
function love.load()
    love.graphics.setBackgroundColor(0.85, 0.85, 0.85)
    love.graphics.setDefaultFilter("nearest", "nearest")
    --Load function for scripts
    Interface:load()
    JoystickManager:load()
    --Global variables
    GameState = "menu"
    GamePaused = true
    GameCamera = {0, 0, 1}
    MenuCamera = {0, 0, 1}
end

function love.update(delta)
    JoystickManager:update()
    menuParticles:update(delta)
    Interface:update(delta)
end

function love.draw()
    local w, h = love.graphics.getDimensions()
    love.graphics.scale(w/960, h/540)
    -- Game canvas
    love.graphics.translate(GameCamera[1], GameCamera[2])
    menuParticles:draw()
    --Menu canvas
    Interface:draw()
end
