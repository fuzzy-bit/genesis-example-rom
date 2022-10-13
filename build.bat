@echo off
"bin/asm68k.exe" /q /p "./src/Main.asm", "build.bin"
"bin/fixheadr.exe" "build.bin"
pause