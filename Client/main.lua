require("player")
require("network")
require("chatbox")
require("UI")
love.graphics.setDefaultFilter("nearest", "nearest")

function love.load()

	Player:load()
	chatBox:load()
	Networking:load()
	UI:load()
end

function love.update(dt)
	Player:update(dt)
	chatBox:update(dt)
	Networking:update(dt)
	UI:update(dt)
end

function love.draw()
	Player:draw()
	UI:draw()
	Networking:draw()
	chatBox:draw()
end

function love.keypressed(key)
	chatBox:keypressed(key)
	if key == "escape" then
        Networking.debug = not Networking.debug
    end
end