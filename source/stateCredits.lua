import "creditsText"

local gfx <const> = playdate.graphics

StateCredits = {}

function StateCredits:switch()
	stateSwitchInProgress = false
	gameState = "credits"

	local creditsText = CreditsText()
	creditsText:addSprite()
end

function StateCredits:update()
	if stateSwitchInProgress == false and (playdate.buttonJustPressed(playdate.kButtonA) or playdate.buttonJustPressed(playdate.kButtonB)) then
		gfx.sprite.removeAll()
		stateSwitchInProgress = true
		playdate.timer.performAfterDelay(stateSwitchPauseDuration, startGame)
	end
end
