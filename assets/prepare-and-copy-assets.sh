#!/usr/bin/env bash

function create_color_map_with_magenta {
    local input_img=$1
    local input_filename="${input_img##*/}"
    local output_img="${input_filename%.png}_colormap.png"
    convert "${input_img}" -background magenta -unique-colors -extent 17x1 "${output_img}"
}


# Level 1
convert images/01-level1.png +dither -remap coco3-palette.png -colors 16 ../game/images/01-level1.png
cp images/01-level1.png ../game/hires/images
convert tiles/01-moon.png +dither -remap coco3-palette.png -colors 16 -remap coco3-palette.png ../game/tiles/01-moon.png
cp tiles/01-moon.png ../game/hires/tiles
create_color_map_with_magenta ../game/tiles/01-moon.png
convert sprites/01-sprites.png +dither -channel matte -threshold 0% -background magenta -alpha remove -remap 01-moon_colormap.png  ../game/sprites/01-sprites.png
convert sprites/01-sprites.png -channel matte -threshold 0% -background magenta -alpha remove ../game/hires/sprites/01-sprites.png

# Level 2
convert images/02-level2.png +dither -remap coco3-palette.png -colors 16 ../game/images/02-level2.png
convert tiles/02-space.png +dither -resize 480x480 -remap coco3-palette.png -colors 16 -remap coco3-palette.png ../game/tiles/02-space.png
cp tiles/02-space.png ../game/hires/tiles

# Level 3
convert images/03-level3.png -resize 96x96 -remap coco3-palette.png -colors 16 ../game/images/03-level3.png
cp images/03-level3.png ../game/hires/images
convert tiles/03-xmas.png +dither -resize 352x400 -remap coco3-palette.png -colors 16 -remap coco3-palette.png ../game/tiles/03-xmas.png
create_color_map_with_magenta ../game/tiles/03-xmas.png
convert tiles/03-xmas.png +dither -channel matte -threshold 0% -background magenta -resize 352x400 -alpha remove -remap 03-xmas_colormap.png ../game/sprites/03-candles.png
