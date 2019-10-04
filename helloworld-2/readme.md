# Helloworld 2 1980s style

This project containes nativve Commodore 64 asembly language for a 1980's
style "hello world" program. It is part of the [Retrodevops project][retrodevops] that aims to prove any technology can be made better with a little DevOps.
The code itself is based on the excellent C64 demo coding tutorials found at [http://tnd64.unikat.sk](http://tnd64.unikat.sk)

## See a demo

If you just want to see it in action jump over to the [Retrodevops Online C64][[online-c64]] and use the drop down list to select an image that looks like "hello2-vxx.d64" and the click "Load and Play".
If you don't hear any sound click on "Controls" and make sure sound is enabled.

![Web Based Commodore 64 emulator](docs/webemulator.png "Web Based Commodore 64 emulator")

## Requirements

The easiest way to build the solution is using [Visual Studio Code][vs-code-link] and requires the following tools to be installed and added to your PATH.

1. [ACME Cross compiler][acme-link]
1. [VICE (the Versatile Commodore Emulator)][vice-link]

Compressing the program requires [PUCrunch](https://github.com/mist64/pucrunc) but as requires building it from source code I have included a compiler version ready to go in the bin folder.

## Build Tasks

The project includes 3 [Visual Studio Code][vs-code-link] build tasks:

1. Assemble -> Compress: Assembles the program code and then uses pucrunch to compress the resulting program size
1. Assemble -> Compress -> C64: As above but then launches the VICE emulator and loads the new program
1. Assemble -> C64: As above but skips the compress step.

[online-c64]: https://www.retrodevops.com/c64.html
[retrodevops]: https://www.retrodevops.com
[vs-code-link]: https://code.visualstudio.com
[acme-link]: https://sourceforge.net/projects/acme-crossass
[vice-link]: http://vice-emu.sourceforge.net/

