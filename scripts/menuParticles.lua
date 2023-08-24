local menuParticles = {
    particles = {};
    timer = 0;
}

function menuParticles:update(delta)
    --Update existing particles
    for i, v in ipairs(self.particles) do
        --Move up or down
        v.position[2] = v.position[2] - 300 * delta
        --Fade away
        v.color[4] = v.color[4] - 2 * delta
        --Shrink
        v.size = v.size - 10 * delta
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

    --Spawn new particle
    for _ = 1, 500*delta do
        local particle = {
            position = {math.uniform(20, 940), 535};
            size = 5;
            color = {0, 0, 0, 1};
        }
        --Define color based on the location at screen (blue to red)
        particle.color[1] = math.abs(particle.position[1]-480)/480
        particle.color[3] = 1-particle.color[1]
        self.particles[#self.particles+1] = particle
    end
end

function menuParticles:draw()
    --Draw existing particles
    for i, v in ipairs(self.particles) do
        love.graphics.setColor(v.color)
        love.graphics.rectangle("fill", v.position[1], v.position[2], v.size, v.size)
    end
end

return menuParticles