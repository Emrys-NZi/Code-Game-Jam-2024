Chestplate = class('Chestplate', Armour)

function Chestplate:initialize(parent, atk)

	Armour.initialize(self, parent)

	self.attaque = 0
	self.animation = {
		direction = "left",
		idle = true,
		frame = 4,
		max_frames = 6,
		timer = 0.1
	}

end

--
--function Chestplate:draw()
	--for i=1, self.health do
	--[[if not self.animation.idle then
		for i=self.animation.frame, self.animation.max_frames do
			if self.animation.direction == "right" then
				love.graphics.draw(sprite, quads[i], -14+5*i, -64+4*i, 0, -1, 1, quad_width, 0)
			else
				love.graphics.draw(sprite, quads[i], -36-5*i, -64+4*i)
			end
		end
		self.animation.idle = true
	end
	if self.animation.direction == "right" then
		love.graphics.draw(sprite, quads[self.animation.frame], -32, -64, 0, -1, 1, quad_width, 0)
	else
		love.graphics.draw(sprite, quads[self.animation.frame], -32, -64)
	end	]]
	--end
--end