require("input")

function playGame()
    menuDeb:remove()
    heigth = 200
    buttonsTypes = {{x  = love.graphics.getWidth()/2 - heigth - 200/2 - 10, y = love.graphics.getHeight()/2 - 200/2, text = "Defense", func = defenseGame}, 
    {x =love.graphics.getWidth()/2 - 200/2, y = love.graphics.getHeight()/2 - 200/2, text = "Attack", func = attackGame}, 
    {x =love.graphics.getWidth()/2 + heigth - 200/2 + 10, y = love.graphics.getHeight()/2 - 200/2,text = "Speed", func = speedGame}}
    menuTypes = Menu:new(heigth, 200, buttonsTypes, "horizontal")
end

function defenseGame()
    menuTypes:remove()
	rooms:generate(1)
	player = Player:new(128, 128,1.5,1,1, 1)
    playerX = 128
    playerY = 128
end

function attackGame()
    menuTypes:remove()
	rooms:generate(1)
	player = Player:new(128, 128, 1,1.5,1, 0)
    playerX = 128
    playerY = 128
end

function speedGame()
    menuTypes:remove()
	rooms:generate(1)
	player = Player:new(128, 128,1,1,1.5, 2)
    playerX = 128
    playerY = 128
end



buttonInput = {"up","left","down","right","jump","dash","hit"}
function option()
    love.graphics.setLineWidth(6)
    for i, v in pairs(buttonInput) do
        love.graphics.setColor(0.6,0.6,0.6)
        love.graphics.rectangle("fill",(love.graphics.getWidth()/2) -200+ 200 * (math.ceil(i/4)-1)  ,love.graphics.getHeight()/8 + 100*((i-1)%4)+80,150, 50)
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("line",(love.graphics.getWidth()/2) -200+ 200 * (math.ceil(i/4)-1)  ,love.graphics.getHeight()/8 + 100*((i-1)%4)+80,150, 50)
        drawCenteredText((love.graphics.getWidth()/2) -200+ 200 * (math.ceil(i/4)-1) ,love.graphics.getHeight()/8 + 100*((i-1)%4)+80,150, 50, v .." : " .. love.keyboard.getKeyFromScancode(input.keys[v]))    
    end    
    love.graphics.setLineWidth(1)
end

function optionAffiche()
    commandeAffiche=true
    menuDeb:remove()
    buttonBack = {{x = love.graphics.getWidth() - 200, y = love.graphics.getHeight() - 100, text = "Back", func = menuBase }}
    menuBack = Menu:new(love.graphics.getWidth()/8,love.graphics.getHeight()/8, buttonBack, "vertical")
end

function menuBase()
    if menuBack ~= nil then
        menuBack:remove()
    end
    commandeAffiche=false
    menuDeb = Menu:new(150,50, buttons, "vertical")
end

