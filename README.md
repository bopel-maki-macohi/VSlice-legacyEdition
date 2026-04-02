# VSlice: Legacy Edition

This is the repository for VSlice Legacy Edition, FNF if they release the update ontime.

IF YOU MAKE A MOD AND DISTRIBUTE A MODIFIED / RECOMPILED VERSION, YOU MUST OPEN SOURCE YOUR MOD AS WELL

## Build instructions

Do note that I am on windows so uh, yeah no I can't really test mac and linux...

### Getting the code and installing the libraries

1. Install [Haxe](https://haxe.org/download).
2. Install [Git](https://www.git-scm.com).
3. Run `git clone https://github.com/bopel-maki-macohi/VSlice-legacyEdition.git` from the folder where you want to store the repository. (Or download the repo ZIP)
4. Run `cd VSlice-legacyEdition`.
5. Run `haxelib --global install hxpkg` and `haxelib --global run hxpkg setup`.
6. Run `hxpkg install --force`.
7. Run `haxelib run lime setup`.

### Additional Platform Setup

Windows:

1. Install [Visual Studio Build Tools](https://aka.ms/vs/17/release/vs_BuildTools.exe).
2. Select "Individual Components" when prompted during the Build Tools installation process and install the following:
    - MSVC v143 VS 2022 C++ x64/x86 build tools.
    - Windows 10/11 SDK.

### Compiling

NOTE: If you see any messages relating to deprecated packages, ignore them. They're just warnings that don't affect compiling

- Run `lime test <platform>` to compile the game.
- Run `lime run <platform>` if you want to relaunch the game.

You should have everything ready for compiling the game! Follow the guide below to continue!

## Credits / shoutouts

- [FunkinCrew](https://github.com/FunkinCrew) - Made the game.

- [Maki](https://github.com/bopel-maki-macohi) - Programming
- [Hunter Under](https://www.youtube.com/@UnderHunter1) - Art
- Nikodeg - Art

This game was made with love to Newgrounds and its community. Extra love to Tom Fulp.