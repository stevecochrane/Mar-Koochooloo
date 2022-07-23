import "CoreLibs/frameTimer"
import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"

local gfx <const> = playdate.graphics

-- Size of each tile on the board (and snake segment, and pellet)
local tileSize = 16

-- Here's our player sprite declaration. We'll scope it to this file because
-- several functions need to access it.
local playerSprite = nil

-- TODO: Implement as enum if possible?
-- Possible values are "up", "right", "down", and "left"
local playerDirection = "right"

-- The player will move every time the frameTimer hits this number.
-- Declaring it here also lets us change it later.
local playerMoveInterval = 10

-- We'll check this on every frame to determine if it's time to move.
local moveTimer = playdate.frameTimer.new(playerMoveInterval)
moveTimer.repeats = true

-- If the player collides with one of these, game over.
local leftBoundary = 16
local rightBoundary = 384 -- Right edge of screen (400) minus tileSize (16)
local topBoundary = 16
local bottomBoundary = 224 -- Bottom edge of screen (240) minus tileSize (16)

-- TODO: Implement as enum if possible?
-- Possible values are "play", "end"
local gameState = "play"

-- A function to set up our game environment.
function myGameSetUp()
	print('myGameSetUp()')

	-- Set up the player sprite.
	-- The :setCenter() call specifies that the sprite will be anchored at its center.
	-- The :moveTo() call moves our sprite to the center of the display.
	local playerImage = gfx.image.new("images/player")

	-- 400 / 16 = 25 vertical columns
	-- 12 * 16 = 192 for middle column
	-- 192 + 8 for half of sprite width = 200
	local startingX = 200

	-- 240 / 16 = 15 horizontal rows
	-- 7 * 16 = 112 for middle row
	-- 112 + 8 for half of sprite height = 120
	local startingY = 120

	playerSprite = gfx.sprite.new(playerImage)
	playerSprite:moveTo(startingX, startingY)
	playerSprite:add()

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

	-- TODO: Disallow moving in the opposite direction
	if playdate.buttonJustPressed(playdate.kButtonUp) then
		playerDirection = "up"
	elseif playdate.buttonJustPressed(playdate.kButtonRight) then
		playerDirection = "right"
	elseif playdate.buttonJustPressed(playdate.kButtonDown) then
		playerDirection = "down"
	elseif playdate.buttonJustPressed(playdate.kButtonLeft) then
		playerDirection = "left"
	end

	if (moveTimer.frame == playerMoveInterval) then
		-- TODO: Implement as switch statement, if possible?
		if (playerDirection == "up") then
			playerSprite:moveBy(0, -tileSize)
		elseif (playerDirection == "right") then
			playerSprite:moveBy(tileSize, 0)
		elseif (playerDirection == "down") then
			playerSprite:moveBy(0, tileSize)
		elseif (playerDirection == "left") then
			playerSprite:moveBy(-tileSize, 0)
		end
	end

	if (playerSprite.x <= leftBoundary or playerSprite.x >= rightBoundary or playerSprite.y <= topBoundary or playerSprite.y >= bottomBoundary) then
		print('game over')
		gameState = "end"
	end

	gfx.sprite.update()
	playdate.frameTimer.updateTimers()

end
