import "CoreLibs/frameTimer"
import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"

local gfx <const> = playdate.graphics

-- Native display resolution for the Playdate
local screenWidth = 400
local screenHeight = 240

-- Size of each tile on the board (and snake segment, and food)
local tileSize = 16

-- Here's our sprite declarations. We'll scope them to this file because
-- several functions need to access them.
local playerSprite = nil
local foodSprite = nil

-- TODO: Implement as enum if possible?
-- Possible values are "up", "right", "down", and "left"
local playerDirection = "right"
local playerDirectionBuffer = playerDirection

-- The player will move every time the frameTimer hits this number.
-- Declaring it here also lets us change it later.
local playerMoveInterval = 10

-- We'll check this on every frame to determine if it's time to move.
local moveTimer = playdate.frameTimer.new(playerMoveInterval)
moveTimer.repeats = true

-- If the player collides with one of these, game over.
local leftBoundary = 0 + tileSize
local rightBoundary = screenWidth - tileSize
local topBoundary = 0 + tileSize
local bottomBoundary = screenHeight - tileSize

-- TODO: Implement as enum if possible?
-- Possible values are "play", "end"
local gameState = "play"

function repositionFood()
	-- TODO: Check if colliding with snake, and if so, re-roll
	local newX = math.random(leftBoundary, rightBoundary)
	local newY = math.random(topBoundary, bottomBoundary)

	-- Round down to a multiple of tileSize, then add half of tileSize
	-- since sprite position is the center of the sprite.
	newX = newX - (newX % tileSize) + (tileSize / 2)
	newY = newY - (newY % tileSize) + (tileSize / 2)

	foodSprite:moveTo(newX, newY)
end

-- A function to set up our game environment.
function myGameSetUp()
	print('myGameSetUp()')

	-- Set up the player sprite.
	-- The :setCenter() call specifies that the sprite will be anchored at its center.
	-- The :moveTo() call moves our sprite to the center of the display.
	local spriteImage = gfx.image.new("images/sprite")

	-- 400 / 16 = 25 vertical columns
	-- 12 * 16 = 192 for middle column
	-- 192 + 8 for half of sprite width = 200
	local startingX = 200

	-- 240 / 16 = 15 horizontal rows
	-- 7 * 16 = 112 for middle row
	-- 112 + 8 for half of sprite height = 120
	local startingY = 120

	playerSprite = gfx.sprite.new(spriteImage)
	playerSprite:moveTo(startingX, startingY)
	playerSprite:add()

	foodSprite = gfx.sprite.new(spriteImage)
	repositionFood()
	foodSprite:add()

	-- We want an environment displayed behind our sprite.
	-- There are generally two ways to do this:
	-- 1) Use setBackgroundDrawingCallback() to draw a background image. (This is what we're doing below.)
	-- 2) Use a tilemap, assign it to a sprite with sprite:setTilemap(tilemap),
	--    and call :setZIndex() with some low number so the background stays behind
	--    your other sprites.
	local backgroundImage = gfx.image.new("images/background")
	assert(backgroundImage)

	gfx.sprite.setBackgroundDrawingCallback(
		function(x, y, width, height)
			gfx.setClipRect(x, y, width, height) -- let's only draw the part of the screen that's dirty
			backgroundImage:draw(0, 0)
			gfx.clearClipRect() -- clear so we don't interfere with drawing that comes after this
		end
	)

end

-- Now we'll call the function above to configure our game.
-- After this runs (it just runs once), nearly everything will be
-- controlled by the OS calling `playdate.update()` 30 times a second.
myGameSetUp()

function playdate.update()
	if gameState == "play" then
		playStateUpdate()
	elseif gameState == "end" then
		endStateUpdate()
	end

	gfx.sprite.update()
	playdate.frameTimer.updateTimers()
end

function playStateUpdate()
	if playdate.buttonJustPressed(playdate.kButtonUp) then
		if (playerDirection ~= "down") then
			playerDirectionBuffer = "up"
		end
	elseif playdate.buttonJustPressed(playdate.kButtonRight) then
		if playerDirection ~= "left" then
			playerDirectionBuffer = "right"
		end
	elseif playdate.buttonJustPressed(playdate.kButtonDown) then
		if playerDirection ~= "up" then
			playerDirectionBuffer = "down"
		end
	elseif playdate.buttonJustPressed(playdate.kButtonLeft) then
		if playerDirection ~= "right" then
			playerDirectionBuffer = "left"
		end
	end

	if (moveTimer.frame == playerMoveInterval) then
		-- TODO: Implement as switch statement, if possible?
		if playerDirectionBuffer == "up" then
			playerSprite:moveBy(0, -tileSize)
			playerDirection = "up"
		elseif playerDirectionBuffer == "right" then
			playerSprite:moveBy(tileSize, 0)
			playerDirection = "right"
		elseif playerDirectionBuffer == "down" then
			playerSprite:moveBy(0, tileSize)
			playerDirection = "down"
		elseif playerDirectionBuffer == "left" then
			playerSprite:moveBy(-tileSize, 0)
			playerDirection = "left"
		end
	end

	if (playerSprite.x <= leftBoundary or playerSprite.x >= rightBoundary or playerSprite.y <= topBoundary or playerSprite.y >= bottomBoundary) then
		print('gameState = "end"')
		gameState = "end"
	end
end

function endStateUpdate()
	if playdate.buttonJustPressed(playdate.kButtonA) then
		print('gameState = "play"')
		gameState = "play"
	end
end
