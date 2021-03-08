#!/usr/bin/env bash

../scripts/make-coco-palette.py --alpha palette.gif
convert -remap palette.gif -colors 13 +dither 00-mainmenu.png ../game/images/00-mainmenu.png
convert -remap palette.gif +dither -colors 17 01-sprites.png ../game/sprites/01-sprites.png
convert -remap palette.gif +dither -colors 17 -unique-colors 01-sprites.png 01-palette.png
convert -remap 01-palette.png +dither 01-moon.png ../game/tiles/01-moon.png

cp 01-sprites.png ../game/hires/sprites/01-sprites.png
cp 01-moon.png ../game/hires/tiles/01-moon.png
