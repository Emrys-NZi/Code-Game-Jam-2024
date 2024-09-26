Door = class('Door', Entity)

local doorsprite = love.graphics.newImage("assets/door.png")
local doorquads = {}
doorquads[1] = love.graphics.newQuad(0, 0, doorsprite:getWidth()/2, doorsprite:getHeight()/2, doorsprite:getWidth(), doorsprite:getHeight())
doorquads[2] = love.graphics.newQuad(doorsprite:getWidth()/2, 0, doorsprite:getWidth()/2, doorsprite:getHeight()/2, doorsprite:getWidth(), doorsprite:getHeight())
doorquads[3] = love.graphics.newQuad(0, doorsprite:getHeight()/2, doorsprite:getWidth()/2, doorsprite:getHeight()/2, doorsprite:getWidth(), doorsprite:getHeight())

function Door:initialize(x, y, locked, ent)
    Entity.initialize(self, x, y, ent)
    self.locked = locked
    self.hoveron = false
    self.time = 0
end

function Door:draw()
	love.graphics.setColor(1,1,1)
    local quad
    if self.locked then
	    quad = doorquads[1]
    else
	    quad = doorquads[2]
    end
    love.graphics.draw(doorsprite, quad, -32, -64)
    if self.hoveron then
        love.graphics.draw(doorsprite, doorquads[3], -32, -160 + math.sin(self.time*8) * 16)
    end
end

function Door:update(dt)
    if not self.locked then
        local items, len = world:queryRect(self.x-32, self.y-64, 64, 64)
        self.hoveron = false
        for k, v in pairs(items) do
            if v == player then
                self.hoveron = true
                break
            end
        end
        if self.hoveron then
            self.time = self.time + dt
            if input:isDown("dash") then
                rooms:generate(rooms.level + 1)
                player:move(128, 128)
                player.vx = 0
                player.vy = 0
            end
        end
    end
end