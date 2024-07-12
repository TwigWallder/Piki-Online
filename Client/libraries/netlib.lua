-- le client et serveur communiquent
-- avec des packets dits 'porteurs' ne
-- contenant que 'type' (connect, disconnect, receive),
-- 'data' et 'peer'.
-- la partie data de ces packets porteurs
-- contient cependant les donnees qui nous
-- interessent, c'est a dire le 'type' ('player_move', 'player_die')
-- et un champ 'data' contenant les donnees relatives au
-- type de packet

local netlib = {}

local enet = require("enet")
local pm  = require("libraries.packetManager")

-- creation du client
function netlib:createClient(config)
    config = config or {}

    self.debug = config.debug or false

    -- config reseau
    self.host = enet.host_create()

    -- event system
    self.eventHandlers = {}
end

-- creation du serveur
function netlib:createServer(config)
    config = config or {}

    self.debug = config.debug or false

    -- config reseau
    self.port = config.port or 6789
    self.host = enet.host_create("localhost:" .. tostring(self.port))

    -- event system
    self.eventHandlers = {}
end

-- connection du client au serveur
function netlib:connect(serverAddress)
    if not self.host then
        return
    end
    local server = self.host:connect(serverAddress)
    return server
end

-- ajout d'un handler pout un event
-- specifie l'event (ex: 'packet')
-- et le callback qui serat appeler
function netlib:on(event, handler)
    if not self.eventHandlers[event] then
        self.eventHandlers[event] = {}
    end
    table.insert(self.eventHandlers[event], handler)
end

-- emission de l'event avec
-- les donner nescessaire
function netlib:emit(event, ...)
    if self.eventHandlers[event] then
        for _, handler in ipairs(self.eventHandlers[event]) do
            handler(...)
        end
    end
end

function netlib:pollEvents()
    if not self.host then
        return
    end
	local event = self.host:service()
    if event == nil then
        return
    end

    -- debug packet data
    if self.debug then
        for k, v in pairs(event) do
            print(k, v)
        end
    end

    if event.type == "receive" then    -- RECEIVE
        print("packet received from ", event.peer)

        -- packet 'porteur'
        local carrier = pm:deserialize(event.data)

        -- packet
        local packet = {
            sender = event.peer,
            type = carrier.type or "unknown",  -- ici du coup le type correspond a l'action en jeux
            data = carrier.data
        }
        self:emit(packet.type, packet);
    elseif event.type == "connect" then    -- CONNECT
        print("connection request received from ", event.peer)

        -- packet
        local packet = {
            sender = event.peer,
            type = "connect"
        }
        self:emit(packet.type, packet);
    elseif event.type == "disconnect" then    -- DISCONNECT
        print("connection lost from ", event.peer)

        -- packet
        local packet = {
            sender = event.peer,
            type = "disconnect"
        }
        self:emit(packet.type, packet);
    end
end

-- cette fonction permet d'envoyer un packet construit
-- avec la fonction pm:createPacket
function netlib:send(packet, destination)
    if not packet or not destination then
        return
    end
    destination:send(pm:serialize(packet))
end

return netlib
