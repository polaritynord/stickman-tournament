local fingerGame = {}

function fingerGame:load()
    self.dividePos = 480
    self.scores = {0, 0}
    self.clicking = {false, false}
    self.startTimer = 0
end

function fingerGame:update(delta)
    --Get click event
    for i = 1, 2 do
        if not self.clicking[i] and InputManager.gamepads[i]:isDown(1) then
            --Click
            if i == 1 then
                self.dividePos = self.dividePos + 30
            else
                self.dividePos = self.dividePos - 30
            end
        end
    end
    --Get button input
    for i = 1, 2 do
        self.clicking[i] = InputManager.gamepads[i]:isDown(1)
    end
end

function fingerGame:draw()
    --Draw sides:
    love.graphics.setLineWidth(24)
    --P1
    love.graphics.setColor(0, 0, 0.8, 1)
    love.graphics.rectangle("fill", 0, 0, self.dividePos, 540)
    --Border
    love.graphics.setColor(0, 0, 0.9, 1)
    love.graphics.line(self.dividePos-12, 0, self.dividePos-12, 540)
    --P2
    love.graphics.setColor(0.8, 0, 0.0, 1)
    love.graphics.rectangle("fill", self.dividePos, 0, 960, 540)
    --Border
    love.graphics.setColor(0.9, 0, 0, 1)
    love.graphics.line(self.dividePos+12, 0, self.dividePos+12, 540)

    --Draw score bg
    love.graphics.setColor(0.2, 0.2, 0.2, 0.5)
    love.graphics.rectangle("fill", 430, 490, 100, 50)
    --Draw score text
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    love.graphics.setFont(Interface.assets.fontMedium)
    love.graphics.print(
        self.scores[1] .. "   " .. self.scores[2], 450, 500
    )
end

return fingerGame