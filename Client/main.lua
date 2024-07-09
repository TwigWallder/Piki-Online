local STI = require("libraries/sti")
require("player")
require("network")
require("chatbox")
require("UI")
love.graphics.setDefaultFilter("nearest", "nearest")

function love.load()
	Map = STI("map/1.lua", {"box2d"})
	World = love.physics.newWorld(0, 0)
	World:setCallbacks(beginContact, endContact)
	Map:box2d_init(World)
	Map.layers.solid.visible = false

	background = love.graphics.newImage("assets/background.png")

	Player:load()
	chatBox:load()
	Networking:load()
	UI:load()
end

function love.update(dt)
	World:update(dt)
	Player:update(dt)
	chatBox:update(dt)
	Networking:update(dt)
	UI:update(dt)
end

function love.draw()
	love.graphics.draw(background)
	
	Map:draw(0, 0, 2, 2)
	love.graphics.push()

	
	love.graphics.scale(2,2)

	Player:draw()

	love.graphics.pop()
	
	UI:draw()
	Networking:draw()
	chatBox:draw()
end

function love.keypressed(key)
	Player:jump(key)
	chatBox:keypressed(key)
	if key == "escape" then
        Networking.debug = not Networking.debug
    end
end


function beginContact(a, b, collision)
	Player:beginContact(a,b,collision)
end

function endContact(a, b, collision)
	Player:endContact(a,b,collision)
end