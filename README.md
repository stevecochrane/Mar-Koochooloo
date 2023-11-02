# Mar Koochooloo

Mar Koochooloo (that's "little snake" in Farsi) is an iteration of the
[snake game](https://en.wikipedia.org/wiki/Snake_(video_game_genre)) for
[Playdate](https://play.date) with ten levels and a "gentle" mode for new
players.

I created the game for my daughter Darya and collaborated with my extremely
talented nephew who creates music as
[KSVR](https://www.youtube.com/@behgolbb202). He made the music and sound
effects with GarageBand on his grandfather's old iPhone and was just 8 years
old at the time. The music is easily the best part of the game.

## How this was made

Mar Koochooloo was programmed in Lua with the
[Playdate SDK](https://play.date/dev/). The developer experience on Playdate is
excellent and everything went really smoothly for me. If you want to make a
game for a gaming console and not just for PC, this is about as straightforward
as it gets.

The in-game fonts are Roobert 11 Medium and Roobert 10 Bold, both of which are
included as part of the Playdate SDK.

The tilemaps were made in [Tiled](https://www.mapeditor.org), the pixel art
was made with [Acorn](https://flyingmeat.com/acorn/) and the code was written
in [Visual Studio Code](https://code.visualstudio.com). The simpler sound
effects were made with [jsfxr](https://sfxr.me).

## State of the code

This project is definitely not my best work from a code perspective, though I
don't intend to maintain this project or continue to build upon it after the
intial release, so code maintainability was not much of a concern. It maintains
a steady 30 FPS no matter what you do, which is the maximum frame rate for a
Lua game, so there are no performance issues.

I've structured this similarly to my old
[Flixel](https://lib.haxe.org/p/flixel) projects from a decade ago, where there
are different state objects (playState, titleState, etc.) representing every
possible state that the game can be in at any given time, and on every frame of
the game in the main `playdate.update()` function it will look to the current
state and call the matching function. `playState` still does too much and would
be broken up further if I was to keep working on this.

If you want to read the code from the beginning, the main.lua file is the first
file to be executed when running the game.
