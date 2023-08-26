local duckGame = {}

function duckGame:generateDucks()
    self.ducks = {}
    --Generate ducks around:
    --Set numbers
    local total = 300
    local j = math.random(-5, 5)
    self.red = 100 + j
    self.blue, self.purple = 1, 1
    local t
    repeat
        t = math.random(-5, 5)
    until math.abs(t) ~= math.abs(j)
    self.blue = 100 + t
    self.purple = total - self.red - self.blue
    --Determine the most
    self.theMost = nil
    local temp = math.max(self.red, self.blue, self.purple)
    if temp == self.blue then self.theMost = "blue"
    elseif temp == self.red then self.theMost = "red"
    else self.theMost = "purple" end

    local duck -- Position, size, rot, type
    --Blue
    for _ = 1, self.blue do
        duck = {
            {math.uniform(37, 923), math.uniform(37, 503)}, math.uniform(1.5, 2.7), math.uniform(0, math.pi*2), "blue"
        }
        self.ducks[#self.ducks+1] = duck
    end
    --Red
    for _ = 1, self.red do
        duck = {
            {math.uniform(37, 923), math.uniform(37, 503)}, math.uniform(1.5, 2.7), math.uniform(0, math.pi*2), "red"
        }
        self.ducks[#self.ducks+1] = duck
    end
    --Purp
    for _ = 1, self.purple do
        duck = {
            {math.uniform(37, 923), math.uniform(37, 503)}, math.uniform(1.5, 2.7), math.uniform(0, math.pi*2), "purple"
        }
        self.ducks[#self.ducks+1] = duck
    end
end

function duckGame:determineSelectedColor(c)
    local r, g, b = 0.1, 0.1, 0.1
    if self.selections[1] == c then
        b = 0.8
    end
    if self.selections[2] == c then
        r = 0.8
    end
    love.graphics.setColor(r, g, b, 1)
end

function duckGame:load()
    self.assets = {
        duck_red = love.graphics.newImage("images/duck_red.png");
        duck_blue = love.graphics.newImage("images/duck_blue.png");
        duck_purple = love.graphics.newImage("images/duck_purple.png");
        arrow = love.graphics.newImage("images/arrow.png");
    }
    self.countdown = 10
    self.gameComplete = false
    self.scores = {0, 0}
    self.selections = {nil, nil}
    self.winner = ""
    self.doneTimer = 0
    self:generateDucks()
end

function duckGame:update(delta)
    self.countdown = self.countdown - delta
    if self.gameComplete then
        self.doneTimer = self.doneTimer + delta
        if self.doneTimer > 2.5 then
            GameState = "gameIntro4"
            Interface.introCountDown = 5
        end
    end
    if self.gameComplete then return end
    if self.countdown > 0 then
        --Player selections:
        for i = 1, 2 do
            --Make sure player hasnt selected anything yet
            if self.selections[i] == nil then
                if InputManager.gamepads[i]:isDown(12) then
                    --blue
                    self.selections[i] = "blue"
                end
                if InputManager.gamepads[i]:isDown(15) then
                    --red
                    self.selections[i] = "red"
                end
                if InputManager.gamepads[i]:isDown(13) then
                    --purp
                    self.selections[i] = "purple"
                end
            end
        end
        --Skip timer if everyone selected
        if self.selections[1] and self.selections[2] then self.countdown = -0.01 end
    else
        if self.winner == "" then
            --Determine scores:
            local blue = self.theMost == self.selections[1]
            local red = self.theMost == self.selections[2]
            if blue and red then
                --Draw if they both got it right
                self.winner = "BOTH CORRECT"
            elseif blue and not red then
                --Blue win
                self.winner = "PLAYER 1 CORRECT"
                self.scores[1] = self.scores[1] + 1
            elseif not blue and red then
                --Red win
                self.winner = "PLAYER 2 CORRECT"
                self.scores[2] = self.scores[2] + 1
            elseif not blue and not red then
                --Draw, they both are wrong
                self.winner = "BOTH INCORRECT"
            end
        end
        --Check if the game ended:
        --P1
        if self.scores[1] > 2 then
            Scores[1] = Scores[1] + 1
            self.gameComplete = true
        end
        --P1
        if self.scores[2] > 2 then
            Scores[2] = Scores[2] + 1
            self.gameComplete = true
        end
        --Reset game:
        if self.countdown < -3.2 then
            self.countdown = 10
            self.selections = {nil, nil}
            self.winner = ""
            self:generateDucks()
        end
    end
end

function duckGame:draw()
    if self.countdown > 0 then
        --Draw ducks
        local image
        for _, v in ipairs(self.ducks) do
            image = self.assets["duck_"..v[4]]
            love.graphics.draw(
                image, v[1][1], v[1][2], v[3], v[2], v[2], image:getWidth()/2, image:getHeight()/2
            )
        end
        --Draw countdown bg
        love.graphics.setColor(0.2, 0.2, 0.2, 0.5)
        love.graphics.rectangle("fill", 430, 0, 100, 50)
        --Draw countdown text
        love.graphics.setColor(0.8, 0.8, 0.8, 1)
        love.graphics.setFont(Interface.assets.fontMedium)
        love.graphics.print(
            string.sub(tostring(self.countdown), 1, 3), 460, 10
        )

        --Selection guidance:
        love.graphics.setFont(Interface.assets.fontSmall)
        --bg
        love.graphics.setColor(0.2, 0.2, 0.2, 0.5)
        love.graphics.rectangle("fill", 0, 440, 100, 110)
        --Up arrow = blue
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(
            self.assets.arrow, 15, 460, 0, 3, 3, 4, 4
        )
        love.graphics.print("Blue", 32, 456)
        --right arrow = red
        love.graphics.draw(
            self.assets.arrow, 15, 490, math.pi/2, 3, 3, 4, 4
        )
        love.graphics.print("Red", 32, 486)
        --down arrow = purple
        love.graphics.draw(
            self.assets.arrow, 15, 520, math.pi, 3, 3, 4, 4
        )
        love.graphics.print("Purple", 32, 516)
    else
        --Winner text
        love.graphics.setColor(0.1, 0.1, 0.1, 1)
        love.graphics.setFont(Interface.assets.fontLarge)
        love.graphics.printf(
            self.winner, -19, 100, 1000, "center"
        )
        --Actual numbers:
        love.graphics.setFont(Interface.assets.fontMedium)
        --Blue
        self:determineSelectedColor("blue")
        love.graphics.printf(
            "Blue: " .. self.blue, -19, 175, 1000, "center"
        )
        --Red
        self:determineSelectedColor("red")
        love.graphics.printf(
            "Red: " .. self.red, -19, 215, 1000, "center"
        )
        --Purple
        self:determineSelectedColor("purple")
        love.graphics.printf(
            "Purple: " .. self.purple, -19, 255, 1000, "center"
        )
    end

    --Draw score bg
    love.graphics.setColor(0.2, 0.2, 0.2, 0.5)
    love.graphics.rectangle("fill", 430, 490, 100, 50)
    --Draw score text
    love.graphics.setFont(Interface.assets.fontMedium)
    love.graphics.setColor(0.8, 0.8, 0.8, 1)
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

return duckGame