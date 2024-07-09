chatBox = {}

function chatBox:load()
    self.x = 5
    self.y = 450
    self.actif = false
    self.time = os.date('*t')

    text = "You: "
end

function chatBox:update(dt)
end
function chatBox:keypressed(key)
    if key == "return" then
        self.actif = not self.actif
    end
end


function chatBox:draw()
    if self.actif then
        love.graphics.setColor(0,0,0, 0.5)
        love.graphics.rectangle("fill", self.x, self.y, 300, 250)
        love.graphics.setColor(1,1,1)
        love.graphics.rectangle("line", self.x, self.y, 300, 250)
        
        love.graphics.rectangle("line", self.x + 5, self.y + 225, 280, 20)
        love.graphics.print("You: ", self.x + 10, self.y + 225)
        
        love.graphics.print("Chatbox          *Piki Online*", self.x + 5, self.y + 5)
        love.graphics.print("Time: "..tostring(self.time.hour), self.x + 200, self.y + 5)
        love.graphics.print(":"..tostring(self.time.min), self.x + 252, self.y + 5)
        love.graphics.print("----------------------------------------------------------------------", self.x + 5, self.y + 15)
    end
    love.graphics.setColor(1,1,1)
end