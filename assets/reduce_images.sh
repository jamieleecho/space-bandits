#!/usr/bin/env bash

../scripts/make-coco-palette.py --alpha palette.gif
convert -remap palette.gif -colors 16 +dither 00-mainmenu.png ../game/images/00-mainmenu.png
convert -remap palette.gif -colors 16 01-level1.png ../game/images/01-level1.png
convert -remap palette.gif -colors 11 +dither 01-grave.png ../game/tiles/01-grave.gif
