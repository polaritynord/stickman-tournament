local joystickManager = {

}

function love.joystickadded(joystick)
    if #JoystickManager.gamepads > 1 then return end
    JoystickManager.gamepads[#JoystickManager.gamepads+1] = joystick
end

function joystickManager:load()
    self.gamepads = {}
    self.gamepadsConnected = false;
end

function joystickManager:update()
    self.gamepadsConnected = #self.gamepads == 2
    print(#self.gamepads, self.gamepadsConnected)
end

return joystickManager