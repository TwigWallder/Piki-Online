
Player = {}

camera = require 'libraries/camera'
cam = camera()

anim8 = require 'libraries/anim8'

sti = require 'libraries/sti'
gameMap = sti('maps/testMap.lua')

function Player:load()

    self.x = 400
    self.y = 200
    self.speed = 5
    self.spriteSheet = love.graphics.newImage('sprites/player-sheet.png')
    self.grid = anim8.newGrid( 12, 18, self.spriteSheet:getWidth(), self.spriteSheet:getHeight() )

    self.animations = {}
    self.animations.down = anim8.newAnimation( self.grid('1-4', 1), 0.2 )
    self.animations.left = anim8.newAnimation( self.grid('1-4', 2), 0.2 )
    self.animations.right = anim8.newAnimation( self.grid('1-4', 3), 0.2 )
    self.animations.up = anim8.newAnimation( self.grid('1-4', 4), 0.2 )

    self.anim = self.animations.left

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
end

function Player:update(dt)
    self:move(dt)
    self:camera()
end

function Player:draw()
    cam:attach()
    gameMap:drawLayer(gameMap.layers["Ground"])
    gameMap:drawLayer(gameMap.layers["Trees"])
    self.anim:draw(self.spriteSheet, self.x, self.y, nil, 6, nil, 6, 9)
    cam:detach()
end

function Player:move(dt)
    local isMoving = false

    if love.keyboard.isDown("right") then
        self.x = self.x + self.speed
        self.anim = self.animations.right
        isMoving = true
    end

    if love.keyboard.isDown("left") then
        self.x = self.x - self.speed
        self.anim = self.animations.left
        isMoving = true
    end

    if love.keyboard.isDown("down") then
        self.y = self.y + self.speed
        self.anim = self.animations.down
        isMoving = true
    end

    if love.keyboard.isDown("up") then
        self.y = self.y - self.speed
        self.anim = self.animations.up
        isMoving = true
    end

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
