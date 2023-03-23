local gfx <const> = playdate.graphics

NextLevelState = {}

function NextLevelState:switch()
	stateSwitchInProgress = false
	gameState = "nextLevel"

	gameStartSound:play()
end

function NextLevelState:update()
	if stateSwitchInProgress == false then
		if playdate.buttonJustPressed(playdate.kButtonA) then
			gfx.sprite.removeAll()
			stateSwitchInProgress = true
			playdate.timer.performAfterDelay(stateSwitchPauseDuration, PlayState.switch)
		end
	end
end
