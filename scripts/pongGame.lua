local collision = require "lib.collision"

local pongGame = {}

--Functions
local function lineStipple( x1, y1, x2, y2, dash, gap )
    local dash = dash or 10
    local gap  = dash + (gap or 10)

    local steep = math.abs(y2-y1) > math.abs(x2-x1)
    if steep then
        x1, y1 = y1, x1
        x2, y2 = y2, x2
    end
    if x1 > x2 then
        x1, x2 = x2, x1
        y1, y2 = y2, y1
    end

    local dx = x2 - x1
    local dy = math.abs( y2 - y1 )
    local err = dx / 2
    local ystep = (y1 < y2) and 1 or -1
    local y = y1
    local maxX = x2
    local pixelCount = 0
    local isDash = true
    local lastA, lastB, a, b

    for x = x1, maxX do
        pixelCount = pixelCount + 1
        if (isDash and pixelCount == dash) or (not isDash and pixelCount == gap) then
            pixelCount = 0
            isDash = not isDash
            a = steep and y or x
            b = steep and x or y
            if lastA then
                love.graphics.line( lastA, lastB, a, b )
                lastA = nil
                lastB = nil
            else
                lastA = a
                lastB = b
            end
        end

        err = err - dy
        if err < 0 then
            y = y + ystep
            err = err + dx
        end
    end
end

function pongGame:paddleControls(delta)
    --P1 paddle controls
    local axis = InputManager.gamepads[1]:getAxis(2)
    if math.abs(axis) < 0.1 then axis = 0 end
    self.paddles[1][2] = self.paddles[1][2] + axis*120*delta
    --P1 paddle controls
    axis = InputManager.gamepads[2]:getAxis(2)
    if math.abs(axis) < 0.1 then axis = 0 end
    self.paddles[2][2] = self.paddles[2][2] + axis*120*delta
    --Paddle borders
    for i = 1, 2 do
        if self.paddles[i][2]-self.paddles[i][3]/2 < 10 then
            self.paddles[i][2] = 10+self.paddles[i][3]/2
        end
        if self.paddles[i][2]+self.paddles[i][3]/2 > 530 then
            self.paddles[i][2] = 530-self.paddles[i][3]/2
        end
    end
    --Slowly shrink paddles
    for i = 1, 2 do
        self.paddles[i][3] = self.paddles[i][3] - 2 * delta
        if self.paddles[i][3] < 95 then self.paddles[i][3] = 95 end
    end
end

function pongGame:ballMovement(delta)
    --Increase speed
    self.ball.speed = self.ball.speed + 4 * delta
    --Normalize velocity
    local vel = {self.ball.velocity[1], self.ball.velocity[2]}
    if math.abs(vel[1]) == math.abs(vel[2]) then
        vel[1] = vel[1]/1.25
        vel[2] = vel[2]/1.25
    end
    --Move by velocity
    self.ball.position[1] = self.ball.position[1] + self.ball.speed*vel[1] * delta
    self.ball.position[2] = self.ball.position[2] + self.ball.speed*vel[2] * delta
    --Collision with up and bottom edges
    if self.ball.position[2]-10 < 5 then
        self.ball.velocity[2] = -self.ball.velocity[2]
        self.ball.position[2] = 15
    end
    if self.ball.position[2]+10 > 535 then
        self.ball.velocity[2] = -self.ball.velocity[2]
        self.ball.position[2] = 525
    end
    --Collision with paddles
    for i = 1, 2 do
        local p1 = self.ball.position ; local p2 = self.paddles[i]
        local w1, h1 = 20, 20
        local w2, h2 = 10, self.paddles[i][3]
        if collision(p1[1]-w1/2, p1[2]-h1/2, w1, h1, p2[1]-w2/2, p2[2]-h2/2, w2, h2) then
            self.ball.velocity[1] = -self.ball.velocity[1]
        end
    end
    --Scoring mechanic:
    --P1 side
    if self.ball.position[1] < 0 then
        self.scores[2] = self.scores[2] + 1
        self.ball.position = {480, 270}
        self.ball.velocity = {-1+math.random(0, 1)*2, -1+math.random(0, 1)*2}
        self.startTimer = 0
        self.paddles = {{15, 270, 160}, {945, 270, 160}}
        self.ball.speed = 200
        --Check for win
        if self.scores[2] > 2 then
            self.gameComplete = true
            Scores[2] = Scores[2] + 1
        end
    end
    --P2 side
    if self.ball.position[1] > 960 then
        self.scores[1] = self.scores[1] + 1
        self.ball.position = {480, 270}
        self.ball.velocity = {-1+math.random(0, 1)*2, -1+math.random(0, 1)*2}
        self.startTimer = 0
        self.paddles = {{15, 270, 160}, {945, 270, 160}}
        self.ball.speed = 200
        --Check for win
        if self.scores[1] > 2 then
            self.gameComplete = true
            Scores[1] = Scores[1] + 1
        end
    end
end

--Main functions
function pongGame:load()
    self.paddles = {
        {15, 270, 160}, {945, 270, 160}
    }
    self.ball = {
        position = {480, 270};
        velocity = {-1+math.random(0, 1)*2, -1+math.random(0, 1)*2};
        speed = 200;
        image = love.graphics.newImage("images/ball.png");
    }
    self.startTimer = 0
    self.scores = {0, 0}
    self.gameComplete = false
end

function pongGame:update(delta)
    self.startTimer = self.startTimer + delta
    --Game over stuff
    if self.gameComplete and self.startTimer > 2.5 then
        GameState = "gameIntro2"
        Interface.introCountDown = 5
    end
    --Game funcs
    if self.startTimer < 2 or self.gameComplete then return end
    self:paddleControls(delta)
    self:ballMovement(delta)
end

function pongGame:draw()
    --Draw screen divider lines
    love.graphics.setColor(0.6, 0.6, 0.6, 1)
    love.graphics.setLineWidth(5)
    lineStipple(480, -14, 480, 547, 15, 7)
    --Draw paddles:
    love.graphics.setColor(0.1, 0.1, 0.1, 1)
    --P1
    love.graphics.rectangle(
        "fill", self.paddles[1][1]-5, self.paddles[1][2]-self.paddles[1][3]/2, 10, self.paddles[2][3]
    )
    --P2
    love.graphics.rectangle(
        "fill", self.paddles[2][1]-5, self.paddles[2][2]-self.paddles[2][3]/2, 10, self.paddles[2][3]
    )
    --Draw ball
    love.graphics.draw(
        self.ball.image, self.ball.position[1], self.ball.position[2], 0, 2, 2, 5, 5
    )
    --Draw score bg
    love.graphics.setColor(0.2, 0.2, 0.2, 0.5)
    love.graphics.rectangle("fill", 430, 490, 100, 50)
    --Draw score text
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    love.graphics.setFont(Interface.assets.fontMedium)
    love.graphics.print(
        self.scores[1] .. "   " .. self.scores[2], 450, 500
    )
    --Game complete text
    if not self.gameComplete then return end
    local text
    if self.scores[1] > 2 then
        text = "PLAYER 1 WINS!"
        love.graphics.setColor(0, 0, 0.8, 1)
    else
        text = "PLAYER 2 WINS!"
        love.graphics.setColor(0.8, 0, 0, 1)
    end
    love.graphics.setFont(Interface.assets.fontLarge)
    love.graphics.printf(
        text, -19, 300, 1000, "center"
    )
end

return pongGame