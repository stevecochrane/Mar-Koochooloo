import "CoreLibs/animation"
import "CoreLibs/frameTimer"
import "CoreLibs/graphics"
import "CoreLibs/object"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import "creditsState"
import "endState"
import "nextLevelState"
import "optionsState"
import "playState"
import "systemMenu"
import "tilemap"
import "titleState"
import "winState"

local gfx <const> = playdate.graphics
local snd <const> = playdate.sound

-- Store how many pieces of food are eaten per game
foodEatenCount = nil

-- TODO: Implement as enum if possible?
-- Possible values are "title", "options", "play", "end"
gameState = "title"

-- Initialize music
menuBgm = snd.fileplayer.new()
stageBgm = snd.fileplayer.new()

-- Initialize sound effects
clickSound = snd.sampleplayer.new("sound/click")
gameStartSound = snd.sampleplayer.new("sound/game-start")

-- Length of time in milliseconds for switching from state to state
stateSwitchAnimationDuration = 1800
stateSwitchPauseDuration = 600
stateSwitchFullDuration = stateSwitchAnimationDuration + stateSwitchPauseDuration
stateSwitchFullDurationSeconds = stateSwitchFullDuration / 1000
stateSwitchInProgress = false

currentLevel = 1

-- This is configurable in the options screen. Can be either "speed" or "puzzle".
mode = "speed"

-- This is what is displayed to the user for their difficulty setting.
difficultySetting = 1
-- This is the mapping between the above two values.
difficultySpeedMap = {19, 17, 15, 13, 11, 9, 7, 5, 3, 1}
difficultyPuzzleMap = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}
difficultyMin = 1
difficultyMax = 10
-- The player will move every time the frameTimer hits this number.
-- Declaring it here also lets us change it later.
playerMoveInterval = difficultySpeedMap[difficultySetting]

-- We'll check this on every frame to determine if it's time to move.
moveTimer = nil

-- Set the background color to black, as the default is white.
gfx.setBackgroundColor(gfx.kColorBlack)

-- Start by initializing the title screen.
TitleState:switch()

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
	-- playdate.drawFPS(0,0)
end
