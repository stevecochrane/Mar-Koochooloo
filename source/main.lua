import "CoreLibs/animation"
import "CoreLibs/frameTimer"
import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "creditsState"
import "endState"
import "globals"
import "nextLevelState"
import "optionsState"
import "playState"
import "systemMenu"
import "tilemap"
import "titleState"
import "winState"

local gfx <const> = playdate.graphics

-- Set the background color to black and draw color to white.
gfx.setBackgroundColor(gfx.kColorBlack)
gfx.setColor(gfx.kColorWhite)

-- Set the default font to Roobert 11 Medium
gfx.setFont(Roobert11Medium)

-- Start by initializing the title screen.
TitleState:switch()

-- The following function is executed on every frame.
function playdate.update()
	if gameState == "title" then
		TitleState:update()
	elseif gameState == "credits" then
		CreditsState:update()
	elseif gameState == "options" then
		OptionsState:update()
	elseif gameState == "play" then
		PlayState:update()
	elseif gameState == "nextLevel" then
		NextLevelState:update()
	elseif gameState == "win" then
		WinState:update()
	elseif gameState == "end" then
		EndState:update()
	end

	gfx.sprite.update()
	gfx.animation.blinker.updateAll()
	playdate.frameTimer.updateTimers()
	playdate.timer.updateTimers()

	-- Uncomment to view frame rate while playing.
	-- playdate.drawFPS(0,0)
end
