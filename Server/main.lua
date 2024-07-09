local enet = require "enet"
local host = enet.host_create("localhost:6789")

local pm  = require "libraries/packetManager"
local serialize = pm.serialize
local deserialize = pm.deserialize

maxPing = 300
playerCount = 0
playerID = 0

function love.update()
	print("tick")
	local event = host:service(maxPing)
	while event do
		for k, v in pairs(event) do
			print(k, v)
		end

		-- RECEIVE
		if event.type == "receive" then
			print("Got message: ", event.data, event.peer)
			
			local request = deserialize(event.data)
			if request.type == "move" then
				local response = serialize(request)
				event.peer:send(response)
			end

			-- CONNECT
		elseif event.type == "connect" then
			playerID = playerID + 1
			playerCount = playerCount + 1
			
			local responseData = {
				type = "login",
				ID = playerID,
				COUNT = playerCount
			}

			local response = serialize(responseData)
			event.peer:send(response)
			print(event.peer, "connected.")


			-- DISCONNECT
		elseif event.type == "disconnect" then
			print(event.peer, "disconnected.")
			playerCount = playerCount - 1
		end
		event = host:service()
	end
end