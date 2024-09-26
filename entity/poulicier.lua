Poulicier = class('Poulicier', Enemy)

local pouliciersprite = love.graphics.newImage("assets/poulicier.png")

function Poulicier:initialize(x, y, ent)
    Enemy.initialize(self, x, y, pouliciersprite:getWidth(), pouliciersprite:getHeight(), 10, ent)
    self.gx = -128
    self.bounce = true
end
function Poulicier:update(dt)
    local cols = Enemy.update(self, dt)
    for k,v in pairs(cols) do
        if v.normal.y == -1 and self.vy > 0 then
            self.vy = math.min(-self.vy, -512)
        end
        if v.normal.x == -1 and self.vx > 0 or v.normal.x == 1 and self.vx < 0 then
            self.gx = -self.gx
        end
    end
    if rooms.active ~= nil then
        if self.x < rooms.active.x + 4 * TILE_WIDTH then
            self.gx = 128
        end
        if self.x > rooms.active.x + (rooms.active.w - 4) * TILE_WIDTH then
            self.gx = -128
        end
    end
end
function Poulicier:draw()
    Enemy.draw(self)
    if self.gx < 0 then
        love.graphics.draw(pouliciersprite, -pouliciersprite:getWidth()/2, -pouliciersprite:getHeight())
    else
        love.graphics.draw(pouliciersprite, -pouliciersprite:getWidth()/2, -pouliciersprite:getHeight(), 0, -1, 1, pouliciersprite:getWidth(), 0)
    end
end