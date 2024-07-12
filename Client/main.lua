require("player")
require("chatbox")
require("UI")

-- networking
local netlib = require("libraries.netlib")
local pm = require("libraries.packetManager")
local tickrate = 20
local ticks = 0
local server = nil

love.graphics.setDefaultFilter("nearest", "nearest")

function love.load()
	Player:load()
	chatBox:load()
	UI:load()

    netlib:createClient()                       -- creation du client
    server = netlib:connect("localhost:6789")   -- connexion au serveur

     -- gestion des requetes de connexion
    netlib:on("connect", function(packet)
        netlib:send(pm:createPacket("ping", {
            message = "client ping"
        }), packet.sender)
    end)

    -- gestion des requetes de ping
    netlib:on("ping", function(packet)
        netlib:send(pm:createPacket("pong", {
            message = "client alive"
        }), packet.sender)
    end)
end

function love.update(dt)
    ticks = ticks + dt
    if ticks >= 1 / tickrate then
        netlib:pollEvents()                     -- lecture des packets

        -- juste pour tester on envoi un packet 'player_move' avec la position du joueur
        netlib:send(pm:createPacket("player_move", {
            x = Player.x,
            y = Player.y
        }), server)
    end

	Player:update(dt)
	chatBox:update(dt)
	UI:update(dt)
end

function love.draw()
	Player:draw()
	UI:draw()
	chatBox:draw()
end

function love.keypressed(key)
	chatBox:keypressed(key)
end
