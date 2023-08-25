local pongGame = {
    paddles = {
        {10, 270, 160}, {940, 270, 160}
    }
}

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

function pongGame:update(delta)
    --P1 paddle controls
    local axis = InputManager.gamepads[1]:getAxis(2)
    if math.abs(axis) < 0.1 then axis = 0 end
    self.paddles[1][2] = self.paddles[1][2] + axis*120*delta
    --P1 paddle controls
    axis = InputManager.gamepads[2]:getAxis(2)
    if math.abs(axis) < 0.1 then axis = 0 end
    self.paddles[2][2] = self.paddles[2][2] + axis*120*delta
    --P1 paddle borders
    if self.paddles[1][2]-self.paddles[1][3]/2 < 10 then
        self.paddles[1][2] = 10+self.paddles[1][3]/2
    end
    if self.paddles[1][2]+self.paddles[1][3]/2 > 530 then
        self.paddles[1][2] = 530-self.paddles[1][3]/2
    end
    --P2 paddle borders
    if self.paddles[2][2]-self.paddles[2][3]/2 < 10 then
        self.paddles[2][2] = 10+self.paddles[2][3]/2
    end
    if self.paddles[2][2]+self.paddles[2][3]/2 > 530 then
        self.paddles[2][2] = 530-self.paddles[2][3]/2
    end
end

function pongGame:draw()
    --Draw screen divider lines
    love.graphics.setColor(0.1, 0.1, 0.1, 1)
    love.graphics.setLineWidth(5)
    lineStipple(480, -14, 480, 547, 15, 7)
    --Draw paddles:
    --P1
    love.graphics.rectangle(
        "fill", self.paddles[1][1], self.paddles[1][2]-self.paddles[1][3]/2, 10, self.paddles[2][3]
    )
    --P2
    love.graphics.rectangle(
        "fill", self.paddles[2][1], self.paddles[2][2]-self.paddles[2][3]/2, 10, self.paddles[2][3]
    )
end

return pongGame