local gfx <const> = playdate.graphics
local snd <const> = playdate.sound

-- Initialize Roobert 11 Medium which will be the default font
Roobert11Medium = gfx.font.new('Fonts/Roobert-11-Medium')

-- Store how many pieces of food are eaten per game
foodEatenCount = nil

-- Number of food needed to clear a level
foodGoal = 9

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

-- This is configurable in the options screen. Possible values are "classic", "gentle"
mode = "classic"

-- This is also configurable in the options screen. Can be either 1, 2, or 3.
music = 1

-- This is what is displayed to the user for their speed setting.
speedSetting = 1
-- This is the mapping between the above two values.
speedMap = {19, 17, 15, 13, 11, 9, 7, 5, 3, 1}
speedMin = 1
speedMax = 10
-- The player will move every time the frameTimer hits this number.
-- Declaring it here also lets us change it later.
playerMoveInterval = speedMap[speedSetting]
gentlePlayerMoveInterval = 3

-- We'll check this on every frame to determine if it's time to move.
moveTimer = nil
