Crow = class('Crow', Enemy)

local crowsprite = love.graphics.newImage("assets/crow.png")

function Crow:initialize(x, y, ent)
    Enemy.initialize(self, x, y, crowsprite:getWidth(), crowsprite:getHeight(), 3, ent)
end
function Crow:draw()
    Enemy.draw(self)
    if player.x > self.x then
        love.graphics.draw(crowsprite, -crowsprite:getWidth()/2, -crowsprite:getHeight())
    else
        love.graphics.draw(crowsprite, -crowsprite:getWidth()/2, -crowsprite:getHeight(), 0, -1, 1, crowsprite:getWidth(), 0)
    end
end

function Crow:update(dt)
    local cols = Enemy.update(self, dt)
    for k,v in pairs(cols) do
        if player.x > self.x then
            self.gx = 64 
        else
            self.gx = -64 
        end
        if v.normal.x == -1 or v.normal.x == 1  then
            self.vy = math.min(-self.vy, -250)
        end
    end
    if rooms.active ~= nil then
        if self.x < rooms.active.x + 4 * TILE_WIDTH then
            self.gx = 64
        end
        if self.x > rooms.active.x + (rooms.active.w - 4) * TILE_WIDTH then
            self.gx = -64
        end
    end
end