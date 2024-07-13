
Player = {}

-- Camera
camera = require 'libraries/camera'
cam = camera()

-- Animation
anim8 = require 'libraries/anim8'

-- Map
sti = require 'libraries/sti'
gameMap = sti('maps/testMap.lua')

-- Collision system
wf = require 'libraries/windfield'
world = wf.newWorld(0, 0)

function Player:load()

    self.x = 400
    self.y = 200
    self.speed = 500
    self.spriteSheet = love.graphics.newImage('sprites/player-sheet.png')
    self.grid = anim8.newGrid( 12, 18, self.spriteSheet:getWidth(), self.spriteSheet:getHeight() )

    self.animations = {}
    self.animations.down = anim8.newAnimation( self.grid('1-4', 1), 0.2 )
    self.animations.left = anim8.newAnimation( self.grid('1-4', 2), 0.2 )
    self.animations.right = anim8.newAnimation( self.grid('1-4', 3), 0.2 )
    self.animations.up = anim8.newAnimation( self.grid('1-4', 4), 0.2 )

    self.anim = self.animations.left

    self.collider = world:newBSGRectangleCollider(400, 250, 50, 100, 10)
    self.collider:setFixedRotation(true)

    -- Network
    self.ID = 0

    -- Stat
    self.maxHP = 100
    self.HP = self.maxHP
    self.maxMP = 100
    self.MP = self.maxMP
    self.physicAttack = 0
    self.magicAttack = 0
    self.defense = 0
    self.Intelligence = 0
    self.Dexterity = 0
    self.Agility = 0
    self.luck = 0

    -- Level
    self.level = 1
    self.nextXp = 50
    self.xp = 0

    -- A déplacer plus tard
    local wall = world:newRectangleCollider(100, 200, 120, 300)
    wall:setType('static')
end

function Player:update(dt)
    self:move(dt)
    self:camera()

    world:update(dt)
    self.x = self.collider:getX()
    self.y = self.collider:getY()
end

function Player:draw()
    cam:attach()
    gameMap:drawLayer(gameMap.layers["Ground"])
    gameMap:drawLayer(gameMap.layers["Trees"])
    self.anim:draw(self.spriteSheet, self.x, self.y, nil, 6, nil, 6, 9)
    love.graphics.print("ID: "..tostring(self.ID), self.x - 15, self.y - 70)
    world:draw()
    cam:detach()
end

function Player:move(dt)
    local isMoving = false

    local vx = 0
    local vy = 0

    if love.keyboard.isDown("right", "d") then
        vx = self.speed
        self.anim = self.animations.right
        isMoving = true
    end

    if love.keyboard.isDown("left", "q") then
        vx = self.speed * -1
        self.anim = self.animations.left
        isMoving = true
    end

    if love.keyboard.isDown("down", "s") then
        vy = self.speed
        self.anim = self.animations.down
        isMoving = true
    end

    if love.keyboard.isDown("up", "z") then
        vy = self.speed * -1
        self.anim = self.animations.up
        isMoving = true
    end

    self.collider:setLinearVelocity(vx, vy)

    if isMoving == false then
        self.anim:gotoFrame(2)
    end

    self.anim:update(dt)
end

function Player:camera()
    -- Update camera position
    cam:lookAt(self.x, self.y)

    -- This section prevents the camera from viewing outside the background
    -- First, get width/height of the game window
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    -- Left border
    if cam.x < w/2 then
        cam.x = w/2
    end

    -- Right border
    if cam.y < h/2 then
        cam.y = h/2
    end

    -- Get width/height of background
    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    -- Right border
    if cam.x > (mapW - w/2) then
        cam.x = (mapW - w/2)
    end
    -- Bottom border
    if cam.y > (mapH - h/2) then
        cam.y = (mapH - h/2)
    end
end
