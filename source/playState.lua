local gfx <const> = playdate.graphics
local snd <const> = playdate.sound

local screenWidth = playdate.display.getWidth()
local screenHeight = playdate.display.getHeight()

-- Size of each tile on the board (and snake segment, and food)
local tileSize = 16

-- Here's our sprite declarations. We'll scope them to this file because
-- several functions need to access them.
local playerSprite = nil
local foodSprite = nil

-- Initialize images
local foodImage = gfx.image.new("images/apple")
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
local wallImage = gfx.image.new("images/wall")

-- Initialize sound effects
local foodSound = snd.sampleplayer.new("sound/power-up")
local turnSound = snd.sampleplayer.new("sound/turn")

-- TODO: Implement as enum if possible?
-- Possible values are "up", "right", "down", and "left"
local playerDirection = nil
local playerDirectionBuffer = nil

-- Stores coordinates (e.g. {x, y}) for each segment of the snake.
local snakeCoordinates = nil

-- Stores sprites for each segment of the snake.
local snakeSprites = nil

-- Stores the direction the snake was traveling in for each segment of the snake.
local snakeDirections = nil

-- This may be customizeable later.
local startingSnakeSegments = 3

-- This is internally configurable for testing.
local segmentsGainedWhenEating = nil
local segmentsGainedWhenEatingSpeedDefault = 3
local segmentsToGain = 0

local wallSpriteCoordinates = nil

local lastLevel = 8
local foodGoal = 10
local foodRemaining = nil

local justPressedButton = false

local directionHeldTimer = nil

PlayState = {}

function PlayState:isCollidingWithSnake(coordinates)
	local collided = false

	for i = 1, #snakeCoordinates do
		if snakeCoordinates[i][1] == coordinates[1] and snakeCoordinates[i][2] == coordinates[2] then
			collided = true
			break
		end
	end

	return collided
end

function PlayState:isCollidingWithStage(coordinates)
	local collided = false

	for i = 1, #wallSpriteCoordinates do
		if wallSpriteCoordinates[i][1] == coordinates[1] and wallSpriteCoordinates[i][2] == coordinates[2] then
			collided = true
			break
		end
	end

	return collided
end

function PlayState:repositionFood()
	local newX = nil
	local newY = nil
	local hasCollidedWithSnake = nil
	local hasCollidedWithStage = nil

	repeat
		newX = math.random(0, screenWidth - 1)
		newY = math.random(0, screenHeight - 1)

		-- Round down to a multiple of tileSize
		newX = newX - (newX % tileSize)
		newY = newY - (newY % tileSize)

		-- Check if new food position collides with any part of snake or stage
		hasCollidedWithSnake = PlayState:isCollidingWithSnake({newX, newY})
		hasCollidedWithStage = PlayState:isCollidingWithStage({newX, newY})

	-- Repeat the above until the food is not on the same tile as the player
	until hasCollidedWithSnake == false and hasCollidedWithStage == false

	-- We have our new food position, move food sprite there
	foodSprite:moveTo(newX, newY)
end

function PlayState:updateSnakeHead()
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

function PlayState:updateSnakeTail()
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

function PlayState:buttonIsHeld()
	print('button held')
end

-- A function to set up our game environment.
function PlayState:setUpGame()
	-- (Re-)initialize snake arrays
	snakeCoordinates = {}
	snakeSprites = {}
	snakeDirections = {}

	-- (Re-)intialize player direction
	playerDirection = "right"
	playerDirectionBuffer = playerDirection

	-- Reinitialize move timer
	moveTimer = playdate.frameTimer.new(playerMoveInterval)
	moveTimer.repeats = true

	-- (Re-)initialize other variables
	foodEatenCount = 0
	segmentsToGain = 0
	wallSpriteCoordinates = {}
	foodRemaining = foodGoal

	if mode == "speed" then
		segmentsGainedWhenEating = segmentsGainedWhenEatingSpeedDefault
	else
		segmentsGainedWhenEating = difficultyPuzzleMap[difficultySetting]
	end

	local levelData = Tilemap:loadLevelJsonData("tilemaps/level-" .. currentLevel .. ".json")
	local wallLocations = Tilemap:getWallLocations(levelData)
	local snakeSpawnLocation = Tilemap:getSnakeSpawnLocation(levelData)
	local startingX = snakeSpawnLocation[1]
	local startingY = snakeSpawnLocation[2]

	for i = 1, #wallLocations do
		local wallSprite = gfx.sprite.new(wallImage)
		local wallSpriteX = wallLocations[i][1]
		local wallSpriteY = wallLocations[i][2]
		wallSprite:setCenter(0, 0)
		wallSprite:moveTo(wallSpriteX, wallSpriteY)
		wallSprite:add()
		table.insert(wallSpriteCoordinates, {wallSpriteX, wallSpriteY})
	end

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
		playerSprite:setCenter(0, 0)
		playerSprite:moveTo(startingX, startingY)
		playerSprite:add()
		table.insert(snakeSprites, playerSprite)

		-- Add direction for each segment to snakeDirections
		table.insert(snakeDirections, playerDirection)

		-- Decrement startingX to put next segment one tile behind
		startingX -= tileSize
	end

	-- Add food sprite. Note this needs to happen after walls are added! If food is added first,
	-- then a wall might be added on top of the food, making the game unwinnable.
	foodSprite = gfx.sprite.new(foodImage)
	foodSprite:setCenter(0, 0)
	PlayState:repositionFood()
	foodSprite:add()

	-- Load main stage background music (this is also needed to start playing from the beginning)
	if music == "one" then
		stageBgm:load("music/one-bgm")
	else
		stageBgm:load("music/two-bgm")
	end
	stageBgm:setVolume("0.75")
	-- Play and loop forever
	stageBgm:play(0)
end

function PlayState:switch()
	stateSwitchInProgress = false
	gameState = "play"

	menuBgm:stop()
	SystemMenu:addItems()
	PlayState:setUpGame()
end

-- justPressed: reset the frameTimer to 0 along with the stuff you’re already doing
-- When the timer reaches a certain value, turn on an auto-move variable that gets the snake moving on an interval
-- justReleased: set the timer to 0 and turn off the auto-move variable
function PlayState:update()
	if playdate.buttonJustPressed(playdate.kButtonUp) then
		if playerDirection ~= "down" then
			clickSound:play()
			playerDirectionBuffer = "up"
			justPressedButton = true
			if mode == "puzzle" then
				directionHeldTimer = playdate.frameTimer.new(30, PlayState.buttonIsHeld)
			end
		end
	elseif playdate.buttonJustPressed(playdate.kButtonRight) then
		if playerDirection ~= "left" then
			clickSound:play()
			playerDirectionBuffer = "right"
			justPressedButton = true
			if mode == "puzzle" then
				directionHeldTimer = playdate.frameTimer.new(30, PlayState.buttonIsHeld)
			end
		end
	elseif playdate.buttonJustPressed(playdate.kButtonDown) then
		if playerDirection ~= "up" then
			clickSound:play()
			playerDirectionBuffer = "down"
			justPressedButton = true
			if mode == "puzzle" then
				directionHeldTimer = playdate.frameTimer.new(30, PlayState.buttonIsHeld)
			end
		end
	elseif playdate.buttonJustPressed(playdate.kButtonLeft) then
		if playerDirection ~= "right" then
			clickSound:play()
			playerDirectionBuffer = "left"
			justPressedButton = true
			if mode == "puzzle" then
				directionHeldTimer = playdate.frameTimer.new(30, PlayState.buttonIsHeld)
			end
		end
	end

	if mode == "puzzle" then
		if playdate.buttonJustReleased(playdate.kButtonUp) or playdate.buttonJustReleased(playdate.kButtonDown) or playdate.buttonJustReleased(playdate.kButtonLeft) or playdate.buttonJustReleased(playdate.kButtonRight) then
			directionHeldTimer:pause()
		end
	end

	if ((mode == "speed" and moveTimer.frame == playerMoveInterval) or (mode == "puzzle" and justPressedButton == true)) then
		-- Initialize coordinates for next snake segment at position of current head
		local nextCoordinates = {snakeCoordinates[1][1], snakeCoordinates[1][2]}
		local nextSprite = nil
		local nextSpriteImage = nil
		local tailSprite = nil

		-- TODO: Implement as switch statement, if possible?
		-- TODO: Reduce repetition for turnSound:play() logic
		if playerDirectionBuffer == "up" then
			if playerDirection ~= "up" then
				turnSound:play()
			end
			nextCoordinates[2] -= tileSize
			playerDirection = "up"
			nextSpriteImage = snakeHeadUpImage
		elseif playerDirectionBuffer == "right" then
			if playerDirection ~= "right" then
				turnSound:play()
			end
			nextCoordinates[1] += tileSize
			playerDirection = "right"
			nextSpriteImage = snakeHeadRightImage
		elseif playerDirectionBuffer == "down" then
			if playerDirection ~= "down" then
				turnSound:play()
			end
			nextCoordinates[2] += tileSize
			playerDirection = "down"
			nextSpriteImage = snakeHeadDownImage
		elseif playerDirectionBuffer == "left" then
			if playerDirection ~= "left" then
				turnSound:play()
			end
			nextCoordinates[1] -= tileSize
			playerDirection = "left"
			nextSpriteImage = snakeHeadLeftImage
		end

		-- Allow wrapping to the other side of the screen
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

		-- Position new head sprite and add to sprites array
		nextSprite = gfx.sprite.new(nextSpriteImage)
		nextSprite:setCenter(0, 0)
		nextSprite:moveTo(nextCoordinates[1], nextCoordinates[2])
		nextSprite:add()
		table.insert(snakeSprites, 1, nextSprite)

		-- Store the new direction
		table.insert(snakeDirections, 1, playerDirection)

		-- Update the second sprite from a head image to a body image
		PlayState:updateSnakeHead()

		-- Check if player has eaten the food
		if nextCoordinates[1] == foodSprite.x and nextCoordinates[2] == foodSprite.y then
			foodRemaining -= 1
			print("foodRemaining " .. foodRemaining)

			if foodRemaining == 0 then
				foodSprite:remove()
			else
				foodSound:play()
				PlayState:repositionFood()
			end

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
			PlayState:updateSnakeTail()
		else
			-- Otherwise don't remove the last segment, and decrement the counter.
			segmentsToGain -= 1
		end

		-- End the game if the player has collided with their tail.
		-- It's important to check this before nextCoordinates is added to snakeCoordinates,
		-- and after the previous tail segment is removed from snakeCoordinates.
		if PlayState:isCollidingWithSnake(nextCoordinates) then
			EndState:switch()
			return
		end

		-- Add the new head coordinates
		table.insert(snakeCoordinates, 1, nextCoordinates)

		-- End the stage if the player has eaten enough food to meet the goal
		if foodRemaining == 0 then
			if currentLevel == lastLevel then
				WinState:switch()
			else
				currentLevel += 1
				NextLevelState:switch()
			end
			return
		end

		-- End the stage if the player has collided with any of the walls
		if PlayState:isCollidingWithStage(snakeCoordinates[1]) then
			EndState:switch()
		end
	end

	justPressedButton = false
end
