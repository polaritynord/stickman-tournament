local interface = {}

function interface:load()
    --Load UI assets
    self.assets = {
        menuLogo = love.graphics.newImage("images/menu_logo.png");
        fontSmall = love.graphics.newFont("fonts/fff_forward.ttf", 12);
        fontMedium = love.graphics.newFont("fonts/fff_forward.ttf", 24);
        fontLarge = love.graphics.newFont("fonts/fff_forward.ttf", 36);
    }
end

function interface:update(delta)
    --Main menu:
    if GameState == "menu" then

    end
end

function interface:draw()
    --Main menu:
    if GameState == "menu" then
        --Watermark(?)
        love.graphics.setFont(self.assets.fontSmall)
        love.graphics.setColor(0.1, 0.1, 0.1, 1)
        love.graphics.print("Made by Zerpnord for the SOFA Jam", 2, 3)
        --Logo
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(
            self.assets.menuLogo, 480, 150, 0, 8, 8, 50, 7.5
        )
        --Connect gamepads text
        if not JoystickManager.gamepadsConnected then
            love.graphics.setFont(self.assets.fontSmall)
            love.graphics.setColor(0.1, 0.1, 0.1, 1)
            love.graphics.printf(
                "Connect ".. 2-#JoystickManager.gamepads .." controller(s) to continue.", -19, 370, 1000, "center"
            )
            return
        end
    end
end

return interface