#!/usr/bin/env bash

# Make an approximation of the CoCo 3 palette
../scripts/make-coco-palette.py --alpha palette.gif

# Main menu
convert -remap palette.gif -colors 13 +dither 00-mainmenu.png ../game/images/00-mainmenu.png

# Level 1
convert -remap palette.gif +dither -colors 17 01-sprites.png ../game/sprites/01-sprites.png
convert -remap palette.gif +dither -colors 17 -unique-colors 01-sprites.png 01-palette.png
convert -remap 01-palette.png +dither 01-moon.png ../game/tiles/01-moon.png

# Level 2
convert -remap palette.gif +dither -colors 16 02-space.png ../game/tiles/02-space.png
convert -remap palette.gif +dither -colors 16 02-level2.png ../game/images/02-level2.png


# Copy assets to hires game locations
cp 01-sprites.png ../game/hires/sprites/01-sprites.png
cp 01-moon.png ../game/hires/tiles/01-moon.png
cp 02-space.png ../game/hires/tiles/02-space.png

