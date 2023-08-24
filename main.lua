--Import scripts
local menuParticles = require "scripts.menuParticles"

--Functions
function math.uniform(a,b)
	return a + (math.random()*(b-a))
end

--Love functions
function love.load()
    --Set background color
    love.graphics.setBackgroundColor(0.85, 0.85, 0.85)
end

function love.update(delta)
    menuParticles:update(delta)
end

function love.draw()
    -- Game canvas
    love.graphics.push()
        menuParticles:draw()
    love.graphics.pop()
end
