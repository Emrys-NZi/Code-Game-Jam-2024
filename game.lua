entities = {}
rooms = {}

function entities:insert(e)
    table.insert(self, e)
end
function entities:remove(e)
    for i, v in ipairs(self) do
        if v == e then
            table.remove(self, i)
        end
    end
end
function entities:draw()
    for i,v in ipairs(self) do
        local e = self[i]

        if e.draw ~= nil then
            love.graphics.push()
            if e.x ~= nil and e.y ~= nil then
                love.graphics.translate(e.x, e.y)
            end
            e:draw()
            love.graphics.pop()
        end
    end
end
function entities:update(dt)
    for i,v in ipairs(self) do
        local e = self[i]
        
        if e.update ~= nil then
            e:update(dt)
        end
    end
end
function rooms:insert(e)
    table.insert(self, e)
end
function rooms:remove(e)
    for i, v in ipairs(self) do
        if v == e then
            table.remove(self, i)
        end
    end
end
function rooms:reset()
    if self.active ~= nil then
        self.active:disable()
        self.active = nil
    end
    for i, v in ipairs(self) do
        table.remove(self, i)
    end
end
function rooms:generate(level)
    self:reset()
    rooms.level = level
    local dir = nil
    local last = nil
    local px = 0
    local py = 0
    local pw = 32
    local ph = 16
    local maxroom = 8 + level * 2
    for i = 1, maxroom do
        local r = Room:new(px, py, pw, ph, level)
        if i == maxroom then
            local door = Door:new(px + pw/2 * TILE_WIDTH, py + r:get_y(math.floor(pw/2)) * TILE_HEIGHT, true, r.entities)
            local boss = Poulicier:new(px + pw/2 * TILE_WIDTH, py + r:get_y(math.floor(pw/2)) * TILE_HEIGHT, r.entities)
            boss.death = function()
                Poulicier.death(boss)
                door.locked = false
            end
        end
        for x = 0, pw - 1 do
            r:set(x, 0, 1)
            r:set(x, ph - 1, 1)
        end
        for y = 1, ph - 2 do
            r:set(0, y, 1)
            r:set(pw - 1, y, 1)
        end
        local ndir
        if dir == nil then
            ndir = love.math.random(1,3)
        else
            last.neighbors[dir] = r

            if i < maxroom - 1 then
                ndir = love.math.random(1,2)
                if dir == 2 then
                    if ndir >= dir then
                        ndir = ndir + 1
                    end
                elseif dir ~= 2 then
                    if ndir ~= 2 then
                        ndir = dir
                    end
                end
            else
                if dir == 2 then
                    ndir = love.math.random(1,2)
                    if ndir >= dir then
                        ndir = ndir + 1
                    end
                elseif dir ~= 2 then
                    ndir = dir
                end
            end

            dir = (dir+2)%4
            if dir == 2 or dir == 0 then
                for x = 1, pw - 2 do
                    if dir == 2 then
                        r:set(x, 0, 0)
                    else
                        r:set(x, ph - 1, 0)
                    end
                end
            else
                for y = 1, ph - 2 do
                    if dir == 1 then
                        r:set(0, y, 0)
                    else
                        r:set(pw - 1, y, 0)
                    end
                end
            end
            r.neighbors[dir] = last
        end
        if ndir == 2 or dir == 0 then
            local y = love.math.random(2, 3)
            if side == nil then side = love.math.random(2) end
            while y < ph - 1 do
                local a = love.math.random(3, pw/4)
                local b = love.math.random(pw/4, pw/2-3)
                if side == 2 then
                    a = a + pw/2
                    b = b + pw/2
                end
                for x = a, b do
                    r:set(x, y, 1)
                end
                if side == 1 then side = 2 else side = 1 end
                y = y + love.math.random(2, 4)
            end
        elseif i > 1 then
            local x = 4
            while x < pw - 4 do
                x = x + love.math.random(1, 3)
                local a = love.math.random(ph-4, ph-1)
                local b = love.math.random(ph-2, ph-1)
                for y = a, b do
                    r:set(x, y, 1)
                end
            end
            local number = love.math.random(0, 3)
            for i = 1, number do
                local x = love.math.random(4, pw-4)
                local y = r:get_y(x)
                Crow:new(px + x * TILE_WIDTH, py + y * TILE_HEIGHT, r.entities)
            end
        end
        dir = ndir
        if i < maxroom then
            if dir == 2 then
                for x = 1, pw - 2 do
                    r:set(x, 0, 0)
                end
            else
                for y = 1, ph - 2 do
                    if dir == 1 then
                        r:set(0, y, 0)
                    else
                        r:set(pw - 1, y, 0)
                    end
                end
            end
        end
        if dir == 0 then py = py + ph * TILE_HEIGHT
        elseif dir == 1 then px = px - pw * TILE_WIDTH
        elseif dir == 2 then py = py - ph * TILE_HEIGHT
        elseif dir == 3 then px = px + pw * TILE_WIDTH end

        if i == 1 then
            self:switch(r)
        end
        last = r
    end
end
function rooms:switch(room)
    if self.active ~= nil then
        self.active:disable()
    end
    self.active = room
    room:enable()
end
function rooms:draw()
    if self.active ~= nil and self.active.active then
        self.active:draw()
    end
end
function rooms:update(dt)
    if self.active ~= nil then
        self.active:update(dt)
    end
end

function entityFilter(item, other)
    for k,v in ipairs(entities) do
        if other == v then
            return "cross"
        end
    end
    for a,b in ipairs(rooms) do
        for c,d in ipairs(b.entities) do
            if other == d then
                return "cross"
            end
        end
    end
    if item.bounce == true then
        return "bounce"
    else
        return "slide"
    end
end