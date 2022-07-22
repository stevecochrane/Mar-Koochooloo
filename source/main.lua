import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"

local gfx <const> = playdate.graphics

-- Here's our player sprite declaration. We'll scope it to this file because
-- several functions need to access it.
local playerSprite = nil

-- TODO: Implement as enum if possible?
-- Possible values are "up", "right", "down", and "left"
local playerDirection = "right"

-- A function to set up our game environment.
function myGameSetUp()

	-- Set up the player sprite.
	-- The :setCenter() call specifies that the sprite will be anchored at its center.
	-- The :moveTo() call moves our sprite to the center of the display.
	local playerImage = gfx.image.new("images/player")

	playerSprite = gfx.sprite.new(playerImage)
	playerSprite:moveTo(200, 120) -- this is where the center of the sprite is placed; (200,120) is the center of the Playdate screen
	playerSprite:add() -- This is critical!

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

-- `playdate.update()` is the heart of every Playdate game.
-- This function is called right before every frame is drawn onscreen.
-- Use this function to poll input, run game logic, and move sprites.
function playdate.update()

	-- Poll the d-pad and move our player accordingly.
	-- (There are multiple ways to read the d-pad; this is the simplest.)
	-- Note that it is possible for more than one of these directions
	-- to be pressed at once, if the user is pressing diagonally.
	if playdate.buttonJustPressed(playdate.kButtonUp) then
		playerDirection = "up"
	elseif playdate.buttonJustPressed(playdate.kButtonRight) then
		playerDirection = "right"
	elseif playdate.buttonJustPressed(playdate.kButtonDown) then
		playerDirection = "down"
	elseif playdate.buttonJustPressed(playdate.kButtonLeft) then
		playerDirection = "left"
	end

	-- TODO: Implement as switch statement, if possible?
	if (playerDirection == "up") then
	  playerSprite:moveBy(0, -2)
	elseif (playerDirection == "right") then
	  playerSprite:moveBy(2, 0)
	elseif (playerDirection == "down") then
	  playerSprite:moveBy(0, 2)
	elseif (playerDirection == "left") then
	  playerSprite:moveBy(-2, 0)
	end

	-- Call this in playdate.update() to draw sprites.
	gfx.sprite.update()

end
