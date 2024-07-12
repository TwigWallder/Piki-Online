require("player")
require("chatbox")
require("UI")

-- networking
local netlib = require("libraries.netlib")
local pm = require("libraries.packetManager")
local connected = false
local tickrate = 20
local ticks = 0
local server = nil

love.graphics.setDefaultFilter("nearest", "nearest")

function love.load()
	Player:load()
	chatBox:load()
	UI:load()

    -- creation du client
    netlib:createClient({
        debug = true
    })
    server = netlib:connect("localhost:6789")   -- connexion au serveur

     -- gestion des requetes de connexion
    netlib:on("connect", function(packet)
        netlib:send(pm:createPacket("player_join", {
        }), packet.sender)
    end)

    netlib:on("disconnect", function()
        connected = false
    end)

    netlib:on("player_id", function(packet)
        connected = true -- on le met true ici et pas dans 'connect' car un joueur n'es valide uniquement s'il a un ID
        Player.ID = packet.data.ID
        print("player.ID = " .. Player.ID)
    end)
end

function love.update(dt)
    ticks = ticks + dt
    if ticks >= 1 / tickrate then
        netlib:pollEvents()                     -- lecture des packets

        -- juste pour tester on envoi un packet 'player_move' avec la position du joueur
        if connected then
            netlib:send(pm:createPacket("player_move", {
                ID = Player.ID,
                x = Player.x,
                y = Player.y
            }), server)
        end
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
