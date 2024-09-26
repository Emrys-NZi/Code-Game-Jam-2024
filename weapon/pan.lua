Pan = class('Pan', Weapon)

function Pan:initialize(parent, atk, vie)

	Weapon.initialize(self, parent)


	self.attaque = atk or 1
    self.vitesse = 0
    self.vie = vie
	self.animation = {
		direction = "left",
		idle = true,
		frame = 7,
		max_frames = 9,
		timer = 0.1
	}

end

--
function Pan:draw()
	--for i=1, self.health do
	self.animation.direction = self.parent.animation.direction
	if not self.animation.idle then
		for i=self.animation.frame, self.animation.max_frames do
			if self.animation.direction == "right" then
				love.graphics.draw(weaponsprite, weaponquads[i], -14+5*i, -64+4*i, 0, -1, 1, weaponquad_width, 0)
			else
				love.graphics.draw(weaponsprite, weaponquads[i], -36-5*i, -64+4*i)
			end
		end
		self.animation.idle = true
	end
	if self.animation.direction == "right" then
		love.graphics.draw(weaponsprite, weaponquads[self.animation.frame], -14, -64, 0, -1, 1, weaponquad_width, 0)
	else
		love.graphics.draw(weaponsprite, weaponquads[self.animation.frame], -36, -64)
	end
end