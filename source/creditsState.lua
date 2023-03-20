import "creditsText"

local gfx <const> = playdate.graphics

CreditsState = {}

function CreditsState:switch()
	stateSwitchInProgress = false
	gameState = "credits"

	local creditsText = CreditsText()
	creditsText:addSprite()
end

function CreditsState:update()
	if stateSwitchInProgress == false and (playdate.buttonJustPressed(playdate.kButtonA) or playdate.buttonJustPressed(playdate.kButtonB)) then
		gfx.sprite.removeAll()
		stateSwitchInProgress = true
		playdate.timer.performAfterDelay(stateSwitchPauseDuration, TitleState.switch)
	end
end
