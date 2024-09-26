Menu = class('Menu', Entity)

function drawCenteredText(rectX, rectY, rectWidth, rectHeight, text)
	local font       = love.graphics.getFont()
	local textWidth  = font:getWidth(text)
	local textHeight = font:getHeight()
	love.graphics.print(text, rectX+rectWidth/2, rectY+rectHeight/2, 0, 1.5, 1.5 , textWidth/2, textHeight/2)
end

function Menu:initialize(widthButton, heigthButton, buttonList, direction)
    Entity.initialize(self,0,0)
    self.widthButton = widthButton
    self.heigthButton = heigthButton
    self.buttonList = buttonList
    self.selection = 1
    self.pressDown = false
    self.pressUp = false
    self.pressRight = false
    self.pressLeft = false
    self.pressJump = true
    self.direction = direction
end

function Menu:draw()
    love.graphics.setLineWidth(6)
    for i = 1, #self.buttonList do
        love.graphics.setColor(0.6,0.6,0.6)
        love.graphics.rectangle("fill",self.buttonList[i].x ,self.buttonList[i].y ,self.widthButton,self.heigthButton)
        love.graphics.setColor(0,0,0)
        love.graphics.rectangle("line",self.buttonList[i].x, self.buttonList[i].y,self.widthButton,self.heigthButton)
        drawCenteredText(self.buttonList[i].x, self.buttonList[i].y, self.widthButton, self.heigthButton, self.buttonList[i].text)
        love.graphics.setColor(1,1,1)
    end
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("line",self.buttonList[self.selection].x, self.buttonList[self.selection].y,self.widthButton,self.heigthButton)
    love.graphics.setLineWidth(1)
    love.graphics.setColor(1,1,1)
end

function Menu:update()
    if self.direction == "vertical" then
        if input:isDown("down") and self.pressDown == false and self.selection < #self.buttonList then
            self.selection = self.selection + 1
            self.pressDown = true
        elseif not input:isDown("down") then
            self.pressDown = false
        end
        if input:isDown("up") and self.pressUp == false and self.selection > 1 then
            self.selection = self.selection - 1
            self.pressUp = true
        elseif not input:isDown("up") then
            self.pressUp = false
        end

    elseif self.direction == "horizontal" then
        if input:isDown("right") and self.pressRight == false and self.selection < #self.buttonList then
            self.selection = self.selection + 1
            self.pressRight = true
        elseif not input:isDown("right") then
            self.pressRight = false
        end
        if input:isDown("left") and self.pressLeft == false and self.selection > 1 then
            self.selection = self.selection - 1
            self.pressLeft = true
        elseif not input:isDown("left") then
            self.pressLeft = false
        end
    end

    if input:isDown("jump") and self.pressJump == false then
        self.buttonList[self.selection].func()
        self.pressJump = true
    elseif not input:isDown("jump") then
        self.pressJump = false
    end
end