#!/bin/sh

LUA=lua5.1
INC=/usr/include/$LUA

# nativefunc.c
gcc -I$INC nativefunc.c -c -fPIC
gcc nativefunc.o -shared -o libnativefunc.so

# window.c
gcc -I$INC window.c -l$LUA -o out-window

## stack.c
gcc -I$INC stack.c -l$LUA -o out-stack
