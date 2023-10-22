# gameboy-music
Program made using RGBDS, gameboy rom that can work on any emulator. Plays musical notes based on input

To create the ROM, make sure you have RGBDS installed beforehand. 
This can be accessed at https://rgbds.gbdev.io/install/

In the same directory, run these scripts
```
$rgbasm -L -o music-program.o music-program.asm
$rgblink -o music-program.gb music-program.o
$rgbfix -v -p 0xFF music-program.gb
```
This will create a ROM file which should work on any gameboy emulator.
