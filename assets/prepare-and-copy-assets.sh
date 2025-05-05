#!/user/bin/env bash

convert 01-moon.png -remap coco3-palette.png -colors 15 -remap coco3-palette.png -fuzz 50% -background magenta -alpha remove -colors 15 -remap coco3-palette.png ../game/tiles/01-moon.png
cp 01-moon.png game/hires/tiles

convert 02-space.png -resize 480x480 +dither -remap coco3-palette.png -colors 15 +dither -remap coco3-palette.png +dither -fuzz 50% -background magenta -alpha remove ../game/tiles/02-space.png 

