local enet = require "enet"
local host = enet.host_create()
local server = host:connect("localhost:6789")

local pm  = require "libraries/packetManager"
local serialize = pm.serialize
local deserialize = pm.deserialize
local tickrate = 20

require("player")
Networking = {}

function Networking.load()
	connected = false
	dataSend = 0
	dataReceived = 0 
	LogIn = false
	maxPing = 300
	playerID = 0
	playerCount = 0
	ticks = 0
	Networking.debug = false
end

function Networking.update(dt)
	ticks = ticks + love.timer.getDelta()
	if(ticks >= 1 / tickrate)then
		local event = host:service(maxPing)
		while event do
			dataSend = dataSend + 1
			
			if event.type == "receive" then
				connected = true
				dataReceived = dataReceived + 1
				print("Got message: ", event.data, event.peer)
				
				local request = deserialize(event.data)
				if request.type == "login" then
					playerID = request.ID
					playerCount = request.COUNT
					print("Got user ID: ", playerCount)
				end

				-- creation d'un packet (toujours donner un type)
				moveData = {}
				moveData.type = "move"

				moveData.ID = playerID
				moveData.x = Player.x
				moveData.y = Player.y

				local movePacket = serialize(moveData)
				event.peer:send(movePacket)
			elseif event.type == "connect" then
				print(event.peer, "connected.")
				event.peer:send(serialize({ type = "ping" }))
			elseif event.type == "disconnect" then
				print(event.peer, "disconnected.")
			end
			event = host:service()
		end
		ticks = 0
	end
end

function Networking.draw()
	if Networking.debug then
		love.graphics.print("Data send:"..tostring(dataSend),5, 5)
		love.graphics.print("Data recieved:"..tostring(dataReceived),5, 15)
		love.graphics.print("Connexion: "..tostring(connected),5 ,25)
	end

	--for i=1, playerCount do
	--	if not (playerID == Player.ID) then 
	--		love.graphics.rectangle("fill", moveData.x, moveData.y, 100, 100)
	--	end
	--end
end