# Mar Koochooloo

Mar Koochooloo (that's "little snake" in Farsi) is an iteration of the
[snake game](https://en.wikipedia.org/wiki/Snake_(video_game_genre)) for
[Playdate](https://play.date) with nine levels and a "gentle" mode for new
players.

<img src="https://raw.githubusercontent.com/stevecochrane/Mar-Koochooloo/main/screenshots/title-screen-2x.png" alt="Mar Koochooloo title screen" width="400" height="240" />

<img src="https://raw.githubusercontent.com/stevecochrane/Mar-Koochooloo/main/screenshots/options-screen-2x.png" alt="Options screen" width="400" height="240" />

<img src="https://raw.githubusercontent.com/stevecochrane/Mar-Koochooloo/main/screenshots/first-stage-2x.png" alt="Snake in the first stage" width="400" height="240" />

<img src="https://raw.githubusercontent.com/stevecochrane/Mar-Koochooloo/main/screenshots/early-stage-2x.png" alt="Snake in an early stage" width="400" height="240" />

<img src="https://raw.githubusercontent.com/stevecochrane/Mar-Koochooloo/main/screenshots/zig-zag-2x.png" alt="Snake zig-zagging in staircase pattern" width="400" height="240" />

<img src="https://raw.githubusercontent.com/stevecochrane/Mar-Koochooloo/main/screenshots/level-clear-2x.png" alt="Level Clear screen" width="400" height="240" />

<img src="https://raw.githubusercontent.com/stevecochrane/Mar-Koochooloo/main/screenshots/screen-wrap-2x.png" alt="Snake wrapping around the screen" width="400" height="240" />

<img src="https://raw.githubusercontent.com/stevecochrane/Mar-Koochooloo/main/screenshots/credits-screen-2x.png" alt="Credits screen" width="400" height="240" />

I created the game for my daughter Darya and collaborated with my extremely
talented nephew who creates music as
[KSVR](https://www.youtube.com/@behgolbb202). He made the music and sound
effects with GarageBand on his grandfather's old iPhone and was just 8 years
old at the time. The music is easily the best part of the game.

There are many versions of the snake game, but this is most inspired by QBasic
Nibbles, which you can now miraculously
[play through your web browser](https://archive.org/details/NibblesQbasic)
thanks to the wizards at the Internet Archive. Nibbles is special to me because
it's one of two games that came with QBasic and one of the first games I began
to tinker with when my grandfather introduced me to programming. Most of the
level layouts in Mar Koochooloo are adopted from Nibbles.

## How this was made

Mar Koochooloo was programmed in Lua with the
[Playdate SDK](https://play.date/dev/). The developer experience on Playdate is
excellent and everything went really smoothly for me. If you want to make a
game for a gaming console and not just for PC, this is about as straightforward
as it gets.

The in-game fonts are Roobert 11 Medium and Roobert 10 Bold, both of which are
included in the Playdate SDK.

The tilemaps were made in [Tiled](https://www.mapeditor.org), the pixel art
was made with [Acorn](https://flyingmeat.com/acorn/) and the code was written
in [Visual Studio Code](https://code.visualstudio.com). The simpler sound
effects were made with [jsfxr](https://sfxr.me).

## State of the code

This project is definitely not my best work from a code perspective, though I
don't intend to maintain this project or continue to build upon it after the
intial release, so code maintainability was not much of a concern. It runs at a
steady 30 frames per second no matter what you do, which is the maximum frame
rate for a Lua game, so there are no performance issues.

I've structured this similarly to my old
[Flixel](https://lib.haxe.org/p/flixel) projects from a decade ago, where there
are different state objects (playState, titleState, etc.) representing every
possible state that the game can be in at any given time, and on every frame of
the game in the main `playdate.update()` function it will look to the current
state and call the matching function. `playState` still does too much and would
be broken up further if I was to keep working on this.

If you want to read from the beginning, the main.lua file is the first file to
be executed when running the game.
