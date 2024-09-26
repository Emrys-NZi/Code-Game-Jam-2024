Room = class('Room')

TILE_WIDTH = 32
TILE_HEIGHT = 32

local tileset = {}
for i = 1, 6 do
    tileset[i] = {}
    tileset[i].img = love.graphics.newImage("assets/tileset" .. i .. ".png")
    tileset[i].quads = {}
    local j = 1
    for y = 0, tileset[i].img:getHeight()-1, TILE_HEIGHT do
        for x = 0, tileset[i].img:getWidth()-1, TILE_WIDTH do
            tileset[i].quads[j] = love.graphics.newQuad(x, y, TILE_WIDTH, TILE_HEIGHT, tileset[i].img:getWidth(), tileset[i].img:getHeight())
            j = j + 1
        end
    end
    tileset[i].types = {}
    tileset[i].types[0] = {}
    tileset[i].types[1] = {}
end
tileset[1].types[0][1] = 1
tileset[1].types[0][2] = 2
tileset[1].types[0][3] = 3
tileset[1].types[1][1] = 4
tileset[1].types[1][2] = 5

tileset[2].types[1][1] = 1
tileset[2].types[1][2] = 2
tileset[2].types[0][1] = 4

tileset[3].types[1][1] = 1
tileset[3].types[1][2] = 2
tileset[3].types[0][1] = 4

tileset[4].types[1][1] = 1
tileset[4].types[1][2] = 2
tileset[4].types[1][3] = 3
tileset[4].types[1][4] = 4
tileset[4].types[1][5] = 5
tileset[4].types[1][6] = 6
tileset[4].types[1][7] = 7
tileset[4].types[1][8] = 8
tileset[4].types[1][9] = 11
tileset[4].types[0][1] = 9

tileset[5].types[1][1] = 1
tileset[5].types[1][2] = 2
tileset[5].types[1][3] = 4
tileset[5].types[1][4] = 5
tileset[5].types[1][5] = 6
tileset[5].types[1][6] = 7
tileset[5].types[0][1] = 3

tileset[6].types[1][1] = 1
tileset[6].types[1][2] = 2
tileset[6].types[1][3] = 3
tileset[6].types[1][4] = 4
tileset[6].types[1][5] = 5
tileset[6].types[0][1] = 6

function Room:initialize(x, y, w, h, t)
    rooms:insert(self)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.t = t
    self.solid = {}
    self.tiles = {}
    for x = 0, w - 1 do
        for y = 0, h - 1 do
            self:set(x,y,0)
        end
    end
    self.active = false
    -- 0 : down
    -- 1 : left
    -- 2 : up
    -- 3 : right
    self.neighbors = {}
    self.entities = {}
    self.entities.insert = function(self, e)
        table.insert(self, e)
    end
    self.entities.remove = function(self, e)
        for i, v in ipairs(self) do
            if v == e then
                table.remove(self, i)
            end
        end
    end
end
function Room:enable()
    if not self.active then
        self.active = true
        rooms:insert(self)
        for x = 0, self.w - 1 do
            for y = 0, self.h - 1 do
                local i = x + y * self.w + 1
                if self.solid[i] > 0 then
                    world:add(i, self.x + x*TILE_WIDTH, self.y + y*TILE_HEIGHT, TILE_WIDTH, TILE_HEIGHT)
                end
            end
        end
    end
end
function Room:disable()
    if self.active then
        self.active = false
        rooms:remove(self)
        for i, v in ipairs(self.solid) do
            if v > 0 then --and world.rect[i] ~= nil then
                world:remove(i)
            end
        end
    end
end
function Room:get(x,y)
    return self.solid[x + y * self.w + 1]
end
function Room:set(x,y,t)
    local i = x + y * self.w + 1
    if self.active then
        if self.solid[i] == 0 and t > 0 then
            world:add(i, self.x + x*TILE_WIDTH, self.y + y*TILE_HEIGHT, TILE_WIDTH, TILE_HEIGHT)
        elseif self.solid[i] > 0 and t == 0 then
            world:remove(i)
        end
    end
    self.solid[i] = t
    self.tiles[i] = tileset[self.t].types[t][love.math.random(#tileset[self.t].types[t])]
end
function Room:get_y(x)
    for y = self.h - 2, 0, -1 do
        if self:get(x,y) == 0 and self:get(x,y+1) == 1 then
            return y+1
        end
    end
    if x > 0 then
        self:set(x-1,self.h/2, 1)
    end
    self:set(x,self.h/2, 1)
    return self.h/2
end
function Room:draw()
    love.graphics.setColor(1,1,1)
    for x = 0, self.w - 1 do
        for y = 0, self.h - 1 do
            local i = x + y * self.w + 1
            love.graphics.draw(tileset[self.t].img, tileset[self.t].quads[self.tiles[i]], x * TILE_WIDTH, y * TILE_HEIGHT)
        end
    end
    love.graphics.push()
    love.graphics.translate(-self.x, -self.y)
    for i,v in ipairs(self.entities) do
        local e = self.entities[i]

        if e.draw ~= nil then
            love.graphics.push()
            if e.x ~= nil and e.y ~= nil then
                love.graphics.translate(e.x, e.y)
            end
            e:draw()
            love.graphics.pop()
        end
    end
    love.graphics.pop()
end
function Room:update(dt)
    for i,v in ipairs(self.entities) do
        local e = self.entities[i]
        
        if e.update ~= nil then
            e:update(dt)
        end
    end
end