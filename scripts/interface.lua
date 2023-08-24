local interface = {}

function interface:load()
    --Load UI assets
    self.assets = {
        --Images
        menuLogo = love.graphics.newImage("images/menu_logo.png");
        --Fonts
        fontSmall = love.graphics.newFont("fonts/fff_forward.ttf", 12);
        fontMedium = love.graphics.newFont("fonts/fff_forward.ttf", 24);
        fontLarge = love.graphics.newFont("fonts/fff_forward.ttf", 36);
    }
    self.menuFade = false
    self.menuAlpha = 1
end

function interface:update(delta)
    --Fade away menu
    if self.menuFade then
        self.menuAlpha = self.menuAlpha - 3 * delta
        if self.menuAlpha < 0 then self.menuAlpha = 0 end
    end
    --Main menu:
    if GameState == "menu" then
        --Launch tournament
        if JoystickManager.gamepadsConnected then
            if JoystickManager.gamepads[1]:isDown(1) or JoystickManager.gamepads[2]:isDown(1) then
                self.menuFade = true
            end
        end
    end
end

function interface:draw()
    --Main menu:
    if GameState == "menu" then
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
        if JoystickManager.gamepads[1] then
            love.graphics.printf("ONLINE", -365, 320, 1000, "center")
        end
        --P2
        if JoystickManager.gamepads[2] then
            love.graphics.printf("ONLINE", 325, 320, 1000, "center")
        end

        love.graphics.setColor(0.1, 0.1, 0.1, self.menuAlpha)
        love.graphics.setFont(self.assets.fontSmall)
        if JoystickManager.gamepadsConnected then
            --Press any button to ready text
            love.graphics.printf(
                "Press the A or Cross Button to start the tournament!", -19, 370, 1000, "center"
            )
        else
            --Connect gamepads text
            love.graphics.printf(
                "Connect ".. 2-#JoystickManager.gamepads .." controller(s) to continue.", -19, 370, 1000, "center"
            )
        end
    end
end

return interface