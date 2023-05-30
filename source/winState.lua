local gfx <const> = playdate.graphics

WinState = {}

function WinState:switch()
	stateSwitchInProgress = false
	gameState = "win"

	stageBgm:stop()

	local winStateTextImage = gfx.image.new("images/win-state-text")
	local winStateTextSprite = gfx.sprite.new(winStateTextImage)
	winStateTextSprite:moveTo(200, 120)
	winStateTextSprite:setZIndex(1) -- Ensure this is above the snake
	winStateTextSprite:add()
end

function WinState:update()
	if stateSwitchInProgress == false then
		if playdate.buttonJustPressed(playdate.kButtonA) then
			gfx.sprite.removeAll()
			currentLevel = 1
			stateSwitchInProgress = true
			playdate.timer.performAfterDelay(stateSwitchPauseDuration, OptionsState.switch)
		end
	end
end
