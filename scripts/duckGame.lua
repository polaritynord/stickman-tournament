local duckGame = {}

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
    self.ducks = {}
    --Generate ducks around:
    local total = 100
    local red = 33 + math.random(-3, 3)
    local blue = 33 + math.random(-3, 3)
    local purple = total - red - blue
    local duck -- Position, size, rot, type
    --Blue
    for _ = 1, blue do
        duck = {
            {math.uniform(37, 923), math.uniform(37, 503)}, math.uniform(1.5, 2.7), math.uniform(0, math.pi*2), "blue"
        }
        self.ducks[#self.ducks+1] = duck
    end
    --Red
    for _ = 1, red do
        duck = {
            {math.uniform(37, 923), math.uniform(37, 503)}, math.uniform(1.5, 2.7), math.uniform(0, math.pi*2), "red"
        }
        self.ducks[#self.ducks+1] = duck
    end
    --Purp
    for _ = 1, purple do
        duck = {
            {math.uniform(37, 923), math.uniform(37, 503)}, math.uniform(1.5, 2.7), math.uniform(0, math.pi*2), "purple"
        }
        self.ducks[#self.ducks+1] = duck
    end
end

function duckGame:update(delta)
    self.countdown = self.countdown - delta
    if self.gameComplete then return end
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
        --Up arrow = blue
        
    else

    end

    --Draw score bg
    love.graphics.setColor(0.2, 0.2, 0.2, 0.5)
    love.graphics.rectangle("fill", 430, 490, 100, 50)
    --Draw score text
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