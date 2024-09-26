Weapon = class('Weapon')

weaponsprite = love.graphics.newImage('assets/weapons.png')
weaponsprite_width, weaponsprite_height = weaponsprite:getDimensions()
weaponquad_width = weaponsprite_width / 3
weaponquad_height = weaponsprite_height / 3
weaponquads = {}
local i = 1
for x=1, 3 do
	for y=1, 3 do
		weaponquads[i] = love.graphics.newQuad(weaponquad_width * (y-1), weaponquad_height * (x-1), weaponquad_width, weaponquad_height, weaponsprite_width, weaponsprite_height)
		i = i + 1
	end
end

function Weapon:initialize(parent)
    self.parent = parent    
end
   
function Weapon:use()
    local x,y
    local w,h = 64, 64
    y = self.parent.y - h
    if self.animation.direction == "right" then
        x = self.parent.x + 32
    else 
        x = self.parent.x - 32 - w
    end
    local items, len = world:queryRect(x,y,w,h)
    for k, v in pairs(items) do
        if v ~= player then
            if type(v) == "table" and v.hit ~= nil then
                v:hit(self.attaque)
            end
            self.parent.weaponuse = true
        end
    end
end

require("weapon.pan")
require("weapon.sword") 
require("weapon.axe")