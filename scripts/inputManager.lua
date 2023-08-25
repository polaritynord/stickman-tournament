local InputManager = {

}

function love.joystickadded(joystick)
    --Connect joystick
    if InputManager.gamepads[1] then
        --Connect player 2
        InputManager.gamepads[2] = joystick
    else
        --Connect player 1
        InputManager.gamepads[1] = joystick
    end
end

function InputManager:load()
    self.gamepads = {nil, nil}
    self.gamepadsConnected = false
end

function InputManager:update()
    self.gamepadsConnected = self.gamepads[1] ~= nil and self.gamepads[2] ~= nil
end

return InputManager