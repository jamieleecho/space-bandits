#!/usr/bin/env bash

function create_color_map_with_magenta {
    local input_img=$1
    local input_filename="${input_img##*/}"
    local output_img="${input_filename%.png}_colormap.png"
    convert "${input_img}" -background magenta -unique-colors -extent 16x1 -unique-colors ${output_img}
}


# Level 1
convert images/01-level1.png -remap coco3-palette.png -colors 15 ../game/images/01-level1.png
cp images/01-level1.png ../game/hires/images
convert tiles/01-moon.png -remap coco3-palette.png -colors 15 -remap coco3-palette.png -fuzz 50% -background magenta -alpha remove -colors 15 -remap coco3-palette.png ../game/tiles/01-moon.png
cp tiles/01-moon.png ../game/hires/tiles
create_color_map_with_magenta ../game/tiles/01-moon.png
convert sprites/01-sprites.png -background magenta -alpha remove -remap 01-moon_colormap.png +dither ../game/sprites/01-sprites.png

# Level 2
convert tiles/02-space.png -resize 480x480 +dither -remap coco3-palette.png -colors 15 -remap coco3-palette.png ../game/tiles/02-space.png
cp tiles/02-space.png ../game/hires/tiles

# Level 3
convert tiles/03-xmas.png -resize 352x400 +dither -remap coco3-palette.png -colors 15 -remap coco3-palette.png ../game/tiles/03-xmas.png
create_color_map_with_magenta ../game/tiles/03-xmas.png
convert ../game/tiles/03-xmas.png -colors 15 -remap 03-xmas_colormap.png ../game/tiles/03-xmas.png
convert tiles/03-xmas.png -background magenta -resize 352x400 -alpha remove -remap 03-xmas_colormap.png +dither ../game/sprites/03-candles.png

