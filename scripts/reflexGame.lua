local reflexGame = {}

function reflexGame:load()
    self.appearTime = math.uniform(4.5, 7.3)
    self.timer = 0
    self.clickTimes = {-1, -1}
    self.scores = {0, 0}
    self.done = false
    self.doneTime = 0
    self.gameComplete = true
end

function reflexGame:update(delta)
    --Increment timer
    self.timer = self.timer + delta
    if self.clickTimes[1] < 0 or self.clickTimes[2] < 0 then
        --Check for clicks:
        --P1
        if self.clickTimes[1] < 0 and InputManager.gamepads[1]:isDown(1) then
            self.clickTimes[1] = self.timer-self.appearTime
        end
        --P2
        if self.clickTimes[2] < 0 and InputManager.gamepads[2]:isDown(1) then
            self.clickTimes[2] = self.timer-self.appearTime
        end
    else
        if not self.done then
            --Compare and add point
            if self.clickTimes[1] < self.clickTimes[2] then
                --P1 score
                self.scores[1] = self.scores[1] + 1
            elseif self.clickTimes[1] > self.clickTimes[2] then
                --P2 score
                self.scores[2] = self.scores[2] + 1
            end --Draw, no points
            self.done = true
            self.doneTime = self.timer
        else
            --Reset game
            if self.timer > self.doneTime+2.5 then
                self.appearTime = math.uniform(4.5, 7.3)
                self.timer = 0
                self.clickTimes = {-1, -1}
                self.done = false
                self.doneTime = 0
            end
        end
    end
    --Game over check:
    --P1
    if self.scores[1] > 2 then
        Scores[1] = Scores[1] + 1
        self.gameComplete = true
    end
    --P2
    if self.scores[2] > 2 then
        Scores[2] = Scores[2] + 1
        self.gameComplete = true
    end
end

function reflexGame:draw()
    --Wait for it..
    love.graphics.setColor(0.65, 0.65, 0.65, 1)
    love.graphics.setFont(Interface.assets.fontLarge)
    love.graphics.printf(
        "Wait for it...", -19, 300, 1000, "center"
    )
    --Cube
    if self.timer > self.appearTime then
        love.graphics.setColor(0.8, 0, 0.8, 1)
        love.graphics.rectangle("fill", 440, 200, 80, 80)
    end
    --Draw score bg
    love.graphics.setColor(0.2, 0.2, 0.2, 0.5)
    love.graphics.rectangle("fill", 430, 490, 100, 50)
    --Draw score text
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    love.graphics.setFont(Interface.assets.fontMedium)
    love.graphics.print(
        self.scores[1] .. "   " .. self.scores[2], 450, 500
    )

    --Player comparison:
    if self.clickTimes[1] < 0 or self.clickTimes[2] < 0 then return end
    love.graphics.setFont(Interface.assets.fontSmall)
    --P1
    love.graphics.setColor(0, 0, 0.8, 1)
    love.graphics.printf(
        "P1 : " .. string.sub(tostring(self.clickTimes[1]), 1, 5), 430, 394, 1000
    )
    --P2
    love.graphics.setColor(0.8, 0, 0, 1)
    love.graphics.printf(
        "P2 : " .. string.sub(tostring(self.clickTimes[2]), 1, 5), 430, 420, 1000
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

return reflexGame