Player = class('Player', Entity)

local eggSprites = love.graphics.newImage("assets/egg.png")
local sprite = love.graphics.newImage('assets/player.png')
local sprite_width, sprite_height = sprite:getDimensions()
local quad_width = sprite_width / 4
local quad_height = sprite_height / 3
local quads = {}
local compteur = 1
for x=1, 4 do
	for y=1, 3 do
		quads[compteur] = love.graphics.newQuad(quad_width * (y-1), quad_height * (x-1), quad_width, quad_height, sprite_width, sprite_height)
		compteur  = compteur + 1
	end
end
local chickenstep = love.sound.newSoundData("assets/chickenstep1.ogg")
local chickenjump = love.sound.newSoundData("assets/chickenjump.ogg")
local chickenhit = love.sound.newSoundData("assets/chickenhit.ogg")
local chickendash = love.sound.newSoundData("assets/chickendash.ogg")

function Player:initialize(x, y, def, atk, spd,spriteChoice, chestplate, helmet, cape)


	Entity.initialize(self, x, y)

	self.weapon = Sword:new(self)
	self.chestplate = chestplate or nil
	self.helmet = helmet or nil 
	self.cape = cape or nil

	self.def = def or 1
	self.atk = atk or 1
	self.spd = spd or 1
	self.spriteChoice = spriteChoice or 0

	self.damages = self.atk + self.weapon.attaque
	self.totalSpeed = self.spd + self.weapon.vitesse

	self.peutdash = true
	self.delaiInit = 1 /spd
	self.delaidash = self.delaiInit

	self.peutplane = true
	self.delaiplane = self.delaiInit
	self.vy = 0
	self.jumpsleft = 0
	self.hasjumped = false

	self.weaponuse = false
	self.weaponcooldown = 0

	self.blink = 0
	
	-- velocity
	self.vx = 0
	self.vy = 0

	-- velocity goal
	self.gx = 0
	self.gy = 1024

	-- acceleration
	self.ax = 2048 -- how much vy should move towards gy
	self.ay = 2048 -- how much vx should move towards gx

	self.speed = 256 * self.spd -- pixels par seconde

	world:add(self, self.x-32, self.y-64, 64, 64)

	if (5*self.def)%1 < 0.5 then
		self.health = math.floor(5*self.def)
	else
		self.health = math.ceil(5*self.def)
	end
	self.animation = {
		direction = "left",
		idle = true,
		min_frames = 1 + 3*self.spriteChoice,
		frame = 1 + 3*self.spriteChoice,
		max_frames = 3 + 3*self.spriteChoice,
		speed = 20,
		timer = 0.1
	}
	self.stepsound = love.audio.newSource(chickenstep)
	self.jumpsound = love.audio.newSource(chickenjump)
	self.hitsound = love.audio.newSource(chickenhit)
	self.dashsound = love.audio.newSource(chickendash)
end

function Player:draw()
	if self.blink <= 0 then
		love.graphics.setColor(1,1,1)
	else
		love.graphics.setColor(1,0,0)
	end
	local width, height = love.graphics.getDimensions()
	for i=1, self.health do
		if self.animation.direction == "right" then
			love.graphics.draw(sprite, quads[self.animation.frame], -32, -64, 0, -1, 1, quad_width, 0)
			love.graphics.draw(eggSprites, 12*i-44, -84, 0, 0.4)
		else
			love.graphics.draw(sprite, quads[self.animation.frame], -32, -64)
			love.graphics.draw(eggSprites, 12*i-42, -84, 0, 0.4)
		end
	end
	if self.weapon ~= nil then
		self.weapon:draw()
	end
end

function Player:move(x, y)
	self.x = x
	self.y = y
	world:update(self, x, y)
end

function Player:hit()
	if self.blink <= 0 then
		self.health = self.health - 1
		self.blink = 0.5
		if self.health <= 0 then
			self:death()
		end
	end
end

function Player:update(dt)
	if self.blink > 0 then
		self.blink = self.blink - dt
	end
	if input:isDown("right") and not input:isDown("left") then
		self.gx = self.speed
		self.animation.idle = false
		self.animation.direction = "right"
		if input:isDown("dash") and self.peutdash then
			self.x = self.x+50
			self.peutdash = false
			self.dashsound:seek(0)
			self.dashsound:play()
		end
	elseif input:isDown("left") and not input:isDown("right") then
		self.gx = -self.speed
		self.animation.idle = false
		self.animation.direction = "left"
		if input:isDown("dash") and self.peutdash then
			self.x = self.x-50
			self.peutdash = false
			self.dashsound:seek(0)
			self.dashsound:play()
		end
	else 
		self.gx = 0 
		self.animation.idle = true
		self.animation.frame = self.animation.min_frames
	end
	if not self.animation.idle then
		self.animation.timer = self.animation.timer + math.abs(self.vx) * dt / 100
		if self.animation.timer > 0.2 then
			self.animation.timer = 0.1

			self.animation.frame = self.animation.frame + 1

			if self.animation.frame > self.animation.max_frames then
				self.animation.frame = self.animation.min_frames
				self.stepsound:seek(0)
				local random = 1 + 0.05 * (love.math.random() * 2 - 1)
				local pitch = (1.1^math.abs(self.vx/self.speed))*0.75
				self.stepsound:setPitch(random * pitch)
				self.stepsound:play()
			end
		end
	end

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

	if not self.peutdash then
		self.delaidash = self.delaidash - dt
		if self.delaidash <= 0 then
			self.peutdash = true
			self.delaidash = self.delaiInit
		end
	end

	local calX = self.x + self.vx * dt - 32
	local calY = self.y + self.vy * dt - 64
	local newX, newY, cols, len = world:move(self, calX, calY, entityFilter)
	self.vx = self.vx - (calX - newX) / dt
	self.vy = self.vy - (calY - newY) / dt
	self.x = newX + 32
	self.y = newY + 64
	if cols[1] ~= nil and cols[1].normal.y == -1 then
		self.ax = 3072
		self.jumpsleft = 1
		if input:isDown("jump") then
			self.vy = -768
			self.ay = 1024
			self.hasjumped = true
			self.jumpsound:seek(0)
			self.jumpsound:play()
		end
	else
		self.ax = 2048
		if not self.hasjumped and input:isDown("jump") and self.jumpsleft > 0 then
			self.vy = -256
			self.ay = 1024
			self.jumpsleft = self.jumpsleft - 1
			self.hasjumped = true
			self.jumpsound:seek(0)
			self.jumpsound:play()
		end
	end

	if not input:isDown("jump") then
		self.ay = 2048
		if self.hasjumped then
			self.hasjumped = false
		end
	end
	
	if rooms.active.neighbors[0] ~= nil then
		if self.y > rooms.active.y + rooms.active.h * TILE_HEIGHT + 32 then
			rooms:switch(rooms.active.neighbors[0])
		end
	end
	if rooms.active.neighbors[1] ~= nil then
		if self.x < rooms.active.x then
			rooms:switch(rooms.active.neighbors[1])
		end
	end
	if rooms.active.neighbors[2] ~= nil then
		if self.y < rooms.active.y + 32 then
			rooms:switch(rooms.active.neighbors[2])
		end
	end
	if rooms.active.neighbors[3] ~= nil then
		if self.x > rooms.active.x + rooms.active.w * TILE_WIDTH then
			rooms:switch(rooms.active.neighbors[3])
		end
	end
	if self.weaponcooldown <= 0 and input:isDown("hit") then
		self.weaponcooldown = 1
		self.weapon:use()
		self.hitsound:seek(0)
		self.hitsound:play()
	elseif self.weaponcooldown > 0 then
		self.weaponcooldown = self.weaponcooldown - dt
	end
	if self.weaponcooldown > 0.1 then
		self.weapon.animation.idle = false;
	end
end

function Player:death()
	rooms:reset()
	menuBase()
	self:remove()
end