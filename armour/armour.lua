Armour = class('Armour')

armoursprite = love.graphics.newImage('assets/items.png')
armoursprite_width, armoursprite_height = armoursprite:getDimensions()
armourquad_width = armoursprite_width / 3
armourquad_height = armoursprite_height / 3
armourquads = {}
local i = 1
for x=1, 3 do
	for y=1, 3 do
		armourquads[i] = love.graphics.newQuad(armourquad_width * (y-1), armourquad_height * (x-1), armourquad_width, armourquad_height, armoursprite_width, armoursprite_height)
		i  = i + 1
	end
end

function Armour:initialize(parent)
    self.parent = parent or nil   
end

   
require("armour.helmet")
require("armour.chestplate") 
require("armour.cape")