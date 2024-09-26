Enemy = class('Enemy', Entity)

function Enemy:initialize(x, y, w, h, hp, ent)
    Entity.initialize(self, x, y, ent)

    self.w = w
    self.h = h
	-- velocity
	self.vx = 0
	self.vy = 0

	-- velocity goal
	self.gx = 0
	self.gy = 512

	-- acceleration
	self.ax = 2048 -- how much vy should move towards gy
	self.ay = 1024 -- how much vx should move towards gx

	self.blink = 0

	self.hp = hp

	world:add(self, self.x-w/2, self.y-h, w, h)
end

function Enemy:move(x, y)
	self.x = x
	self.y = y
	world:update(self, x, y)
end
function Enemy:draw()
	if self.blink > 0 then
		love.graphics.setColor(1,0,0)
	else
		love.graphics.setColor(1,1,1)
	end
end

function Enemy:update(dt)
	if math.abs(self.vx - self.gx) < self.ax * dt then
		self.vx = self.gx
	elseif self.vx < self.gx then
		self.vx = self.vx + self.ax * dt
	else
		self.vx = self.vx - self.ax * dt
	end
	if math.abs(self.vy - self.gy) < self.ay * dt then
		self.vy = self.gy
	elseif self.vy < self.gy then
		self.vy = self.vy + self.ay * dt
	else
		self.vy = self.vy - self.ay * dt
	end

	local calX = self.x + self.vx * dt - self.w/2
	local calY = self.y + self.vy * dt - self.h
	local newX, newY, cols, len = world:move(self, calX, calY, entityFilter)
	for i, v in ipairs(cols) do
		if v.other == player then
			v.other:hit()
		end
	end
	self.vx = self.vx - (calX - newX) / dt
	self.vy = self.vy - (calY - newY) / dt
	self.x = newX + self.w/2
	self.y = newY + self.h
	if cols[1] ~= nil and cols[1].normal.y == -1 then
		self.ax = 3072
	else
		self.ax = 1024
	end
	if self.blink > 0 then
		self.blink = self.blink - dt
	end

	return cols, len
end

function Enemy:death()
	self:remove()
end
function Enemy:remove()
	world:remove(self)
	Entity.remove(self)
end

function Enemy:hit(dmg)
	if self.blink <= 0 then
		self.blink = 0.2
		self.hp = self.hp - dmg
		if self.hp <= 0 then
			self:death()
		end
	end
end
	