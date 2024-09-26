Helmet = class('Helmet', Armour)


function Helmet:initialize(parent, atk)

	Armour.initialize(self, parent)

	self.attaque = atk or 2
    self.vitesse = 0
    self.vie = 0
	self.animation = {
		direction = "left",
		idle = true,
		frame = 4,
		max_frames = 6,
		timer = 0.1
	}

end

--
function Helmet:draw()
	--for i=1, self.health do
	if not self.animation.idle then
		for i=self.animation.frame, self.animation.max_frames do
			if self.animation.direction == "right" then
				love.graphics.draw(armoursprite, armourquads[i], -14+5*i, -64+4*i, 0, -1, 1, armourquad_width, 0)
			else
				love.graphics.draw(armoursprite, armourquads[i], -36-5*i, -64+4*i)
			end
		end
		self.animation.idle = true
	end
	if self.animation.direction == "right" then
		love.graphics.draw(armoursprite, armourquads[self.animation.frame], -32, -64, 0, -1, 1, armourquad_width, 0)
	else
		love.graphics.draw(armoursprite, armourquads[self.animation.frame], -32, -64)
	end	
	--end
end