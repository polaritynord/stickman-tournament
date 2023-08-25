local interface = {}

function interface:load()
    --Load UI assets
    self.assets = {
        --Images
        menuLogo = love.graphics.newImage("images/menu_logo.png");
        pongIcon = love.graphics.newImage("images/icon_pong.png");
        blueGuy = love.graphics.newImage("images/blueguy.png");
        redGuy = love.graphics.newImage("images/redguy.png");
        --Fonts
        fontSmall = love.graphics.newFont("fonts/fff_forward.ttf", 12);
        fontMedium = love.graphics.newFont("fonts/fff_forward.ttf", 24);
        fontLarge = love.graphics.newFont("fonts/fff_forward.ttf", 36);
    }
    self.menuFade = false
    self.menuAlpha = 1
    self.menuExpTimer = 0;
    self.titleTexts = {
        "PING-PONG",
        "REFLEX CLICK",
        "CAR RACE",
        "FAST FINGERS",
        "TANK DUEL"
    }
    self.introCountDown = 0;
end

--Main menu
function interface:updateMenu(delta)
    if GameState ~= "menu" then return end
    --Launch tournament
    if InputManager.gamepadsConnected then
        if InputManager.gamepads[1]:isDown(1) or InputManager.gamepads[2]:isDown(1) then
            self.menuFade = true
        end
    end

    --Fade away menu
    if self.menuFade then
        self.menuAlpha = self.menuAlpha - 3 * delta
        if self.menuAlpha < 0 then self.menuAlpha = 0 end
    end
    if self.menuAlpha == 0 then
        --Tournament intro phases timer
        self.menuExpTimer = self.menuExpTimer + delta
        --Launch first game introduction screen
        if math.abs(math.ceil(10.7-self.menuExpTimer)) < 1 then
            GameState = "gameIntro1"
            self.introCountDown = 5
        end
    end
end

function interface:drawMenu()
    if GameState ~= "menu" then return end
    --Watermark(?)
    love.graphics.setFont(self.assets.fontSmall)
    love.graphics.setColor(0.1, 0.1, 0.1, self.menuAlpha)
    love.graphics.print("Made by Zerpnord for the SOFA Jam", 2, 3)
    --Logo
    love.graphics.setColor(1, 1, 1, self.menuAlpha)
    love.graphics.draw(
        self.assets.menuLogo, 480, 150, 0, 8, 8, 50, 7.5
    )
    --Players online status:
    love.graphics.setColor(0.37, 0.92, 0.37, self.menuAlpha-0.25)
    love.graphics.setFont(self.assets.fontMedium)
    --P1
    if InputManager.gamepads[1] then
        love.graphics.printf("ONLINE", -365, 320, 1000, "center")
    end
    --P2
    if InputManager.gamepads[2] then
        love.graphics.printf("ONLINE", 325, 320, 1000, "center")
    end

    love.graphics.setColor(0.1, 0.1, 0.1, self.menuAlpha)
    love.graphics.setFont(self.assets.fontSmall)
    if InputManager.gamepadsConnected then
        --Press any button to ready text
        love.graphics.printf(
            "Press the A or Cross Button to start the tournament!", -19, 370, 1000, "center"
        )
    else
        --Connect gamepads text
        love.graphics.printf(
            "Connect ".. 2-#InputManager.gamepads .." controller(s) to continue.", -19, 370, 1000, "center"
        )
    end

    --Tournament explanation texts
    love.graphics.setFont(self.assets.fontMedium)
    if self.menuExpTimer > 1.3 then
        love.graphics.setColor(1, 1, 1, self.menuExpTimer-1.3)
        love.graphics.printf(
            "You will play 5 mini-games: each with one to win.", -19, 60, 1000, "center"
        )
    end
    if self.menuExpTimer > 4 then
        love.graphics.setColor(1, 1, 1, self.menuExpTimer-4)
        love.graphics.printf(
            "The player with the most wins will leave from the tournament as champion.", 35, 140, 900, "center"
        )
    end
    if self.menuExpTimer > 6.7 then
        love.graphics.setColor(1, 1, 1, self.menuExpTimer-6.7)
        love.graphics.printf(
            "Commencing first game in " .. math.abs(math.ceil(10.7-self.menuExpTimer)), 35, 300, 900, "center"
        )
    end
end

--Pong intro
function interface:updateGameIntroTitle(delta)
    if not string.find(GameState, "gameIntro") then return end
    self.introCountDown = self.introCountDown - delta
end

function interface:drawPongIntro()
    if GameState ~= "gameIntro1" then return end
    --Icon
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(
        self.assets.pongIcon, 480, 220, 0, 4, 4, 16, 16
    )
    --Description
    love.graphics.setColor(0.1, 0.1, 0.1, 1)
    love.graphics.setFont(self.assets.fontSmall)
    love.graphics.printf(
        "First player to get to 3 points wins! P.S the ball speeds up over time lol", -19, 300, 1000, "center"
    )
end

--Main game intro stuff
function interface:drawGameIntroTitle()
    if not string.find(GameState, "gameIntro") then return end
    local i = tonumber(string.sub(GameState, 10, 10))
    --Game #
    love.graphics.setColor(0.1, 0.1, 0.1, 1)
    love.graphics.setFont(self.assets.fontLarge)
    love.graphics.printf(
        "GAME " .. i, -19, 60, 1000, "center"
    )
    --Game title
    love.graphics.setFont(self.assets.fontMedium)
    love.graphics.printf(
        self.titleTexts[i], -19, 120, 1000, "center"
    )
    --Countdown
    love.graphics.setFont(self.assets.fontLarge)
    love.graphics.printf(
        math.ceil(self.introCountDown), -19, 350, 1000, "center"
    )
    --P1 image
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(
        self.assets.blueGuy, 400, 480, 0, 4, 4, 7, 11
    )
    --Scores
    love.graphics.setColor(0.1, 0.1, 0.1, 1)
    love.graphics.print(Scores[1] .. " - " .. Scores[2], 440, 480)
    --P2 image
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(
        self.assets.redGuy, 585, 480, 0, 4, 4, 7, 11
    )
end

--Main functions
function interface:update(delta)
    self:updateMenu(delta)
    self:updateGameIntroTitle(delta)
end

function interface:draw()
    self:drawMenu()
    self:drawPongIntro()
    self:drawGameIntroTitle()
end

return interface