local joystickManager = {

}

function love.joystickadded(joystick)
    --Connect joystick
    if JoystickManager.gamepads[1] then
        --Connect player 2
        JoystickManager.gamepads[2] = joystick
    else
        --Connect player 1
        JoystickManager.gamepads[1] = joystick
    end
end

function joystickManager:load()
    self.gamepads = {nil, nil}
    self.gamepadsConnected = false
end

function joystickManager:update()
    self.gamepadsConnected = self.gamepads[1] ~= nil and self.gamepads[2] ~= nil
end

return joystickManager