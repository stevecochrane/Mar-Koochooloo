local gfx <const> = playdate.graphics

StateCredits = {}

function StateCredits:switch()
	stateSwitchInProgress = false
	gameState = "credits"
end

function StateCredits:update()
	if stateSwitchInProgress == false and playdate.buttonJustPressed(playdate.kButtonA) then
		gfx.sprite.removeAll()
		stateSwitchInProgress = true
		playdate.timer.performAfterDelay(stateSwitchPauseDuration, startGame)
	end
end
