local menuParticles = {
    particles = {};
    timer = 0;
}

function menuParticles:update(delta)
    --Update existing particles
    for i, v in ipairs(self.particles) do
        --Move up
        v.position[2] = v.position[2] - 300 * delta
        --Fade away
        v.color[4] = v.color[4] - 2 * delta
        --Shrink
        v.radius = v.radius - 10 * delta
        --Despawn
        if v.color[4] < 0 then
            table.remove(self.particles, i)
        end
    end

    --Increment timer for particle spawning
    local particleSpawnCooldown = 0
    self.timer = self.timer + delta
    if self.timer < particleSpawnCooldown then return end
    self.timer = 0
    
    --Spawn new particle:
    --Determine the amount to generate by the current framerate
    local framerate = 1/delta
    local i = math.ceil(60/framerate)
    for _ = 1, i, 1 do
        local particle = {
            position = {math.uniform(20, 940), 540};
            radius = 5;
            color = {1, 1, 1, 1};
        }
        --Define color based on the location at screen (blue to red)
        print(particle.position[1]-460)
        --particle.color[1] = particle.position[1]-460
        self.particles[#self.particles+1] = particle
    end
end

function menuParticles:draw()
    --Draw existing particles
    for i, v in ipairs(self.particles) do
        love.graphics.setColor(v.color)
        love.graphics.circle("fill", v.position[1], v.position[2], v.radius)
    end
end

return menuParticles