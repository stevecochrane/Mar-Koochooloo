local gfx <const> = playdate.graphics

local level1ClearImage = gfx.image.new("images/level-1-clear")
local level2ClearImage = gfx.image.new("images/level-2-clear")
local level3ClearImage = gfx.image.new("images/level-3-clear")
local level4ClearImage = gfx.image.new("images/level-4-clear")
local level5ClearImage = gfx.image.new("images/level-5-clear")
local level6ClearImage = gfx.image.new("images/level-6-clear")
local level7ClearImage = gfx.image.new("images/level-7-clear")
local level8ClearImage = gfx.image.new("images/level-8-clear")

local level1ClearGentleImage = gfx.image.new("images/level-1-clear-gentle")
local level2ClearGentleImage = gfx.image.new("images/level-2-clear-gentle")
local level3ClearGentleImage = gfx.image.new("images/level-3-clear-gentle")
local level4ClearGentleImage = gfx.image.new("images/level-4-clear-gentle")
local level5ClearGentleImage = gfx.image.new("images/level-5-clear-gentle")
local level6ClearGentleImage = gfx.image.new("images/level-6-clear-gentle")
local level7ClearGentleImage = gfx.image.new("images/level-7-clear-gentle")
local level8ClearGentleImage = gfx.image.new("images/level-8-clear-gentle")

NextLevelState = {}

function NextLevelState:switch()
	stateSwitchInProgress = false
	gameState = "nextLevel"

	gameStartSound:play()

	local levelClearSprite = nil

	if mode == "classic" then
		if currentLevel == 1 then
			levelClearSprite = gfx.sprite.new(level1ClearImage)
		elseif currentLevel == 2 then
			levelClearSprite = gfx.sprite.new(level2ClearImage)
		elseif currentLevel == 3 then
			levelClearSprite = gfx.sprite.new(level3ClearImage)
		elseif currentLevel == 4 then
			levelClearSprite = gfx.sprite.new(level4ClearImage)
		elseif currentLevel == 5 then
			levelClearSprite = gfx.sprite.new(level5ClearImage)
		elseif currentLevel == 6 then
			levelClearSprite = gfx.sprite.new(level6ClearImage)
		elseif currentLevel == 7 then
			levelClearSprite = gfx.sprite.new(level7ClearImage)
		elseif currentLevel == 8 then
			levelClearSprite = gfx.sprite.new(level8ClearImage)
		end
	else
		if currentLevel == 1 then
			levelClearSprite = gfx.sprite.new(level1ClearGentleImage)
		elseif currentLevel == 2 then
			levelClearSprite = gfx.sprite.new(level2ClearGentleImage)
		elseif currentLevel == 3 then
			levelClearSprite = gfx.sprite.new(level3ClearGentleImage)
		elseif currentLevel == 4 then
			levelClearSprite = gfx.sprite.new(level4ClearGentleImage)
		elseif currentLevel == 5 then
			levelClearSprite = gfx.sprite.new(level5ClearGentleImage)
		elseif currentLevel == 6 then
			levelClearSprite = gfx.sprite.new(level6ClearGentleImage)
		elseif currentLevel == 7 then
			levelClearSprite = gfx.sprite.new(level7ClearGentleImage)
		elseif currentLevel == 8 then
			levelClearSprite = gfx.sprite.new(level8ClearGentleImage)
		end
	end

	levelClearSprite:moveTo(200, 120)
	levelClearSprite:setZIndex(1) -- Ensure this is above the snake
	levelClearSprite:add()
end

function NextLevelState:update()
	if stateSwitchInProgress == false then
		if playdate.buttonJustPressed(playdate.kButtonA) then
			gfx.sprite.removeAll()
			stateSwitchInProgress = true
			playdate.timer.performAfterDelay(stateSwitchPauseDuration, PlayState.switch)

			currentLevel += 1
		end
	end
end
