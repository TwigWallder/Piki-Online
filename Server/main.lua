local netlib = require("libraries.netlib")
local pm = require("libraries.packetManager")

local tickrate = 20
local ticks = 0

function love.load()
    print("loading server")
    -- creation du serveur
    netlib:createServer({
        debug = true
    })

    -- gestion des requetes de ping
    netlib:on("ping", function(packet)
        netlib:send(pm:createPacket("pong", {
            message = "server alive"
        }), packet.sender)
    end)
end

function love.update(dt)
    ticks = ticks + dt
    if ticks >= 1 / tickrate then
        netlib:pollEvents()                 -- lecture des packets
    end
end
