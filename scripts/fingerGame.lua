local fingerGame = {}

function fingerGame:load()
    self.dividePos = 480
    self.realDividePos = 480
    self.scores = {2, 2}
    self.clicking = {false, false}
    self.startTimer = 3
    self.gameComplete = false
end

function fingerGame:update(delta)
    self.startTimer = self.startTimer - delta
    --Game over stuff
    if self.gameComplete and self.startTimer < 0.5 then
        GameState = "gameIntro5"
        Interface.introCountDown = 5
    end
    if self.gameComplete or self.startTimer > 0 then return end
    --Clicking:
    --Get click event
    for i = 1, 2 do
        if not self.clicking[i] and InputManager.gamepads[i]:isDown(1) then
            --Click
            if i == 1 then
                self.realDividePos = self.realDividePos + 30
            else
                self.realDividePos = self.realDividePos - 30
            end
        end
    end
    --Get button input
    for i = 1, 2 do
        self.clicking[i] = InputManager.gamepads[i]:isDown(1)
    end
    --Win check:
    if self.realDividePos > 950 then
        --P1
        self.dividePos = 480
        self.realDividePos = 480
        self.clicking = {false, false}
        self.startTimer = 3
        self.scores[1] = self.scores[1] + 1
    elseif self.realDividePos < 10 then
        --P2
        self.dividePos = 480
        self.realDividePos = 480
        self.clicking = {false, false}
        self.startTimer = 3
        self.scores[2] = self.scores[2] + 1
    end
    --Update visible divide pos
    self.dividePos = self.dividePos + (self.realDividePos-self.dividePos) * 8 * delta
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

    if self.startTimer > 0 and not self.gameComplete then
        --Countdown
        love.graphics.setColor(0.8, 0.8, 0.8, 1)
        love.graphics.setFont(Interface.assets.fontLarge)
        love.graphics.printf(
            math.ceil(self.startTimer), -19, 250, 1000, "center"
        )
    end

    --Game complete text
    if not self.gameComplete then return end
    local text
    if self.scores[1] > 2 then
        text = "PLAYER 1 WINS!"
    else
        text = "PLAYER 2 WINS!"
    end
    love.graphics.setFont(Interface.assets.fontLarge)
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
    love.graphics.printf(
        text, -19, 300, 1000, "center"
    )
end

return fingerGame