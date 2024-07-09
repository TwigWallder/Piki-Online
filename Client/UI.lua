require("player")
UI = {}

function UI:load()
    xExperience = 0
    yExperience = 455

    xBadge = 5
    yBadge = 5
    
end

function UI:update(dt)

end

function UI:draw()
    -- Badge du joueur
    love.graphics.setColor(0,0,0, 0.5)
    love.graphics.rectangle("fill", xBadge, yBadge, 200, 100)
    love.graphics.setColor(1,0,1)
    love.graphics.rectangle("fill", xBadge + 1, yBadge + 1, 75, 75)
    love.graphics.setColor(1,1,1)
    love.graphics.print("HP ", xBadge + 80, yBadge + 1)
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("fill", xBadge + 100, yBadge + 5, 95, 10)
    love.graphics.setColor(1,1,1)
    love.graphics.print("MP ", xBadge + 80, yBadge + 21)
    love.graphics.setColor(0, 0, 1)
    love.graphics.rectangle("fill", xBadge + 100, yBadge + 25, 95, 10)


    -- Bar d'expérience
    local xpProgress =  Player.xp / Player.nextXp
    local width = 1270

    love.graphics.setColor(0,0,0,0.5)
    love.graphics.rectangle("fill", xExperience + 5, yExperience + 251, width, 8)
    love.graphics.setColor(1,1,0)
    love.graphics.rectangle("fill", xExperience + 5, yExperience + 251, width * xpProgress, 8)
    love.graphics.setColor(0,0,0)
    love.graphics.rectangle("line", xExperience + 5, yExperience + 251, width, 8)
    
    love.graphics.setColor(1, 1, 1, 1)
end