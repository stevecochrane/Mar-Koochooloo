import "CoreLibs/animation"
import "CoreLibs/frameTimer"
import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"

import "foodEaten"
import "PressStart"
import "speed"
import "walls"

local gfx <const> = playdate.graphics
local snd <const> = playdate.sound

-- Native display resolution for the Playdate
local screenWidth = 400
local screenHeight = 240

-- Size of each tile on the board (and snake segment, and food)
local tileSize = 16

-- Here's our sprite declarations. We'll scope them to this file because
-- several functions need to access them.
local playerSprite = nil
local foodSprite = nil

-- Initialize images
local foodImage = gfx.image.new("images/apple")
local gameOverImage = gfx.image.new("images/game-over")
local optionsScreenImage = gfx.image.new("images/options-screen")
local snakeBodyDownLeftImage = gfx.image.new("images/snake-body-down-left")
local snakeBodyDownRightImage = gfx.image.new("images/snake-body-down-right")
local snakeBodyLeftRightImage = gfx.image.new("images/snake-body-left-right")
local snakeBodyUpDownImage = gfx.image.new("images/snake-body-up-down")
local snakeBodyUpLeftImage = gfx.image.new("images/snake-body-up-left")
local snakeBodyUpRightImage = gfx.image.new("images/snake-body-up-right")
local snakeHeadDownImage = gfx.image.new("images/snake-head-down")
local snakeHeadLeftImage = gfx.image.new("images/snake-head-left")
local snakeHeadRightImage = gfx.image.new("images/snake-head-right")
local snakeHeadUpImage = gfx.image.new("images/snake-head-up")
local snakeTailDownImage = gfx.image.new("images/snake-tail-down")
local snakeTailLeftImage = gfx.image.new("images/snake-tail-left")
local snakeTailRightImage = gfx.image.new("images/snake-tail-right")
local snakeTailUpImage = gfx.image.new("images/snake-tail-up")
local stageWithWallsImage = gfx.image.new("images/stage-with-walls")
local stageWithoutWallsImage = gfx.image.new("images/stage-without-walls")
local titleScreenImage = gfx.image.new("images/title-screen")

-- Initialize music
local stageBgm = snd.fileplayer.new()
local menuBgm = snd.fileplayer.new()
stageBgm:setVolume("0.5")
menuBgm:setVolume("0.5")

-- Initialize sound effects
local foodSound = snd.sampleplayer.new("sound/instigation-block-clear")
local clickSound = snd.sampleplayer.new("sound/instigation-move")
local gameOverSound = snd.sampleplayer.new("sound/game-over")
local gameStartSound = snd.sampleplayer.new("sound/game-start")

-- TODO: Implement as enum if possible?
-- Possible values are "up", "right", "down", and "left"
local playerDirection = nil
local playerDirectionBuffer = nil

-- The player will move every time the frameTimer hits this number.
-- Declaring it here also lets us change it later.
local playerMoveInterval = nil
-- This is what is displayed to the user for their speed setting.
local speedSetting = 1
-- This is the mapping between the above two values.
local speedSettingMap = {19, 17, 15, 13, 11, 9, 7, 5, 3, 1}
local speedSettingMin = 1
local speedSettingMax = 10

-- We'll check this on every frame to determine if it's time to move.
local moveTimer = nil

-- If the player collides with one of these, game over.
local leftBoundary = 0 + tileSize
local rightBoundary = screenWidth - tileSize
local topBoundary = 0 + tileSize
local bottomBoundary = screenHeight - tileSize

-- Stores coordinates (e.g. {x, y}) for each segment of the snake.
local snakeCoordinates = nil

-- Stores sprites for each segment of the snake.
local snakeSprites = nil

-- Stores the direction the snake was traveling in for each segment of the snake.
local snakeDirections = nil

-- This may be customizeable later.
local startingSnakeSegments = 3

-- This is configurable in the options screen.
local wallsEnabled = true

-- This is internally configurable for testing.
local segmentsGainedWhenEating = 3
local segmentsToGain = 0

-- TODO: Implement as enum if possible?
-- Possible values are "title", "options", "play", "end"
local gameState = "title"

-- Length of time in frames for switching from state to state
-- 60 = 2 seconds @ 30 FPS
local stateSwitchDelay = 60

-- User preferences
local speed = nil
local walls = nil

-- Store how many pieces of food are eaten per game
local foodEatenCount = nil

-- Shared variable for PressStart instances
local pressStart = nil

function isCollidingWithSnake(coordinates)
	local collided = false

	for i = 1, #snakeCoordinates do
		if snakeCoordinates[i][1] == coordinates[1] and snakeCoordinates[i][2] == coordinates[2] then
			collided = true
			break
		end
	end

	return collided
end

function isCollidingWithStage(coordinates)
	local collided = false

	if coordinates[1] <= leftBoundary or coordinates[1] >= rightBoundary or coordinates[2] <= topBoundary or coordinates[2] >= bottomBoundary then
		collided = true
	end

	return collided
end

function repositionFood()
	local newX = nil
	local newY = nil
	local hasCollidedWithSnake = nil

	repeat
		if wallsEnabled then
			newX = math.random(leftBoundary, rightBoundary - 1)
			newY = math.random(topBoundary, bottomBoundary - 1)
		else
			newX = math.random(0, screenWidth - 1)
			newY = math.random(0, screenHeight - 1)
		end

		-- Round down to a multiple of tileSize, then add half of tileSize
		-- since sprite position is the center of the sprite.
		newX = newX - (newX % tileSize) + (tileSize / 2)
		newY = newY - (newY % tileSize) + (tileSize / 2)

		-- Check if new food position collides with any part of snake
		hasCollidedWithSnake = isCollidingWithSnake({newX, newY})

	-- Repeat the above until the food is not on the same tile as the player
	until hasCollidedWithSnake == false

	-- We have our new food position, move food sprite there
	foodSprite:moveTo(newX, newY)
end

function updateSnakeHead()
	-- Find second sprite in table
	-- Find direction of second sprite and of third sprite
	local current = snakeDirections[1]
	local previous = snakeDirections[2]

	local updatedImage = nil

	if current == "up" then
		if previous == "up" then
			updatedImage = snakeBodyUpDownImage
		elseif previous == "right" then
			updatedImage = snakeBodyUpLeftImage
		elseif previous == "left" then
			updatedImage = snakeBodyUpRightImage
		end
	elseif current == "right" then
		if previous == "up" then
			updatedImage = snakeBodyDownRightImage
		elseif previous == "right" then
			updatedImage = snakeBodyLeftRightImage
		elseif previous == "down" then
			updatedImage = snakeBodyUpRightImage
		end
	elseif current == "down" then
		if previous == "right" then
			updatedImage = snakeBodyDownLeftImage
		elseif previous == "down" then
			updatedImage = snakeBodyUpDownImage
		elseif previous == "left" then
			updatedImage = snakeBodyDownRightImage
		end
	elseif current == "left" then
		if previous == "up" then
			updatedImage = snakeBodyDownLeftImage
		elseif previous == "down" then
			updatedImage = snakeBodyUpLeftImage
		elseif previous == "left" then
			updatedImage = snakeBodyLeftRightImage
		end
	end

	snakeSprites[2]:setImage(updatedImage)
end

function updateSnakeTail()
	local lastDirection = snakeDirections[#snakeDirections - 1]
	local updatedImage = nil

	if lastDirection == "up" then
		updatedImage = snakeTailUpImage
	elseif lastDirection == "right" then
		updatedImage = snakeTailRightImage
	elseif lastDirection == "down" then
		updatedImage = snakeTailDownImage
	elseif lastDirection == "left" then
		updatedImage = snakeTailLeftImage
	end

	snakeSprites[#snakeSprites]:setImage(updatedImage)
end

-- A function for clearing existing sprites. This may be expanded upon later.
function clearGame()
	gfx.sprite.removeAll()
end

-- A function to set up our game environment.
function setUpGame()
	-- (Re-)initialize snake arrays
	snakeCoordinates = {}
	snakeSprites = {}
	snakeDirections = {}

	-- (Re-)intialize player direction
	playerDirection = "right"
	playerDirectionBuffer = playerDirection

	-- (Re-)initialize move timer
	moveTimer = playdate.frameTimer.new(playerMoveInterval)
	moveTimer.repeats = true

	-- (Re-)initialize food eaten
	foodEatenCount = 0

	-- 400 / 16 = 25 vertical columns
	-- 12 * 16 = 192 for middle column
	-- 192 + 8 for half of sprite width = 200
	local startingX = 200

	-- 240 / 16 = 15 horizontal rows
	-- 7 * 16 = 112 for middle row
	-- 112 + 8 for half of sprite height = 120
	local startingY = 120

	for i = 1, startingSnakeSegments do
		-- Add the point to snakeCoordinates
		table.insert(snakeCoordinates, {startingX, startingY})

		-- Determine which image to use for this segment based on segment number and direction
		local segmentImage = nil
		if i == 1 then
			if playerDirection == "up" then
				segmentImage = snakeHeadUpImage
			elseif playerDirection == "right" then
				segmentImage = snakeHeadRightImage
			elseif playerDirection == "down" then
				segmentImage = snakeHeadDownImage
			elseif playerDirection == "left" then
				segmentImage = snakeHeadLeftImage
			end
		elseif i == startingSnakeSegments then
			if playerDirection == "up" then
				segmentImage = snakeTailUpImage
			elseif playerDirection == "right" then
				segmentImage = snakeTailRightImage
			elseif playerDirection == "down" then
				segmentImage = snakeTailDownImage
			elseif playerDirection == "left" then
				segmentImage = snakeTailLeftImage
			end
		else
			if playerDirection == "up" or playerDirection == "down" then
				segmentImage = snakeBodyUpDownImage
			elseif playerDirection == "left" or playerDirection == "right" then
				segmentImage = snakeBodyLeftRightImage
			end
		end

		-- Add the current sprite to snakeSprites
		playerSprite = gfx.sprite.new(segmentImage)
		playerSprite:moveTo(startingX, startingY)
		playerSprite:add()
		table.insert(snakeSprites, playerSprite)

		-- Add direction for each segment to snakeDirections
		table.insert(snakeDirections, playerDirection)

		-- Decrement startingX to put next segment one tile behind
		startingX = startingX - tileSize
	end

	foodSprite = gfx.sprite.new(foodImage)
	repositionFood()
	foodSprite:add()

	gfx.sprite.setBackgroundDrawingCallback(
		function(x, y, width, height)
			gfx.setClipRect(x, y, width, height) -- let's only draw the part of the screen that's dirty

			if wallsEnabled then
				stageWithWallsImage:draw(0, 0)
			else
				stageWithoutWallsImage:draw(0,0)
			end

			gfx.clearClipRect() -- clear so we don't interfere with drawing that comes after this
		end
	)

	-- Load main stage background music (this is also needed to start playing from the beginning)
	stageBgm:load("music/nik-watch-the-sound")
	-- Play and loop forever
	stageBgm:play(0)
end

function startGame()
	local titleScreenSprite = gfx.sprite.new(titleScreenImage)
	titleScreenSprite:moveTo(200, 120)
	titleScreenSprite:add()

	pressStart = PressStart()
	pressStart:moveTo(0, 160)
	pressStart:addSprite()

	menuBgm:load("music/game-song-2")
	menuBgm:play(0)
end

startGame()

function playdate.update()
	if gameState == "title" then
		titleStateUpdate()
	elseif gameState == "options" then
		optionsStateUpdate()
	elseif gameState == "play" then
		playStateUpdate()
	elseif gameState == "end" then
		endStateUpdate()
	end

	gfx.sprite.update()
	gfx.animation.blinker.updateAll()
	playdate.frameTimer.updateTimers()
	-- playdate.drawFPS(0,0)
end

function titleStateUpdate()
	if playdate.buttonJustPressed(playdate.kButtonA) then
		pressStart:blink()
		playdate.frameTimer.performAfterDelay(stateSwitchDelay, switchToOptionsState)
	end
end

function switchToOptionsState()
	gfx.sprite.removeAll()

	menuBgm:play(0)

	local backgroundSprite = gfx.sprite.new(optionsScreenImage)
	backgroundSprite:setCenter(0, 0)
	backgroundSprite:moveTo(0, 0)
	backgroundSprite:add()

	pressStart = PressStart()
	pressStart:moveTo(0, 176)
	pressStart:addSprite()

	if playerMoveInterval == nil then
		playerMoveInterval = speedSettingMap[speedSetting]
	end

	speed = Speed()
	speed:setSpeed(speedSetting)
	speed:select()
	speed:addSprite()

	walls = Walls()
	walls:setEnabled(wallsEnabled)
	walls:addSprite()

	gameState = "options"
end

function optionsStateUpdate()
	if playdate.buttonJustPressed(playdate.kButtonLeft) then
		if speed.selected == true and speedSetting > speedSettingMin then
			clickSound:play()
			speedSetting -= 1
			playerMoveInterval = speedSettingMap[speedSetting]
			speed:setSpeed(speedSetting)
		elseif walls.selected == true then
			clickSound:play()
			wallsEnabled = not wallsEnabled
			walls:toggle()
		end
	end

	if playdate.buttonJustPressed(playdate.kButtonRight) then
		if speed.selected == true and speedSetting < speedSettingMax then
			clickSound:play()
			speedSetting += 1
			playerMoveInterval = speedSettingMap[speedSetting]
			speed:setSpeed(speedSetting)
		elseif walls.selected == true then
			clickSound:play()
			wallsEnabled = not wallsEnabled
			walls:toggle()
		end
	end

	if playdate.buttonJustPressed(playdate.kButtonUp) or playdate.buttonJustPressed(playdate.kButtonDown) then
		if speed.selected == true then
			clickSound:play()
			speed:deselect()
			walls:select()
		elseif walls.selected == true then
			clickSound:play()
			speed:select()
			walls:deselect()
		end
	end

	if playdate.buttonJustPressed(playdate.kButtonA) then
		pressStart:blink()
		playdate.frameTimer.performAfterDelay(stateSwitchDelay, switchToPlayState)
	end
end

function switchToPlayState()
	menuBgm:stop()
	gameStartSound:play()
	clearGame()
	setUpGame()
	gameState = "play"
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
		-- Initialize coordinates for next snake segment at position of current head
		local nextCoordinates = {snakeCoordinates[1][1], snakeCoordinates[1][2]}
		local nextSprite = nil
		local nextSpriteImage = nil
		local tailSprite = nil

		-- TODO: Implement as switch statement, if possible?
		-- TODO: Reduce repetition for clickSound:play() logic
		if playerDirectionBuffer == "up" then
			if playerDirection ~= "up" then
				clickSound:play()
			end
			nextCoordinates[2] -= tileSize
			playerDirection = "up"
			nextSpriteImage = snakeHeadUpImage
		elseif playerDirectionBuffer == "right" then
			if playerDirection ~= "right" then
				clickSound:play()
			end
			nextCoordinates[1] += tileSize
			playerDirection = "right"
			nextSpriteImage = snakeHeadRightImage
		elseif playerDirectionBuffer == "down" then
			if playerDirection ~= "down" then
				clickSound:play()
			end
			nextCoordinates[2] += tileSize
			playerDirection = "down"
			nextSpriteImage = snakeHeadDownImage
		elseif playerDirectionBuffer == "left" then
			if playerDirection ~= "left" then
				clickSound:play()
			end
			nextCoordinates[1] -= tileSize
			playerDirection = "left"
			nextSpriteImage = snakeHeadLeftImage
		end

		-- Allow wrapping to the other side of the screen when walls are disabled
		if not wallsEnabled then
			if nextCoordinates[2] < 0 then
				nextCoordinates[2] += screenHeight
			elseif nextCoordinates[2] > screenHeight then
				nextCoordinates[2] -= screenHeight
			end
			if nextCoordinates[1] < 0 then
				nextCoordinates[1] += screenWidth
			elseif nextCoordinates[1] > screenWidth then
				nextCoordinates[1] -= screenWidth
			end
		end

		-- End the game if the player has collided with their tail
		if isCollidingWithSnake(nextCoordinates) then
			switchToEndState()
		end

		-- Add the new head coordinates
		table.insert(snakeCoordinates, 1, nextCoordinates)

		-- Position new head sprite and add to sprites array
		nextSprite = gfx.sprite.new(nextSpriteImage)
		nextSprite:moveTo(nextCoordinates[1], nextCoordinates[2])
		nextSprite:add()
		table.insert(snakeSprites, 1, nextSprite)

		-- Store the new direction
		table.insert(snakeDirections, 1, playerDirection)

		-- Update the second sprite from a head image to a body image
		updateSnakeHead()

		-- Check if player has eaten the food
		if snakeCoordinates[1][1] == foodSprite.x and snakeCoordinates[1][2] == foodSprite.y then
			foodSound:play()
			repositionFood()
			segmentsToGain = segmentsGainedWhenEating
			foodEatenCount += 1
		end

		if segmentsToGain == 0 then
			-- If the snake is not growing on this interval, we remove the last segment from the snake.
			table.remove(snakeCoordinates)
			table.remove(snakeDirections)
			-- Remove the current tail sprite from the array and from the display list
			tailSprite = table.remove(snakeSprites)
			tailSprite:remove()
			-- Update the new tail sprite from a body image to a tail image
			updateSnakeTail()
		else
			-- Otherwise don't remove the last segment, and decrement the counter.
			segmentsToGain -= 1
		end

		-- End the game if the player has collided with any of the four stage boundaries
		if wallsEnabled and isCollidingWithStage(snakeCoordinates[1]) then
			switchToEndState()
		end
	end
end

function switchToEndState()
	stageBgm:stop()
	gameOverSound:play()
	showGameOverScreen()
	gameState = "end"
	print("food eaten: " .. foodEatenCount)
end

function showGameOverScreen()
	local gameOverSprite = gfx.sprite.new(gameOverImage)
	gameOverSprite:moveTo(200, 120)
	gameOverSprite:setZIndex(1) -- Ensure this is above the snake
	gameOverSprite:add()

	foodEaten = FoodEaten()
	foodEaten:setCount(foodEatenCount)
	foodEaten:addSprite()
end

function endStateUpdate()
	if playdate.buttonJustPressed(playdate.kButtonB) then
		gameOverSound:stop()
		switchToOptionsState()
	end
	if playdate.buttonJustPressed(playdate.kButtonA) then
		gameOverSound:stop()
		switchToPlayState()
	end
end
