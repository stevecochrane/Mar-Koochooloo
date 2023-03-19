import "foodEaten"

local gfx <const> = playdate.graphics
local snd <const> = playdate.sound

local gameOverSound = snd.sampleplayer.new("sound/game-over")

EndState = {}

function EndState:switch()
	stateSwitchInProgress = false
	gameState = "end"

	stageBgm:stop()
	gameOverSound:play()

	local gameOverImage = gfx.image.new("images/game-over")
	local gameOverSprite = gfx.sprite.new(gameOverImage)
	gameOverSprite:moveTo(200, 120)
	gameOverSprite:setZIndex(1) -- Ensure this is above the snake
	gameOverSprite:add()

	foodEaten = FoodEaten()
	foodEaten:setCount(foodEatenCount)
	foodEaten:addSprite()
end

function EndState:update()
	if stateSwitchInProgress == false then
		if playdate.buttonJustPressed(playdate.kButtonB) then
			gameOverSound:stop()
			gfx.sprite.removeAll()
			stateSwitchInProgress = true
			playdate.timer.performAfterDelay(stateSwitchPauseDuration, OptionsState.switch)
		end

		if playdate.buttonJustPressed(playdate.kButtonA) then
			gameOverSound:stop()
			gfx.sprite.removeAll()
			stateSwitchInProgress = true
			playdate.timer.performAfterDelay(stateSwitchPauseDuration, switchToPlayState)
		end
	end
end
