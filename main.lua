--Import scripts
local menuParticles = require "scripts.menuParticles"
Interface = require "scripts.interface"
InputManager = require "scripts.inputManager"

--Variables
local fullscreen = false

--Functions
function math.uniform(a,b)
	return a + (math.random()*(b-a))
end

--Love functions
function love.keypressed(key)
    -- Fullscreen key
    if key == "f11" then
        fullscreen = not fullscreen
        love.window.setFullscreen(fullscreen, "desktop")
        -- Set window dimensions to default
        if not fullscreen and false then
            love.window.setMode(960, 540, {resizable=true})
        end
    end
    -- Toggle debug menu
    if key == "f1" and GameState == "game" then
        Interface.debug.enabled = not Interface.debug.enabled
    end
end

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    --Load function for scripts
    Interface:load()
    InputManager:load()
    --Global variables
    GameState = "menu"
    GamePaused = true
    GameCamera = {0, 0, 1}
    MenuCamera = {0, 0, 1}
end

function love.update(delta)
    InputManager:update()
    Interface:update(delta)
    --Main menu
    if GameState == "menu" then
        menuParticles:update(delta)
    end
end

function love.draw()
    local w, h = love.graphics.getDimensions()
    love.graphics.scale(w/960, h/540)
    --Set background color
    if GameState == "menu" then
        love.graphics.setBackgroundColor(0.85*Interface.menuAlpha, 0.85*Interface.menuAlpha, 0.85*Interface.menuAlpha)
    else
    end
    --Game canvas
    love.graphics.translate(GameCamera[1], GameCamera[2])
    if GameState == "menu" then
        menuParticles:draw()
    end
    --Menu canvas
    Interface:draw()
end
