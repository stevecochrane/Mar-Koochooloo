local gfx <const> = playdate.graphics
local snd <const> = playdate.sound

-- Initialize Roobert 11 Medium which will be the default font
Roobert11Medium = gfx.font.new('Fonts/Roobert-11-Medium')

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

-- This is configurable in the options screen. Can be either "classic" or "manual".
control = "classic"

-- This is also configurable in the options screen. Can be either "one" or "two".
music = "one"

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
puzzlePlayerMoveInterval = 5

-- We'll check this on every frame to determine if it's time to move.
moveTimer = nil
