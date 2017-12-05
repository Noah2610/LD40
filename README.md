### The more people there are, the worse the planet is doing.
### And also the worse the game laggs.
---
## Gameplay
You are *Mother Earth* and you have a disease: **Humans**  
Try to rid yourself of the infestation with Tornadoes and Earthquakes.

**Tornadoes** can be activated in the **top right corner**; the arrows indicate the width of the tornado.  
They are great for killing all humans who are in the area.

**Earthquakes** are triggered by clicking on the **gray bars at the bottom**.  
They can destroy buildings which are spawned by groups of humans.

## Controls
| Key                           | Action                |
| ----------------------------- | --------------------- |
| **A**, **H**, **left_arrow**  | move camera **left**  |
| **D**, **L**, **right_arrow** | move camera **right** |
| **Q**                         | **quit** the game     |

Otherwise use the mouse to click on the above mentioned sections.

## Win / Lose conditions
There are win and lose conditions in the game, although triggering them is the difficult part.  
The game is not balanced correctly at all.
#### Win condition
Kill all humans.
#### Lose condition
You lose when the map is filled with buildings (which will never happen, due to a bunch of issues).


## Tools used
| Tool        |                   |
| ----------- | ----------------- |
| **vim**     | Code editor       |
| **termite** | Terminal emulator |
| **Gimp**    | Graphics          |
| **git**     | Version control   |

---

## Development Info
The Game is written in [Ruby](https://www.ruby-lang.org/) version 2.4.2 using the [Gosu](https://www.libgosu.org/) game library.
It should work with Ruby version 2.1.9 and up though.

Sadly we couldn't implemented all the features (and almost no textures) we had planned to, I still wanted to upload it though because it was our first **Ludum Dare**.
We had a lot more plans for it but I wasn't able to implement it all, and my partner wasn't able to finish all the textures, so you mainly get placeholder textures.  

I still had a lot of fun making this game.  
Hopefully I can use what I have learned in this jam to create a better (and finished) product next time.

I hope at least some of you will have some fun fooling around with the (terrible) mechanics and watching those puny little humans get swirled around in tornadoes which will lead to their inevitable deaths.

---

## Installation
### Windows
Download and extract the provided [.zip file](https://github.com/Noah2610/LD40/archive/1.1_LD-release.zip), and run LD.exe from inside the directory.  

---

If you are having problems running the executable I recommend skipping this game and just move on to better entries.
If you are *that* determined to play this game, you can install the necessary packages and libraries manually:  
Install the *Ruby Interpreter* from https://www.ruby-lang.org/ (version 2.1.9 and up should work fine) and run  
`bundle install` inside the game directory. When it finishes you should be able to run the game with  
`./LD40.rb` or `ruby ./LD40.rb`.  
If there are still issues you might be missing some libraries used by Gosu.  
Check https://www.libgosu.org/ for more information.

### Linux / MacOS
Either use *wine* to run the windows executable or install *Ruby* and *Gosu*:
#### Ubuntu (and Debian derivatives)
```
$ # Install the Ruby interpreter and Gosu's dependencies:
$ sudo apt update && sudo apt install ruby build-essential libsdl2-dev libsdl2-ttf-dev libpango1.0-dev libgl1-mesa-dev libopenal-dev libsndfile-dev libmpg123-dev libgmp-dev
$ # Install Gosu:
$ gem install gosu
```

#### Arch Linux
```
$ # Install the Ruby interpreter and Gosu's dependencies:
$ sudo pacman -Sy ruby openal pango sdl2 sdl2_ttf libsndfile pkg-config mpg123
$ gem install gosu
```

Or use your distribution's package manager.

#### MacOS
Best you follow the steps on https://github.com/gosu/gosu/wiki/Getting-Started-on-OS-X  
But you can try:
```
$ gem install gosu
```
As far as I know, the Ruby Interpreter comes pre-installed on MacOS.


## Credits
**Coding / concept** - @noahro  
**Concept** - @hoichael  (Originally also worked on graphics, but we discarded those because we couldn't finish them in time.)
