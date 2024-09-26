-- debugger ! laisser tout en haut du fichier

if arg[#arg] == "vsc_debug" then require("lldebugger").start() end

love.graphics.setDefaultFilter("nearest", "nearest")

require("input")
heigth = 200
class = require("lib.middleclass")
bump = require("lib.bump")
world = bump.newWorld(32)
local eggdrasil = love.graphics.newImage('assets/Main_page.png')
commandeAffiche=false

local x_image = (love.graphics.getWidth() - eggdrasil:getWidth()) /2

require("game")
require("room")
require("entity.entity")
require("weapon.weapon")

require("functionsButtons")
buttons = {{x  = love.graphics.getWidth()/2 - 150/2, y = love.graphics.getHeight()/2 - 100 - 50/2, text = "Play Game", func = playGame}, 
{x =love.graphics.getWidth()/2 - 150/2, y = love.graphics.getHeight()/2 - 50/2, text = "Commands", func = optionAffiche}, 
{x =love.graphics.getWidth()/2 - 150/2, y = love.graphics.getHeight()/2 + 100 - 50/2,text = "Quit Game", func = love.window.close}}

over = {{x  = love.graphics.getWidth()/2 - 100 - 200/2 - 10, y = love.graphics.getHeight()/2 - 200/2, text = "RESTART", func = playGame}, 
{x =love.graphics.getWidth()/2 + 100 - 200/2 + 10, y = love.graphics.getHeight()/2 - 200/2,text = "Quit Game", func = love.window.close}}

function love.load()
	menuDeb = Menu:new(150,50, buttons, "vertical")
end

function love.draw()
	love.graphics.draw(eggdrasil, x_image+25)
	if commandeAffiche then
		option()
	end
	
	rooms:draw()
	love.graphics.push()
	if rooms.active ~= nil then
		love.graphics.translate(-rooms.active.x, -rooms.active.y)
	end
	entities:draw()
	love.graphics.pop()

	
end

function love.update(dt)
	if love.keyboard.isDown("m") then
		dt = dt / 2
	end
	rooms:update(dt)
	entities:update(dt)
	--if player ~= nil and player.health <= 0 then
		--Menu:new(100,50, over, "horizontal")
		--love.window.close() 
	--end
end