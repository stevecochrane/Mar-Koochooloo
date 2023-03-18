local gfx <const> = playdate.graphics

WinState = {}

function WinState:switch()
	stateSwitchInProgress = false
	gameState = "win"

	stageBgm:stop()
end

function WinState:update()
	if stateSwitchInProgress == false then
		if playdate.buttonJustPressed(playdate.kButtonA) then
			gfx.sprite.removeAll()
			currentLevel = 1
			stateSwitchInProgress = true
			playdate.timer.performAfterDelay(stateSwitchPauseDuration, switchToOptionsState)
		end
	end
end
