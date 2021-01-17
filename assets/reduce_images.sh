#!/usr/bin/env bash

../scripts/make-coco-palette.py --alpha palette.gif
convert -remap palette.gif -colors 13 +dither 00-mainmenu.png ../game/images/00-mainmenu.png
convert -remap palette.gif -colors 16 +dither 01-moon.gif ../game/tiles/01-moon.gif
