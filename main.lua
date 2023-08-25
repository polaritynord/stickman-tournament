--Import scripts
local menuParticles = require "scripts.menuParticles"
PongGame = require "scripts.pongGame"
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
end

function love.load()
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.mouse.setVisible(false)
    --Load function for scripts
    Interface:load()
    InputManager:load()
    --Global variables
    GameState = "menu"
    GamePaused = true
    GameCamera = {0, 0, 1}
    MenuCamera = {0, 0, 1}
    Scores = {0, 0}
end

function love.update(delta)
    InputManager:update()
    Interface:update(delta)
    --Main menu
    if GameState == "menu" then
        menuParticles:update(delta)
    elseif GameState == "game1" then
        PongGame:update(delta)
    end
end

function love.draw()
    local w, h = love.graphics.getDimensions()
    love.graphics.scale(w/960, h/540)
    --Set background color
    if GameState == "menu" then
        love.graphics.setBackgroundColor(0.85*Interface.menuAlpha, 0.85*Interface.menuAlpha, 0.85*Interface.menuAlpha)
    elseif string.find(GameState, "gameIntro") then
        love.graphics.setBackgroundColor(0.85, 0.85, 0.85)
    end
    --Game canvas
    love.graphics.translate(GameCamera[1], GameCamera[2])
    if GameState == "menu" then
        menuParticles:draw()
    elseif GameState == "game1" then
        PongGame:draw()
    end
    --Menu canvas
    Interface:draw()
end
